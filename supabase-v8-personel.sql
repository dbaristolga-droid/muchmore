-- Much&More v8 — Personel Paneli ve güvenli rol sistemi
-- ÖNEMLİ: Bu SQL'i DJ / şef garson / aşçı hesaplarını oluşturmadan ÖNCE çalıştırın.
-- O anda Supabase Authentication'da bulunan mevcut hesaplar (mevcut yöneticiler) ilk kurulumda "admin" olarak işaretlenir.

create extension if not exists pgcrypto;

-- ============================================================
-- 1) KULLANICI ROLLERİ
-- ============================================================
create table if not exists public.mm_user_roles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','dj','sef_garson','asci')),
  display_name text,
  created_at timestamptz not null default now()
);

-- İlk kurulum: rol tablosu tamamen boşsa mevcut kullanıcıları yönetici kabul et.
do $$
begin
  if not exists (select 1 from public.mm_user_roles) then
    insert into public.mm_user_roles (user_id, role, display_name)
    select id, 'admin', coalesce(raw_user_meta_data ->> 'full_name', split_part(email, '@', 1))
    from auth.users;
  end if;
end $$;

create or replace function public.mm_current_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select role from public.mm_user_roles where user_id = auth.uid();
$$;

create or replace function public.mm_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select role = 'admin' from public.mm_user_roles where user_id = auth.uid()), false);
$$;

grant execute on function public.mm_current_role() to authenticated;
grant execute on function public.mm_is_admin() to authenticated;

alter table public.mm_user_roles enable row level security;
revoke all on table public.mm_user_roles from anon;
revoke insert, update, delete on table public.mm_user_roles from authenticated;
grant select on table public.mm_user_roles to authenticated;

drop policy if exists "mm_roles_select" on public.mm_user_roles;
create policy "mm_roles_select"
on public.mm_user_roles for select
to authenticated
using (user_id = auth.uid() or public.mm_is_admin());

-- SQL Editor'da personel rolünü kolayca atamak için yardımcı fonksiyon.
-- Uygulamadaki kullanıcılara bu fonksiyonu çağırma yetkisi verilmez.
create or replace function public.mm_set_user_role(p_email text, p_role text, p_display_name text default null)
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_uid uuid;
begin
  if p_role not in ('admin','dj','sef_garson','asci') then
    raise exception 'Geçersiz rol: %', p_role;
  end if;

  select id into v_uid from auth.users where lower(email) = lower(p_email) limit 1;
  if v_uid is null then
    raise exception 'Bu e-posta ile Authentication kullanıcısı bulunamadı: %', p_email;
  end if;

  insert into public.mm_user_roles(user_id, role, display_name)
  values (v_uid, p_role, coalesce(nullif(p_display_name,''), split_part(p_email,'@',1)))
  on conflict (user_id) do update
  set role = excluded.role,
      display_name = excluded.display_name;
end;
$$;

revoke all on function public.mm_set_user_role(text,text,text) from public, anon, authenticated;

-- ============================================================
-- 2) PERSONELİN GÖREBİLECEĞİ SANİTİZE PROGRAM
-- Müşteri adı, ödeme, fiyat, not, dosya vb. BURADA YOK.
-- ============================================================
create table if not exists public.mm_staff_schedule (
  workspace_id text not null default 'much-more-main',
  org_id text not null,
  event_date date not null,
  event_time text,
  person_count integer not null default 0,
  event_type text,
  status text not null default 'aktif',
  updated_at timestamptz not null default now(),
  primary key (workspace_id, org_id)
);

alter table public.mm_staff_schedule enable row level security;
revoke all on table public.mm_staff_schedule from anon;
revoke insert, update, delete on table public.mm_staff_schedule from authenticated;
grant select on table public.mm_staff_schedule to authenticated;

drop policy if exists "mm_staff_schedule_select" on public.mm_staff_schedule;
create policy "mm_staff_schedule_select"
on public.mm_staff_schedule for select
to authenticated
using (
  workspace_id = 'much-more-main'
  and public.mm_current_role() in ('admin','dj','sef_garson','asci')
);

-- ============================================================
-- 3) SADECE DJ'YE AÇIK TELEFON + GÖRÜŞME DURUMU
-- ============================================================
create table if not exists public.mm_dj_private (
  workspace_id text not null default 'much-more-main',
  org_id text not null,
  phone text,
  contacted boolean,
  contacted_at timestamptz,
  contacted_by uuid,
  contacted_by_email text,
  updated_at timestamptz not null default now(),
  primary key (workspace_id, org_id)
);

alter table public.mm_dj_private alter column contacted drop not null;
alter table public.mm_dj_private alter column contacted drop default;

alter table public.mm_dj_private enable row level security;
revoke all on table public.mm_dj_private from anon;
revoke all on table public.mm_dj_private from authenticated;
grant select on table public.mm_dj_private to authenticated;
-- DJ sadece görüşme durumunu değiştirebilir; telefon sütununu değiştiremez.
grant update (contacted) on table public.mm_dj_private to authenticated;

drop policy if exists "mm_dj_private_select" on public.mm_dj_private;
drop policy if exists "mm_dj_private_update" on public.mm_dj_private;
create policy "mm_dj_private_select"
on public.mm_dj_private for select
to authenticated
using (
  workspace_id = 'much-more-main'
  and public.mm_current_role() in ('admin','dj')
);
create policy "mm_dj_private_update"
on public.mm_dj_private for update
to authenticated
using (
  workspace_id = 'much-more-main'
  and public.mm_current_role() = 'dj'
)
with check (
  workspace_id = 'much-more-main'
  and public.mm_current_role() = 'dj'
);

-- DJ görüşme durumunu değiştirdiğinde kullanıcı ve zaman veritabanında atanır.
create or replace function public.mm_set_dj_contact_actor()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.contacted is distinct from old.contacted then
    new.contacted_at := now();
    new.contacted_by := auth.uid();
    new.contacted_by_email := coalesce(auth.jwt() ->> 'email', 'dj');
  end if;
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists mm_dj_contact_actor on public.mm_dj_private;
create trigger mm_dj_contact_actor
before update of contacted on public.mm_dj_private
for each row execute function public.mm_set_dj_contact_actor();

-- DJ'nin yaptığı Evet/Hayır değişikliği yöneticilerin Geçmiş ekranına da düşsün.
create or replace function public.mm_log_dj_contact()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_label text;
begin
  if new.contacted is not distinct from old.contacted then
    return new;
  end if;

  select elem ->> 'musteri'
  into v_label
  from public.app_state s,
       jsonb_array_elements(coalesce(s.data -> 'organizasyonlar', '[]'::jsonb)) elem
  where s.id = 'much-more-main' and elem ->> 'id' = new.org_id
  limit 1;

  insert into public.audit_log(workspace_id, action, entity_type, entity_id, entity_label, detail)
  values (
    'much-more-main',
    'dj_gorusme_guncellendi',
    'dj_gorusme',
    new.org_id,
    coalesce(nullif(v_label,''), 'Organizasyon'),
    jsonb_build_object('aciklama', 'DJ görüşme sağlandı: ' || case when new.contacted then 'Evet' else 'Hayır' end)
  );
  return new;
end;
$$;

drop trigger if exists mm_dj_contact_audit on public.mm_dj_private;
create trigger mm_dj_contact_audit
after update of contacted on public.mm_dj_private
for each row execute function public.mm_log_dj_contact();

-- ============================================================
-- 4) APP_STATE'DEN PERSONEL PROGRAMINI OTOMATİK ÜRET
-- ============================================================
create or replace function public.mm_sync_staff_from_app_state()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.id <> 'much-more-main' then
    return new;
  end if;

  -- Silinen organizasyonları personel tablolarından da kaldır.
  delete from public.mm_staff_schedule s
  where s.workspace_id = 'much-more-main'
    and not exists (
      select 1
      from jsonb_array_elements(coalesce(new.data -> 'organizasyonlar', '[]'::jsonb)) elem
      where elem ->> 'id' = s.org_id
    );

  delete from public.mm_dj_private d
  where d.workspace_id = 'much-more-main'
    and not exists (
      select 1
      from jsonb_array_elements(coalesce(new.data -> 'organizasyonlar', '[]'::jsonb)) elem
      where elem ->> 'id' = d.org_id
    );

  -- Her personelin göreceği temel, hassas olmayan program.
  insert into public.mm_staff_schedule(workspace_id, org_id, event_date, event_time, person_count, event_type, status, updated_at)
  select
    'much-more-main',
    elem ->> 'id',
    case
      when coalesce(elem ->> 'tarih','') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' then (elem ->> 'tarih')::date
      else current_date
    end,
    nullif(elem ->> 'saat',''),
    case when coalesce(elem ->> 'kisiSayisi','') ~ '^[0-9]+$' then (elem ->> 'kisiSayisi')::integer else 0 end,
    coalesce(nullif(elem ->> 'tur',''), 'Organizasyon'),
    case when elem ->> 'durum' = 'iptal' then 'iptal' else 'aktif' end,
    now()
  from jsonb_array_elements(coalesce(new.data -> 'organizasyonlar', '[]'::jsonb)) elem
  where coalesce(elem ->> 'id','') <> ''
  on conflict (workspace_id, org_id) do update
  set event_date = excluded.event_date,
      event_time = excluded.event_time,
      person_count = excluded.person_count,
      event_type = excluded.event_type,
      status = excluded.status,
      updated_at = now();

  -- Telefon ayrı tabloda tutulur. Görüşme durumu korunur.
  insert into public.mm_dj_private(workspace_id, org_id, phone, updated_at)
  select
    'much-more-main',
    elem ->> 'id',
    nullif(elem ->> 'telefon',''),
    now()
  from jsonb_array_elements(coalesce(new.data -> 'organizasyonlar', '[]'::jsonb)) elem
  where coalesce(elem ->> 'id','') <> ''
  on conflict (workspace_id, org_id) do update
  set phone = excluded.phone,
      updated_at = now();

  return new;
end;
$$;

drop trigger if exists mm_sync_staff_trigger on public.app_state;
create trigger mm_sync_staff_trigger
after insert or update of data on public.app_state
for each row execute function public.mm_sync_staff_from_app_state();

-- Mevcut organizasyonları v8 tablolarına ilk kez aktar.
update public.app_state
set data = data
where id = 'much-more-main';

-- ============================================================
-- 5) ANA VERİ / GEÇMİŞ / DOSYALARI PERSONELDEN KAPAT
-- Personel yalnızca yukarıdaki sanitizasyon tablolarını okuyabilir.
-- ============================================================
alter table public.app_state enable row level security;
drop policy if exists "much_more_select" on public.app_state;
drop policy if exists "much_more_insert" on public.app_state;
drop policy if exists "much_more_update" on public.app_state;
create policy "much_more_select" on public.app_state for select to authenticated
using (id = 'much-more-main' and public.mm_is_admin());
create policy "much_more_insert" on public.app_state for insert to authenticated
with check (id = 'much-more-main' and public.mm_is_admin());
create policy "much_more_update" on public.app_state for update to authenticated
using (id = 'much-more-main' and public.mm_is_admin())
with check (id = 'much-more-main' and public.mm_is_admin());

alter table public.audit_log enable row level security;
drop policy if exists "much_more_audit_select" on public.audit_log;
drop policy if exists "much_more_audit_insert" on public.audit_log;
create policy "much_more_audit_select" on public.audit_log for select to authenticated
using (workspace_id = 'much-more-main' and public.mm_is_admin());
create policy "much_more_audit_insert" on public.audit_log for insert to authenticated
with check (workspace_id = 'much-more-main' and public.mm_is_admin());

-- Organizasyon dosyaları sadece yöneticilerde kalır.
drop policy if exists "muchmore_org_files_select" on storage.objects;
drop policy if exists "muchmore_org_files_insert" on storage.objects;
drop policy if exists "muchmore_org_files_update" on storage.objects;
drop policy if exists "muchmore_org_files_delete" on storage.objects;
create policy "muchmore_org_files_select" on storage.objects for select to authenticated
using (bucket_id = 'org-files' and name like 'much-more-main/%' and public.mm_is_admin());
create policy "muchmore_org_files_insert" on storage.objects for insert to authenticated
with check (bucket_id = 'org-files' and name like 'much-more-main/%' and public.mm_is_admin());
create policy "muchmore_org_files_update" on storage.objects for update to authenticated
using (bucket_id = 'org-files' and name like 'much-more-main/%' and public.mm_is_admin())
with check (bucket_id = 'org-files' and name like 'much-more-main/%' and public.mm_is_admin());
create policy "muchmore_org_files_delete" on storage.objects for delete to authenticated
using (bucket_id = 'org-files' and name like 'much-more-main/%' and public.mm_is_admin());

-- ============================================================
-- 6) REALTIME
-- ============================================================
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='mm_staff_schedule'
  ) then
    alter publication supabase_realtime add table public.mm_staff_schedule;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='mm_dj_private'
  ) then
    alter publication supabase_realtime add table public.mm_dj_private;
  end if;
end $$;

create index if not exists mm_staff_schedule_date_idx
on public.mm_staff_schedule(workspace_id, event_date);

-- ============================================================
-- PERSONEL HESAPLARINI AÇTIKTAN SONRA ÖRNEK ROL ATAMALARI
-- E-posta adreslerini kendi personelinizin adresleriyle değiştirip SQL Editor'da çalıştırın:
--
-- select public.mm_set_user_role('dj@ornek.com', 'dj', 'DJ');
-- select public.mm_set_user_role('sefgarson@ornek.com', 'sef_garson', 'Şef Garson');
-- select public.mm_set_user_role('asci@ornek.com', 'asci', 'Aşçı');
--
-- Rolleri kontrol etmek için:
-- select u.email, r.role, r.display_name
-- from public.mm_user_roles r join auth.users u on u.id = r.user_id
-- order by r.role, u.email;
