# Much&More v7 — CRM / Yaklaşan İşler / Dosyalar

Bu sürüm şunları ekler:

- **İşler** sekmesi: müşteri adı, telefon, not, tür, durum ve aya göre arama/filtreleme.
- **Yaklaşan** sekmesi: 7 gün ve 30 gün yaklaşan organizasyonlar, ödeme bekleyen işler ve detay görüşmeleri.
- **Tahsilat uyarısı**: aktif iş yaklaşırken kalan ödeme varsa uyarı verir.
- **Müşteri iletişim geçmişi**: Telefon, WhatsApp, yüz yüze, e-posta veya diğer kanal üzerinden görüşme notları; ekleyen kullanıcı ve tarih/saat görünür.
- **Dosyalar ve ekler**: sözleşme, ödeme dekontu, dekorasyon görseli, menü/tasarım veya diğer dosyalar Supabase Storage'a yüklenir. Maksimum 10 MB/dosya.
- Dosya ve iletişim işlemleri **Geçmiş** ekranına da kaydolur.

## Kurulum

1. Önce Supabase > SQL Editor'da `supabase-v7-dosyalar.sql` dosyasının tamamını çalıştırın.
2. `Success. No rows returned` gördükten sonra ZIP içindeki tüm dosyaları GitHub repo köküne yükleyip Commit changes yapın.
3. GitHub Actions'ta Pages deployment yeşil olunca siteyi yenileyin.
4. Eski önbellek görünürse Opera'da site verilerini temizleyip tekrar giriş yapın.

Bu SQL yalnızca ortak dosya alanını ekler. Mevcut organizasyon, ödeme, gider, iptal/iade ve işlem geçmişi verilerini silmez.
