# Much & More v9 — Profesyonel Yönetim Paneli

Bu sürüm mevcut verileri silmeden v8 üzerine kurulmuştur.

## Yeni özellikler
- Much & More logosu ile tamamen yenilenmiş premium arayüz
- Yönetici ana paneli: aylık tahsilat, faaliyet neti, şahsi gider, açık alacak, yaklaşan işler
- Organizasyon detayından sonradan tahsilat ekleme
- Tahsilat yöntemi: Nakit / Havale / POS / Diğer
- Tahsilatların gerçek ödeme tarihine göre aylık rapora yazılması
- Organizasyon kontrol listesi
- Aşçı panelinde menü türü
- Şef garson panelinde otomatik garson sayısı (15 kişiye 1 garson)
- Yeni organizasyonlarda DJ 7.000 TL ve aşçı 6.000 TL varsayılan gider
- Şahsi harcamaların işletme giderlerinden ayrı raporlanması
- Faaliyet neti ve şahsi harcamalar sonrası kasa neti
- Logolu profesyonel PDF / geliştirilmiş Excel raporu

## Veriler
Mevcut 43 organizasyon, personel programları, ödeme geçmişi, kullanıcı rolleri ve audit kayıtları korunur.

## Kurulum
ZIP içindeki dosyaları GitHub Pages reposunun kök dizinine yükleyip mevcut dosyaların üzerine yazın. Supabase v9 veritabanı güncellemeleri zaten uygulanmıştır.

## v9.1 düzeltmeleri
- Yeni tahsilat kaydedildiği anda organizasyonun alınan tutarı ve kalan bakiyesi artık `mm_payments` tablosundan hesaplanır.
- Aylık tahsilat raporu da aynı ödeme tablosunu kaynak alır; app_state gecikmesi bakiye/rapor farkı yaratmaz.
- Tahsilat kartında toplam tahsilat ve güncel kalan bakiye ayrıca gösterilir.
- Takvimde yalnızca bir organizasyon bulunan güne dokununca doğrudan organizasyon detayına girilir. Birden fazla organizasyon varsa günlük seçim paneli açılır.
- Service Worker sürümü yükseltildi; eski önbellek yeni sürümü engellemez.
