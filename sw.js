/* Much&More Organizasyon Yönetimi — çevrimdışı önbellek */
const SURUM = "much-more-v3";
const DOSYALAR = [
  "./",
  "./index.html",
  "./manifest.json",
  "./ikon.png",
  "./ikon-192.png",
  "./ikon-512.png"
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(SURUM).then((c) => c.addAll(DOSYALAR)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys()
      .then((adlar) => Promise.all(adlar.filter((a) => a !== SURUM).map((a) => caches.delete(a))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  if (e.request.method !== "GET") return;
  e.respondWith(
    fetch(e.request)
      .then((yanit) => {
        const kopya = yanit.clone();
        caches.open(SURUM).then((c) => c.put(e.request, kopya)).catch(() => {});
        return yanit;
      })
      .catch(() => caches.match(e.request).then((v) => v || caches.match("./index.html")))
  );
});
