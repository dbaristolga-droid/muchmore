# Much&More v8 — Personel Paneli

Bu sürümde DJ, Şef Garson ve Aşçı için sınırlı hesap sistemi eklendi.

## Yetkiler

- **Yönetici:** Mevcut panelin tamamını görür ve düzenler.
- **DJ:** Organizasyon tarihi, saati, türü, kişi sayısı, iptal durumu ve müşteri telefonunu görür. Ayrıca **Görüşme sağlandı mı? Evet / Hayır** alanını değiştirebilir.
- **Şef Garson:** Yalnızca tarih, saat, tür, kişi sayısı ve iptal durumunu görür.
- **Aşçı:** Yalnızca tarih, saat, tür, kişi sayısı ve iptal durumunu görür.

Müşteri adı, fiyatlar, ödemeler, giderler, raporlar, notlar, dosyalar ve işlem geçmişi personel hesaplarına Supabase RLS seviyesinde kapalıdır.

## Kurulum sırası

1. **Önce** Supabase SQL Editor'da `supabase-v8-personel.sql` dosyasını çalıştırın. O anda var olan mevcut yönetici hesapları otomatik `admin` olur.
2. Daha sonra Supabase Authentication > Users bölümünden DJ, Şef Garson ve Aşçı için ayrı kullanıcı hesapları oluşturun.
3. SQL Editor'da aşağıdaki örnekleri kendi e-posta adreslerinizle çalıştırın:

```sql
select public.mm_set_user_role('dj@ornek.com', 'dj', 'DJ');
select public.mm_set_user_role('sefgarson@ornek.com', 'sef_garson', 'Şef Garson');
select public.mm_set_user_role('asci@ornek.com', 'asci', 'Aşçı');
```

4. v8 ZIP içindeki dosyaları GitHub deposuna yükleyip commit edin.
5. Personel kendi e-posta ve şifresiyle aynı PWA adresinden giriş yapar. Rolüne göre otomatik olarak sade Personel Programı açılır.

## DJ görüşme takibi

DJ bir organizasyonda **Evet** veya **Hayır** seçtiğinde seçim Supabase'de saklanır. Yönetici organizasyon detayında DJ görüşme durumunu görür ve işlem ayrıca yöneticilerin **Geçmiş** sekmesine kaydolur.

## Tarih değişikliği / iptal

Yönetici organizasyon tarihini değiştirdiğinde personel programı otomatik yeni tarihe geçer. İptal edilen organizasyon personel ekranında **İPTAL EDİLDİ** olarak görünür.
