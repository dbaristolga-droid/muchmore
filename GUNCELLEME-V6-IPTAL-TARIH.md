# Much&More v6 — İptal, para iadesi ve tarih değişikliği

Bu sürümde yeni SQL çalıştırmanız gerekmez. Mevcut `app_state` JSON yapısı ve `audit_log` tablosu yeterlidir.

## Yeni özellikler
- Organizasyon durumu: Aktif / İptal edildi.
- İptal tarihi ve iptal nedeni/notu.
- Para iadesi yapıldı mı? seçeneği.
- İade tutarı ve iade tarihi.
- İade, iade tarihinin bulunduğu ayda gider olarak rapora düşer.
- İptal edilen işin kalan tahsil edilecek tutarı 0 olur.
- İptal edilen iş aktif satış toplamına dahil edilmez.
- Alınmış ödemeler geçmiş aylarda tahsilat olarak kalır; iade yapıldığında iade gideri ayrı gösterilir.
- Organizasyon tarihi düzenleme ekranından değiştirilebilir.
- Tarih değişirse eski tarih → yeni tarih ve not, organizasyon detayında kalıcı geçmiş olarak saklanır.
- İptal, iade ve tarih değişiklikleri İşlem Geçmişi'ne kullanıcı bilgisiyle yazılır.
- PDF ve Excel raporlarına durum / iade alanları eklendi.

## Güncelleme
ZIP içindeki dosyaları mevcut GitHub Pages reposuna aynı isimlerle yükleyin ve Commit changes yapın.
`sw.js` önbellek sürümü v6 olarak güncellendi. GitHub Pages deploy bittikten sonra sayfayı bir kez yenileyin.
