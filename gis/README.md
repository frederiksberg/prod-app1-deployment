# GIS værktøjer

Vi benytter en række applikationer til at udstille og style geografiske data:

* [Tilehut](https://github.com/b-g/tilehut)
* [PostgREST API/Swagger](https://github.com/frederiksberg/PostgREST)
* [Maputnik](https://maputnik.github.io/)
* [Anlægskort](https://github.com/frederiksberg/Vector-DigitaltAnlaeg)

## Tilehut

Ustiller mapbox raster tiles med UTF-grid (`.mbtiles`) til BorgerGIS-løsinger. Dette er en midlertidig løsning, som på sigt bliver erstattet med [Vector Tiles projektet](https://github.com/frederiksberg/vector-tile-server).

## PostgREST API/Swagger

Simpel løsning til at udstile geodata fra den interne GC2-database som GeoJSON. Fungerer ved brug af tagging i GC2, hvorefter tabellerne natligt overføres til API databasen, hvorefter de er tilgængelige.

## Maputnik

Brugergrænseflade til at style vector data ved f.eks. at angive en TileJSON URL og skal bruges i sammenhæng med vector tile server.

## Anlægskort

Kortløsning over kommunens og forsyningens anlægsprojekter, hvor der er mulighed for at redigere i data. Løsninger består både af [VectorTile-Project](https://github.com/frederiksberg/VectorTile-Project) og [Vector-DigitaltAnlaeg](https://github.com/frederiksberg/Vector-DigitaltAnlaeg) som henholdsvis er server og frontend applikationer.

# Sikkerhed og DNS

Der er opsat

## Eksmepler på URL'er

API 
* Swagger - https://api.frb-data.dk
* GeoJSON - http://api.frb-data.dk/v1/data/anlaegsprojekter_fk?srid=25832

Anlægskort
* https://gis.frederiksberg.dk/vectorAnl%C3%A6g

Maputnik
* https://api.frb-data.dk
