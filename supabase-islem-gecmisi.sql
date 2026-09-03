-- Much&More - İşlem geçmişi (audit log) güncellemesi
-- Supabase > SQL Editor > New query > tamamını yapıştır > Run

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

-- Kullanıcı ve zamanı istemci değil Supabase belirlesin.
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

create policy "much_more_audit_select"
on public.audit_log for select
to authenticated
using (workspace_id = 'much-more-main');

create policy "much_more_audit_insert"
on public.audit_log for insert
to authenticated
with check (workspace_id = 'much-more-main');

-- Realtime: diğer cihazda yeni geçmiş kaydı anında görünsün.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'audit_log'
  ) then
    alter publication supabase_realtime add table public.audit_log;
  end if;
end $$;

create index if not exists audit_log_workspace_created_idx
on public.audit_log (workspace_id, created_at desc);
