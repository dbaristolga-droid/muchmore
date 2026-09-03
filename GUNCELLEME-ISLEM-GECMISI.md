# Much&More — İşlem Geçmişi Güncellemesi

Bu sürümde uygulamaya **Geçmiş** sekmesi eklendi.

Kayıt altına alınan başlıca işlemler:
- Organizasyon ekleme, düzenleme ve silme
- Ödeme ekleme, değiştirme ve silme
- Organizasyon gideri ekleme, değiştirme ve silme
- Sabit gider ekleme/silme ve önceki aydan kopyalama
- Genel gider ekleme/silme
- Fiyat listesi ekleme/silme
- Genel ayar değişiklikleri

Her kayıtta Supabase tarafından kullanıcının e-postası ve işlem zamanı atanır. `audit_log` tablosunda oturum açmış uygulama kullanıcılarına UPDATE veya DELETE izni verilmez.

## Mevcut kurulum için
1. Supabase > SQL Editor > New query.
2. `supabase-islem-gecmisi.sql` içeriğinin tamamını yapıştırın ve Run deyin.
3. GitHub'da bu paketteki `index.html` ve `sw.js` dosyalarını mevcutların üstüne yükleyip Commit changes yapın. İsterseniz paketin tamamını da yükleyebilirsiniz.
4. Siteyi yeniden açın. Gerekirse sert yenileme yapın / PWA'yı kapatıp yeniden açın.
5. Alt menüde **Geçmiş** sekmesi görünür.

> Not: İşlem geçmişi bu güncellemeden sonra yapılan işlemleri kaydeder. Önceden yapılmış değişikliklerde kimin hangi işlemi yaptığını güvenilir biçimde geriye dönük oluşturmak mümkün değildir.
