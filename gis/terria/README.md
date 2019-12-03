# Konfiguration

Inden terria startes skal [config.json](terria/config.json) tilrettes så den indeholder url til den eller de konfigurationsfiler som bruges til at opsætte terria med data, styling osv.
```json
  initializationUrls: [
      "https://frederiksberg.github.io/terria/frb.json"
  ],
  ...
```
Ligeledes kan der angives token til Cesium Ion, hvis denne bruges til at hoste terræn og bymodeller.
```json
  ...
      cesiumIonAccessToken: "YOUR_TOKEN"
  }
```

Læs mere om terria og konfiguration [her](https://docs.terria.io/guide/)
