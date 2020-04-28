# GIS værktøjer

Vi benytter en række applikationer til at udstille og style geografiske data:

* [Tilehut](https://github.com/frederiksberg/prod-app1-deployment/tree/master/gis/tilehut)
* [PostgREST API/Swagger](https://github.com/frederiksberg/PostgREST)
* [Vector tile server (Tegola/Maputnik)](https://github.com/frederiksberg/prod-app1-deployment/tree/master/gis/vector-tiles)
* [Terria](terria)
* [OSRM](osrm)

## Tilehut

Ustiller mapbox raster tiles med UTF-grid (`.mbtiles`) til BorgerGIS-løsinger. Dette er en midlertidig løsning, som på sigt bliver erstattet med [Vector Tiles projektet](https://github.com/frederiksberg/prod-app1-deployment/tree/master/gis/vector-tiles).

## PostgREST API/Swagger

Simpel løsning til at udstile geodata fra den interne GC2-database som GeoJSON. Fungerer ved brug af tagging i GC2, hvorefter tabellerne natligt overføres til API databasen, hvorefter de er tilgængelige.

## Tegola

Tegola er koblet op på PostgreSQL/PostGIS og udstiller vector tiles.

## Maputnik

Brugergrænseflade til at style vector data ved f.eks. at angive en TileJSON URL og skal bruges i sammenhæng med vector tile server.

## Terria

GIS løsning som kan vise både 2- og 3D kort. Bruger Leaflet til 2D og Cesium som 3D motor og integrere med Cesium Ion, som kan bruges til at serve bymodeller som 3D tiles og højdemodeller.

## OSRM

Rutebergener API som bruger vejdata fra Open Steet Map til at løse ruteoptimering.

## Eksmepler på URL'er

API

* Swagger - https://api.frb-data.dk
* GeoJSON - http://api.frb-data.dk/v1/data/anlaegsprojekter_fk?srid=25832

Anlægskort

* https://gis.frederiksberg.dk/vectorAnl%C3%A6g

Maputnik

* https://maputnik.frb-data.dk

OSRM

* https://rute.frb-data.dk

## Kilder

* [Tilehut](https://github.com/b-g/tilehut)
* [PostgREST API/Swagger](https://github.com/frederiksberg/PostgREST)
* [Tegola](https://github.com/go-spatial/tegola)
* [Maputnik](https://maputnik.github.io/)
* [Terria](https://terria.io/)
* [OSRM](http://project-osrm.org/)
