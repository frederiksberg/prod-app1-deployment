# Vector-tile-server
Simpelt setup til serving og styling af vector tiles med [Tegola](https://tegola.io/) og [Maputnik](https://maputnik.github.io/)

## Getting started
1. Tilret [`config.toml`](https://github.com/frederiksberg/frederiksberg.github.io/blob/master/tegola/config.toml) 
2. `docker-compose up`

## Tegola
Appilkation til at serve vector tiles fra PostGIS.

### Konfiguration
Før Tegola serveren startes skal der laves konfiguration i en `config.toml` fil som hentes direkte fra Github Pages (kan også ligge lokalt) når serveren starter op. Forbindelsen til databasen fremgår også i filen, men bliver sat med miljøvariable på serveren, så de ikke eksponeres. 

Når der er lavet ændringer i `config.toml` på Github skal Tegola genstartes, så ændringerne slår igennem. Dette gøres nemmest ved at genstarte tegola containeren med `docker restart <tegola-container>`.

Vær opmærksom på at fejl i konfigurationsfilen gør at Tegola serveren fejler når den genstarte. Hvis dette sker kan `docker logs <tegola-container>` bruges til at finde fejlen da Tegola skriver fejlen til loggen. 

#### Environment Variables
Forbindelsen til databasen opsættes i `.env` filen. 

## Maputnik
Webapp til at generere styling til vector tiles.
