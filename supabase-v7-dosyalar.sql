-- Much&More v7 — ortak dosya alanı (Supabase Storage)
-- Bu dosyayı Supabase > SQL Editor > New query içinde bir kez çalıştırın.

-- 10 MB sınırla, özel (public olmayan) bucket oluştur / güncelle.
insert into storage.buckets (id, name, public, file_size_limit)
values ('org-files', 'org-files', false, 10485760)
on conflict (id) do update
set public = false,
    file_size_limit = 10485760;

-- Aynı isimde eski politika varsa temizle; script tekrar çalıştırılabilir olsun.
drop policy if exists "muchmore_org_files_select" on storage.objects;
drop policy if exists "muchmore_org_files_insert" on storage.objects;
drop policy if exists "muchmore_org_files_update" on storage.objects;
drop policy if exists "muchmore_org_files_delete" on storage.objects;

-- Sadece giriş yapmış kullanıcılar ve sadece bu uygulamanın klasörü.
create policy "muchmore_org_files_select"
on storage.objects for select
to authenticated
using (
  bucket_id = 'org-files'
  and name like 'much-more-main/%'
);

create policy "muchmore_org_files_insert"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'org-files'
  and name like 'much-more-main/%'
);

create policy "muchmore_org_files_update"
on storage.objects for update
to authenticated
using (
  bucket_id = 'org-files'
  and name like 'much-more-main/%'
)
with check (
  bucket_id = 'org-files'
  and name like 'much-more-main/%'
);

create policy "muchmore_org_files_delete"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'org-files'
  and name like 'much-more-main/%'
);
