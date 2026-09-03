# Much&More — Ortak Veritabanı Kurulumu

> **Bu paket Supabase projenize bağlanmış hazır sürümdür.** `config.js` içindeki Project URL ve publishable key doldurulmuştur. Secret/service-role anahtarı kullanılmamıştır.

Bu sürümde sen ve abin **aynı organizasyonları, ödemeleri, giderleri ve fiyat listelerini** görürsünüz. Giriş e-posta + şifre ile yapılır. Veriler Supabase üzerinde tutulur.

## 1) Supabase hesabı ve proje

1. https://supabase.com adresine girip ücretsiz hesap aç.
2. **New project** ile yeni proje oluştur.
3. Proje adı örneğin `much-more-organizasyon` olabilir.
4. Database password için güçlü bir şifre belirle ve sakla.
5. Proje hazır olunca devam et.

## 2) Veritabanını tek seferde kur

1. Supabase sol menüden **SQL Editor** aç.
2. **New query** de.
3. Bu ZIP'teki `supabase-kurulum.sql` dosyasının tamamını kopyala.
4. SQL Editor'a yapıştır ve **Run** de.
5. Hata vermeden tamamlanırsa veritabanı hazır.

Bu SQL; `app_state` tablosunu, giriş yapmış kullanıcılar için RLS güvenliğini ve anlık senkronizasyonu kurar.

## 3) Sadece sen ve abin için kullanıcı oluştur

1. Supabase'de **Authentication > Users** bölümüne gir.
2. **Add user** üzerinden senin için bir kullanıcı oluştur / davet gönder.
3. Aynı işlemi abin için yap.
4. İkiniz de kendi e-posta ve şifrenizle giriş yapacaksınız.
5. **Authentication** ayarlarında **Allow new users to sign up** seçeneğini kapalı tut. Böylece uygulama linkini bilen biri kendi kendine hesap açamaz.

> Uygulamanın içinde kayıt olma ekranı yoktur; yalnızca Supabase'de oluşturduğun kullanıcılar giriş yapabilir.

## 4) Project URL ve Publishable key'i al

Supabase Dashboard'da projenin API ayarlarında iki değer gerekir:

- **Project URL**
- **Publishable key** (`sb_publishable_...`; eski projelerde anon key de görünebilir)

**Secret key / service_role key KULLANMA.** Onu web sitesine kesinlikle koyma.

## 5) config.js dosyasını doldur

ZIP'teki `config.js` dosyasını metin düzenleyiciyle aç. Şu iki satırı Supabase'den aldığın değerlerle değiştir:

```js
supabaseUrl: "https://PROJE.supabase.co",
supabasePublishableKey: "sb_publishable_...",
```

`workspaceId: "much-more-main"` aynı kalsın.

## 6) GitHub Pages'e yükle / güncelle

### Daha önce repo açmadıysan

1. GitHub'da **New repository** aç. Örn. `much-more-defter`.
2. Public oluştur.
3. Bu ZIP'teki dosyaların tamamını repo köküne yükle. Klasörün kendisini değil, içindeki dosyaları yükle.
4. **Settings > Pages** bölümüne gir.
5. Source: **Deploy from a branch**.
6. Branch: **main**, folder: **/(root)** ve **Save**.
7. GitHub Pages adresini Safari'de aç.

### Eski PWA zaten GitHub Pages'teyse

En iyisi **aynı repo ve aynı adresi korumak**. Eski dosyaların üzerine bu sürümdeki dosyaları yükle. Özellikle şu yeni dosyalar da repo kökünde bulunmalı:

- `config.js`
- `supabase-kurulum.sql` (uygulama için şart değil ama saklanabilir)
- `index.html`
- `sw.js`
- `manifest.json`
- ikon dosyaları

Aynı adresi korursan eski sürümün telefonda tuttuğu kayıtlar ilk bulut girişinde otomatik olarak Supabase'e aktarılır.

## 7) iPhone'a uygulama gibi kur

1. GitHub Pages adresini **Safari** ile aç.
2. Giriş yap.
3. Paylaş düğmesi > **Ana Ekrana Ekle**.
4. Abin de kendi telefonunda aynı adresi açıp kendi hesabıyla giriş yapsın ve Ana Ekrana Ekle desin.

## 8) Ortak kullanım testi

1. Sen telefondan test organizasyonu ekle ve kaydet.
2. Abinin telefonunda birkaç saniye içinde aynı kayıt görünmeli.
3. Abin kayda bir ödeme eklesin.
4. Sende de güncelleme otomatik görünmeli.

Üst sağda yeşil nokta ile `Bulutta güncel` / `senkron` durumu görünür.

## Güvenlik

- Publishable key tarayıcı uygulamalarında kullanılmak üzere tasarlanmıştır; asıl veri güvenliği RLS ve kullanıcı oturumu ile sağlanır.
- `secret` veya `service_role` anahtarını asla GitHub'a, `config.js` içine veya başka bir frontend dosyasına koyma.
- Yeni kullanıcı kaydını kapalı tut ve sadece yetkili kişileri Supabase Authentication bölümünden ekle.

## Eski verilerin taşınması

Eski uygulamayı aynı GitHub Pages adresinde kullandıysan, tarayıcıdaki `org-defteri:v2` verisi korunur. Ortak veritabanı ilk kez boşken sen giriş yaptığında mevcut yerel veri otomatik olarak ortak kayda yüklenir.

İlk bulut kurulumunu, eski verilerin bulunduğu **senin telefonundan** açman en güvenli yöntemdir. Bundan sonra abin giriş yapabilir.