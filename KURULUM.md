# Organizasyon Defteri — Kurulum

## Dosyalar

| Dosya | Ne işe yarar |
|---|---|
| `index.html` | Uygulamanın tamamı |
| `manifest.json` | Ana ekrana eklendiğinde ikon ve isim |
| `sw.js` | İnternet yokken de açılmasını sağlar |
| `ikon.png`, `ikon-192.png`, `ikon-512.png` | Ana ekran ikonu |

Altısı da **aynı klasörde** durmalı.

## 1. Yayına alma

PWA'nın çalışması için dosyaların bir adreste (https ile) durması gerekir. Ücretsiz üç yol:

**Netlify Drop** (en kolay, 2 dakika)
1. `app.netlify.com/drop` adresine gir
2. Altı dosyanın olduğu klasörü sayfaya sürükle
3. Sana `rastgele-isim.netlify.app` gibi bir adres verir
4. Site ayarlarından adı değiştirebilirsin

**GitHub Pages** — Ücretsiz, biraz daha teknik.

**Kendi alan adın** — Zaten bir siteniz varsa dosyaları bir alt klasöre atmanız yeterli.

## 2. iPhone'a kurma (her personel için bir kez)

1. **Safari** ile adresi aç (Chrome ile olmaz)
2. Alttaki paylaş tuşuna bas
3. **"Ana Ekrana Ekle"**
4. İsmi onayla

Artık ana ekranda ikonuyla duruyor, dokununca tam ekran açılıyor.

## 3. İlk ayarlar

**Fiyatlar sekmesi** → kişi başı ordövr / et / tavuk fiyatlarını gir.
Zam yaptığında eskisini silme, yeni tarihle yeni liste ekle. Eski işler eski fiyattan kalır.

**Giderler sekmesi** → o ayın kira, aidat, stopaj tutarlarını gir.
Sonraki ay "Önceki aydan kopyala" ile tek tuşta gelir.

**Ayarlar** → garson oranı (varsayılan 10 kişiye 1) ve fatura oranı (%20).

## 4. Önemli: veri nerede duruyor

Şu haliyle veriler **her telefonun kendi içinde** duruyor. Yani senin girdiğin bir organizasyon,
personelinin telefonunda görünmez.

Ekibin aynı kayıtları görmesi için ortak bir veritabanı gerekiyor (Supabase veya Firebase —
bu ölçekte ücretsiz kademe yeter). Kurulduğunda değişen tek şey, uygulamanın verileri
kendi telefonu yerine oradan okuması olur.

**O zamana kadar:** kayıtları tek bir telefondan girin, ayda bir
Fiyatlar → "Yedek indir" ile yedek alın.

## 5. Günlük kullanım

- **Takvim** — güne dokun, "+ Organizasyon" ile ekle. Takvimde her günün sağ üstündeki
  renkli kutucuk o işin perde rengi.
- **Organizasyon içi** — Genel, Menü, Dekorasyon, Tasarım, Ödemeler, Giderler bölümleri.
  Alttaki koyu şeritte toplam anlık güncellenir.
- **Ödemeler** — kaporayı ve son ödemeyi kendi tarihiyle girin. Gelir o ayın hesabına yazılır.
- **Rapor** — ay seç, kalem kalem gelir/gider gör, PDF veya Excel al.
