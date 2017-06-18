self.addEventListener('install', function(e) {
  console.log('Installing cache');
  
  e.waitUntil(
    caches.open('numbers-app').then(function(cache) {
      return cache.addAll([
        'index.html',
        'elm.js',
      ]);
    })
  );
});

self.addEventListener('fetch', function(event) {
  console.log('checking cache', event.request);

  // If there's a cached version available, use it, but fetch an update for next time.
  event.respondWith(
    caches.open('numbers-app').then(function(cache) {
      return cache.match(event.request).then(function(response) {
        var fetchPromise = fetch(event.request).then(function(networkResponse) {
          cache.put(event.request, networkResponse.clone());
          return networkResponse;
        })
        return response || fetchPromise;
      })
    })
  );
});
