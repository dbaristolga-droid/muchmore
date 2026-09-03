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
