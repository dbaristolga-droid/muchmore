# Supabase v9 durumu

Bu üretim projesinde v9 veritabanı değişiklikleri uygulanmıştır.

Eklenen profesyonel altyapı:
- `mm_payments`: tarih/yöntem/not içeren normalleştirilmiş tahsilatlar
- `mm_org_checklist`: organizasyon hazırlık kontrol listesi
- `mm_add_payment(...)`: tahsilatı ödeme tablosuna ve mevcut `app_state` verisine atomik olarak ekleyen yönetici RPC'si
- Personel programında `menu_type` ve `waiter_count`
- Garson oranı: 15 kişiye 1 garson
- Realtime ve RLS güvenlik düzenlemeleri

Mevcut üretim verileri korunmuştur. 14.09.2026 15:49 öncesi tam snapshot ayrıca alınmıştır.
