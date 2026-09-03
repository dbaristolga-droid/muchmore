# Much&More PWA v3 — Değişiklikler

- 50–80 kişi fiyatları: Ordövr 2.340 TL, Et 2.850 TL, Tavuk 2.750 TL
- 100+ kişi fiyatları: Ordövr 1.950 TL, Et 2.350 TL, Tavuk 2.250 TL
- 81–99 kişi için pazarlık/özel fiyat uyarısı
- Organizasyon bazında fiyat listesi sabitleme; yeni zamlar eski işleri değiştirmez
- Anlaşılan kişi başı fiyatı düzenlenebilir
- Masa düzeni kaldırıldı; Masa Üzeri Dekorasyon serbest not alanına dönüştürüldü
- Zemin kaplama yalnızca tutar alanına dönüştürüldü
- Birden fazla Ekstra Dekorasyon açıklama+tutar kalemi eklendi
- Garson gideri 10 kişiye 1 garson ve 2.000 TL/garson varsayılanıyla otomatik
- Garson yol/ek ücret açıklaması ve tutarı eklendi
- DJ gideri ve Mutfak Personeli gideri ayrı alanlara ayrıldı
- Geçmiş/gelecek ay rapor navigasyonu sağlamlaştırıldı
- Tahsilatlar ödeme tarihine göre aylık gelire bağlandı
- Organizasyon sözleşme değeri ile nakit tahsilat raporda ayrı gösterildi
- Personel giderleri organizasyon ayı raporuna otomatik girer
- Profesyonel A4 PDF yazdırma düzeni
- Özet, Tahsilatlar, Giderler ve Organizasyonlar sayfaları içeren Excel uyumlu .xls çıktı
- Much&More marka başlığı ve PWA manifest adı güncellendi
- Service Worker önbellek sürümü yükseltildi


## v4 — Ortak kullanım
- Supabase ortak veritabanı eklendi.
- E-posta + şifre giriş ekranı eklendi.
- RLS ile giriş yapmamış kullanıcıların veri erişimi kapatıldı.
- İki cihaz arasında Realtime otomatik yenileme eklendi.
- Aynı anda farklı kayıtlarda yapılan değişiklikler için üç yollu birleştirme eklendi.
- Eski localStorage verisinin ilk bulut kurulumunda otomatik taşınması eklendi.
- Üst bölümde senkron durum göstergesi ve çıkış eklendi.
