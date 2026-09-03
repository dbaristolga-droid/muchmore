# Much&More Organizasyon Yönetimi — Kurulum

## Dosyalar

Aşağıdaki dosyaların tamamı aynı klasörde durmalı:

- `index.html` — uygulamanın tamamı
- `manifest.json` — PWA adı ve ana ekran ayarları
- `sw.js` — çevrimdışı önbellek
- `ikon.png`, `ikon-192.png`, `ikon-512.png` — uygulama ikonları

## GitHub Pages ile yayınlama

1. `github.com` üzerinden ücretsiz hesap açın.
2. Sağ üstte **+ → New repository** seçin.
3. Repository adı olarak örneğin `much-more-defter` yazın.
4. **Public** seçip **Create repository** deyin.
5. Açılan depoda **Add file → Upload files** seçeneğine girin.
6. `index.html`, `manifest.json`, `sw.js`, `ikon.png`, `ikon-192.png`, `ikon-512.png` dosyalarının tamamını yükleyip **Commit changes** deyin.
7. **Settings → Pages** bölümüne girin.
8. **Source: Deploy from a branch** seçin.
9. **Branch: main**, klasör **/(root)** seçip **Save** deyin.
10. Birkaç dakika sonra adresiniz şu formatta oluşur: `https://kullaniciadi.github.io/much-more-defter/`

### Güncelleme yaparken

Yeni ZIP'teki dosyaları aynı repository'ye aynı isimlerle tekrar yükleyin ve **Commit changes** yapın. `sw.js` sürümü güncellendiği için PWA yeni sürümü çevrimiçi olduğunda alacaktır. iPhone'da eski ekran kısa süre görünürse uygulamayı tamamen kapatıp yeniden açın.

## iPhone'a kurma

1. Yayın adresini **Safari** ile açın.
2. Paylaş düğmesine basın.
3. **Ana Ekrana Ekle** seçin.
4. Much&More adıyla kaydedin.

## Güncel fiyat sistemi

Uygulama başlangıçta şu listeyle gelir:

| Kişi | Ordövr | Et Menü | Tavuk Menü |
|---|---:|---:|---:|
| 50–80 | 2.340 TL | 2.850 TL | 2.750 TL |
| 100+ | 1.950 TL | 2.350 TL | 2.250 TL |

81–99 kişi aralığında sistem 50–80 listesini başlangıç fiyatı olarak gösterir ve pazarlıklı kişi başı bedelin kontrol edilmesini ister. Organizasyon içindeki **Anlaşılan kişi başı bedel** alanı değiştirilebilir.

Yeni bir fiyat listesi eklendiğinde mevcut organizasyonların fiyatı değişmez. Her organizasyon kullandığı fiyat listesini kendi kaydında sabitler.

## Personel giderleri

- Garson oranı varsayılan: **10 kişiye 1 garson**
- Garson başı ücret varsayılan: **2.000 TL**
- Garson yol / ek ücret için açıklama ve tutar alanı vardır.
- **DJ gideri** ayrı tutulur.
- **Mutfak personeli gideri** ayrı tutulur.
- Bu giderler organizasyon tarihinin ayındaki rapora otomatik girer.

## Dekorasyon

- Tavan süslemesi: renk + açıklama + ücret
- Perde süslemesi: renk + açıklama + ücret
- Zemin kaplama: tek model, yalnızca ücret
- Masa üzeri dekorasyon: yalnızca serbest not, ücrete eklenmez
- Ekstra dekorasyon: açıklama + ücret; birden fazla kalem eklenebilir ve müşteri toplamına dahil edilir

## Rapor mantığı

- Kapora, ara ödeme ve son ödeme **hangi tarihte tahsil edildiyse o ayın gelirine** yazılır.
- Organizasyonun toplam sözleşme değeri ayrıca ayın organizasyonları bölümünde görünür.
- Personel giderleri organizasyon tarihinin ayına girer.
- Diğer giderler kendi girilen tarihine göre raporlanır.
- Rapor ekranında geçmiş/gelecek ay geçişi yapılabilir.
- Çıktılar: profesyonel yazdırılabilir PDF ve çok sayfalı Excel uyumlu `.xls` dosyası.

## Veri saklama

Bu sürümde veriler hâlâ cihazın tarayıcı/PWA depolamasında tutulur. Aynı kayıtların birden fazla telefon tarafından ortak görülmesi için sonraki aşamada Supabase/Firebase gibi ortak veritabanı bağlantısı gerekir.

Ortak veritabanı kurulana kadar düzenli olarak **Fiyatlar → Yedek indir (JSON)** kullanın.
