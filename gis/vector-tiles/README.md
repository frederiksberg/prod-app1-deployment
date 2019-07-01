# Vector-tile-server
Simpelt setup til serving og styling af vector tiles med [Tegola](https://tegola.io/) og [Maputnik](https://maputnik.github.io/)

## Getting started
1. Tilret [`config.toml`](https://github.com/frederiksberg/frederiksberg.github.io/blob/master/tegola/config.toml)
2. Angiv database crendentials i `.env`
3. `docker-compose up`

## Tegola
Appilkation til at serve vector tiles fra PostGIS.

### Konfiguration
Inden tegola containeren startes skal nedenstående gøres.

#### config.toml
Før Tegola serveren startes skal der laves konfiguration i en `config.toml` fil som hentes direkte fra Github Pages (kan også ligge lokalt) når serveren starter op. Forbindelsen til databasen fremgår også i filen, men bliver sat med miljøvariable på serveren, så de ikke eksponeres. 

Når der er lavet ændringer i `config.toml` på Github skal Tegola genstartes, så ændringerne slår igennem. Dette gøres nemmest ved at genstarte tegola containeren med `docker restart <container>`. Dette kan evt sættes op til at køre en gang dagligt som cronjob.

Vær opmærksom på at fejl i konfigurationsfilen gør at Tegola serveren fejler når den genstarte. Hvis dette sker kan `docker logs <tcontainer>` bruges til at finde fejlen, da Tegola skriver fejlen til loggen. 

#### Environment Variables
Forbindelsen til databasen opsættes i `.env` filen. Når konfigurationsfilen læses bliver environment variables sat ind.

#### Caching
Hvis der ønskes at der generes en tile cache får at øge performance kan dette gøres i tegola. Herunder se eksempel på kommando, som laver tiles til cachen for alle lag i `config.toml` i zoom nivea 14 til 19 og inden for en bounding box der dækker Frederiksberg kommune.

```bash
docker exec <container_name> ./tegola cache seed --config https://frederiksberg.github.io/tegola/config.toml --bounds "12.485782,55.664938,12.557257,55.697899" --max-zoom 22 --min-zoom 14 --overwrite --concurrency 4
```

Hvis der løbende ønskes at genereres tile cache på dynamiske lag, kan ovenstående komando føjes til crontab (Se evt `crontab.sh`).

Du kan læse mere om caching i tegola [her](https://tegola.io/documentation/cache-seeding-and-purging/#seed1).

## Maputnik
Webapp til at generere styling til vector tiles.

## Links
* Tegola: https://tegola.frb-data.dk
* Maputnik: https://maputnik.frb-data.dk

