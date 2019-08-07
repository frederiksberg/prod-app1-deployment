# Deployment af produktionsserver 1

## Diagram over services

<img src="https://github.com/frederiksberg/prod-app1-deployment/blob/master/figures/tree.svg" width="900px">

## Opdeling

Projektet er opdelt i 4 logiske kasser.

* [GIS](gis/)
    * [Tilehut](gis/tilehut/)
    * [PostgREST API/Swagger](https://github.com/frederiksberg/PostgREST)
    * [Vector tile server (Tegola/Maputnik)](gis/vector-tiles/) 
* [IOT](iot/README.md)
    * [Grafana/Node-RED](iot/iot-pipeline/)
    * [Vejr API](https://github.com/frederiksberg/VejrAPI/blob/master/)
    * [Forecasting](iot/forecast)
* [Meta](meta/)
* [Reverse proxy](proxy/)

## Kom igang

1. Klon dette repository `git clone https://github.com/frederiksberg/prod-app1-deployment.git`
2. Klon submodules med `git submodule update --init --recursive`
3. Tilret `*.env`under de forskellige projekter (brug evt. `initenv.sh` script - se nedenfor)
4. Container specifik init (se [dette afsnit](#konfiguration))
5. Kør `make` i root folderen
6. Kør `/proxy/init.sh` for at sætte SSL op

### Make

Til at styre docker-compose filerne bruges [Make](https://www.gnu.org/software/make/), som gør det muligt at bygge, fjerne,  starte eller stoppe produktionsserveren eller dele af den afhængigt af hvor man står i foldertræet. Som udgangpunkt har alle services en `docker-compose.yml` og en tilhørnede `Makefile` som kalder docker-compose filen med forskellige kommandoer.

* `make deploy` - Starter containerne i detatch mode (`docker-compose up -d`)
* `make run` - Starter containerne med live logging (`docker-compose up`)
* `make build` - Bygger images fra `Dockerfile` (`docker-compose build`)
* `make kill` - Lukker containere(`docker-compose down`)
* `make clean` - Fjerner containere (`docker-compose rm -f`)

Ovennævnte build targets har interne afhængigheder for at lette workflowet.

Deploy er standard target, dvs. at køres make uden at specificere et target, køres deploy.

Dette kombineret betyder at, der kan startes en service ved at køre `make` fra servicens rod.
Og at servicen kan tages ned, bygges om og spinnes op igen ved at køre `make`.

Når en applikation debugges kand et være en fordel at køre `make run`. Servicen vil nu løbende printe log output til terminalen. Vær dog opmærksom på at servicen ikke længere køres som en daemon, og at dens life-cycle derfor er tied ttil terminalen.

### Make i roden

Makefilen i roden af repositoriet er sat op til at styre deployment af hele serveren.
Her er specificeret de samme targets som i de individuelle projekt, samt et `restart` target til at restarte reverse_proxy og et restart-all target til at restarte hele setuppet.

## Opgradering

Se guiden for [Blue-green deployment](tutorials/blue-green.md) og [Live opgradering](tutorials/upgrade-service.md).

## Konfiguration

Flere af servicesne kræver at der laves konfigurationer inden de startes. Dette står nærmere beskrevet i `README.md` for de forskellige services. Overordnet skal følgende services konfigureres inden de startes:

**GIS**
* Tegola
* PostgREST
* Swagger
* Tilehut

**IoT**
* Grafana

**Meta**
* Monitor

Herunder ses eksempel på `initenv.sh` bash script som kan tilrettes. Det anbefales at ligge dette udenfor git repo'et så man ved en fejl ikke commiter disse oplysninger.
```bash
# ----- Config files -----
POSTGREST='/opt/prod-app1-deployment/gis/PostgREST/envs/postgrest.env'
SWAGGER='/opt/prod-app1-deployment/gis/PostgREST/envs/swagger.env'
GRAFANA='/opt/prod-app1-deployment/iot/iot-pipeline/.env'
MONITOR='/opt/prod-app1-deployment/meta/monitor/.env'
TEGOLA='/opt/prod-app1-deployment/gis/vector-tiles/.env'

# ==> PostgREST
echo "PGRST_DB_URI=postgresql://uesr:pw@host:port/db?sslmode=require
PGRST_DB_SCHEMA=schema
PGRST_DB_ANON_ROLE=user
PGRST_SERVER_PROXY_URI=https://api.frb-data.dk/v1/data" > $POSTGREST

# ==> Swagger
echo "API_URL=https://api.frb-data.dk/v1/meta" > $SWAGGER

# ==> Grafana
echo "GF_SECURITY_ADMIN_PASSWORD=pw
GF_INSTALL_PLUGINS=grafana-worldmap-panel
GF_SERVER_ROOT_URL=https://grafana.frb-data.dk
GF_SMTP_ENABLED=true
GF_SMTP_HOST=smtp.gmail.com:465
GF_SMTP_USER=your@mail.com
GF_SMTP_PASSWORD=pw" > $GRAFANA

# ==> Monitor
echo "DB_USER=user
DB_PWD=pw
TOKEN_SECRET=token
GH_CLIENT_ID=id
GH_CLIENT_SECRET=secret_id
GH_ORGS=org" > $MONITOR

# ==> Tegola
echo "POSTGIS_HOST=host
POSTGIS_PORT=port
POSTGIS_DB=db
POSTGIS_USER=user
POSTGIS_PW=pw" > $TEGOLA
```

### tilehut

For at konfigurere tilehut rigtigt **inden** første opstart, skal `gis/tilehut/init.sh` køres.

Det sørger for at der bliver genereret host keys til SFTP serveren.
Det er vigtigt at dette bliver gjort inden første opstart, da docker-compose ellers vil lave den forkerte type volume binding.

Se nærmere info om tilehut [her](gis/tilehut/README.md).

## Sikkerhed

Der bliver sat auth op for de fleste services gennem `.env` beskrevet ovenfor. Derudover er der opsat https som beskrives herunder. Det anbefales at der ikke commites kode fra serveren til Github for at undgå at `.env` og andet med credentials ikke lægges ud.

### NGINX

Proxy docker netværket styrer hvilke services, der kan snakke med nginx.
Det er det første lag af isolation.

nginx's config filer styrer, hvordan trafik routes fra via proxy netværket. Dette tjener som det andet lag af isolation.

SSL certifikaterne bruges til at oprette sikre https tuneller til brugeren og nginx er konfigureret til at redirecte alt http trafik til https.

For detaljer om proxy servicen se [denne readme](proxy/README.md).

### Node-RED
Node-RED skal have opsat auth **efter** containeren er startet, hvilket står beskrevet `README.md` for iot-pipeline.

## Digital Ocean

Vi kører setuppet i DigitalOcean.

Produktionsdelen af setuppet består af en produktions server og en produktionsdatabase.

Produktionserveren har en floating ip, som dns'en peger på. Dette gør at produktionsserveren kan flyttes ved plot at pege denne ip over på en ny droplet.

Produktionsdatabasen db1 er hostet i DO's managed database cluster engine. Det vil sige at vi ikke selv administrerer lav-praktisk tuning og vedligeholdelse.

Det er muligt at tilføje standby og read-only nodes til clusteren, hvis nedetid bliver et problem.

## Videre udvikling

Ønskes der at tilføjes services til stacken 
* lav `docker-compose.yml` og tilhørende `Makefile`
* Hvis servicen er en webapplikation tilføjes docker netværket til `docker-compose.yml`:
```yml
version: '3.5'
services:
    ...
    networks:
      - front-facing
networks:
  front-facing:
    external: true
    name: proxy
```
* Tilføj den nye service i parent `Makefile`. Se [eksempel](https://github.com/frederiksberg/prod-app1-deployment/blob/master/gis/Makefile)
* Opret nginx konfiguration under [`proxy/confs/`](https://github.com/frederiksberg/prod-app1-deployment/tree/master/proxy/confs)
* Tilføj services til [`proxy/init.sh`](https://github.com/frederiksberg/prod-app1-deployment/blob/master/proxy/init.sh)
* Start servicen
* Er der tilføjet et nye (sub)domæne skal [proxy genstartes](proxy/README.md)

## Lokal udvikling

Hvis ændringer skal testes, kan det være en fordel at spinne setuppet op uden for produktionsmiljøet. Der er en dev-proxy pakket med, for at gøre dette nemmere.

De almindelige make kommandoer kan køres fra roden med `-dev` som suffix (f .eks `make deploy-dev`) for at bruge dev proxyen i stedet for produktionsproxyen.

Fordelen er at dev-proxyen server på http på localhost, på en række endpoints beskrevet [her](proxy-dev/confs/localhost.conf). Nogle services kræver særlig konfiguration for at benytte dev-proxyen.

## Requirements

For at benytte setup kræves flgn. installeret på serveren.

* Docker
* docker-compose
* cmake

De enkelte projekter kan have yderligere dependencies.

## Links
**GIS**
* https://tegola.frb-data.dk
* https://maputnik.frb-data.dk
* https://api.frb-data.dk
* https://th.frb-data.dk

**IoT**
* https://grafana.frb-data.dk
* https://nodered.frb-data.dk
* https://forecast.frb-data.dk
* https://vejr.frb-data.dk/getforecast

**Meta**
* https://monitor.frb-data.dk

## Postman tests

[https://www.getpostman.com/collections/b3c209f5a3dbc6304fd2](https://www.getpostman.com/collections/b3c209f5a3dbc6304fd2)
