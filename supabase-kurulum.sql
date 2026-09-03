-- Much&More Organizasyon Yönetimi - Ortak veritabanı kurulumu
-- Supabase > SQL Editor > New query alanına tamamını yapıştırıp Run deyin.

create table if not exists public.app_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by text
);

alter table public.app_state enable row level security;

-- Siteye giriş yapmamış hiç kimse tabloyu okuyamaz/yazamaz.
revoke all on table public.app_state from anon;
grant select, insert, update on table public.app_state to authenticated;

drop policy if exists "much_more_select" on public.app_state;
drop policy if exists "much_more_insert" on public.app_state;
drop policy if exists "much_more_update" on public.app_state;

create policy "much_more_select"
on public.app_state for select
to authenticated
using (id = 'much-more-main');

create policy "much_more_insert"
on public.app_state for insert
to authenticated
with check (id = 'much-more-main');

create policy "much_more_update"
on public.app_state for update
to authenticated
using (id = 'much-more-main')
with check (id = 'much-more-main');

-- Realtime: bir cihazdaki değişiklik diğer cihazda otomatik görünsün.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'app_state'
  ) then
    alter publication supabase_realtime add table public.app_state;
  end if;
end $$;

-- ============================================================
-- İŞLEM GEÇMİŞİ (AUDIT LOG)
-- ============================================================

create extension if not exists pgcrypto;

create table if not exists public.audit_log (
  id uuid primary key default gen_random_uuid(),
  workspace_id text not null default 'much-more-main',
  action text not null,
  entity_type text not null default 'genel',
  entity_id text,
  entity_label text,
  detail jsonb not null default '{}'::jsonb,
  actor_user_id uuid,
  actor_email text,
  created_at timestamptz not null default now()
);

create or replace function public.much_more_set_audit_actor()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.actor_user_id := auth.uid();
  new.actor_email := coalesce(auth.jwt() ->> 'email', 'yetkili');
  new.created_at := now();
  new.workspace_id := 'much-more-main';
  return new;
end;
$$;

drop trigger if exists much_more_audit_actor on public.audit_log;
create trigger much_more_audit_actor
before insert on public.audit_log
for each row execute function public.much_more_set_audit_actor();

alter table public.audit_log enable row level security;
revoke all on table public.audit_log from anon;
revoke update, delete on table public.audit_log from authenticated;
grant select, insert on table public.audit_log to authenticated;

drop policy if exists "much_more_audit_select" on public.audit_log;
drop policy if exists "much_more_audit_insert" on public.audit_log;
create policy "much_more_audit_select" on public.audit_log for select to authenticated using (workspace_id = 'much-more-main');
create policy "much_more_audit_insert" on public.audit_log for insert to authenticated with check (workspace_id = 'much-more-main');

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'audit_log'
  ) then
    alter publication supabase_realtime add table public.audit_log;
  end if;
end $$;

create index if not exists audit_log_workspace_created_idx on public.audit_log (workspace_id, created_at desc);
