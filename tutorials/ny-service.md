# Integrering af en ny service - a case study

## Introduktion

I dette tutorial vil vi gennemgå alle trinnene for at integrere en ny service i produktionssetuppet.

Eksemplet er projektet shiny-cvr, der udstiller cvr-data i en shiny applikation. Projektet er skrevet i R og python.

## 1. Forberedelse

Inden vi går i gang er det vigtigt at gennemgå projektet, og sikre at det er som det skal være.

Deployment koden til produktionen er offentligt tilgængelig, og det er derfor vigtigt (især hvis projektet kommer fra et privat repo eller fra intern drift) at alle følsomme oplysninger bliver fjernet.

De mest almindelige syndere er hardcodede passwords og tokens, men andre følsomme oplysninger som navne eller cpr-numre må heller ikke være i kodebasen.

I shiny-cvr er der et hardcodet username/password til cvr-registret, som skal fjernes. Den nemmeste måde er oftest at opbevare de følsomme oplysninger som environment variabler, da det er nemt at styre i Docker.

I dette eksempel er oplysninger opbevaret i Python koden:

```python
# FIXME: Password in code :(
USER = '<I am secret and should be removed>'
PASSWORD = '<I am secret and should be removed>'
HOST = 'distribution.virk.dk/cvr-permanent/'
```

Hvordan environment variabler læses er forskelligt, men i dette eksempel fixer vi problemet ved at rette disse linjer til:

```python
import os
USER = os.environ['cvr_user']
PASSWORD = os.environ['cvr_pwd']
HOST = 'distribution.virk.dk/cvr-permanent/'
```

Når du er overbevist om at alle sådanne problemer er løst kan du gå videre til næste skridt.

## 2. Dockerfile

Produktionen kører i docker, og det er derfor vigtigt at, hvert projekt kører i et gennemtænkt miljø.

I nogle projekter er det nok at køre i et fordefineret image, og i andre tilfælde er det nødvendigt med en dockerfil.

Hvis dockerfiler bruges er det vigtigt at de er stabile og ikke inkluderer unødige dependencies. Vi har kun så meget plads på serverne.

## 3. docker-compose

(Næsten) alle services i produktionen skal have en docker-compose.yml-fil. Hvis du er i tvivl om, hvorvidt dit projekt skal have den, så skal det.

Der er 3 ting, der er vigtige at have for øje, når docker-compose filen skrives.

### 1. Navn

For at vi nemt kan bruge `docker ps` til at få et overblik over containerne, skal containeren have et navn, der beskriver hvad der kører/hvilket projekt det tilhører.

```yml
container_name: shiny-cvr
```

### 2. Restart-policy

**Alle** containere skal have en restart policy `unless-stopped`.

Det gøres for at sikre at containeren genstarter sig selv, hvis den fejler. Det er vigtigt at restart ikke sættes til `always`, da det fjerner kontrol over servicen fra administratoren.

```yml
restart: unless-stopped
```

### 3. Netværk

Hvis din service skal kunne tilgås fra internettet skal den igennem proxy'en.

Måden den forbindelse laves er ved at forbinde servicen til `proxy`-netværket.

Det er vigtigt, at din service ikke eksponeres på porte med mindre den kører på en ikke http protokol (f. eks ssh).

Netværket skal erklæres i docker-compose-filen med en networks-block.

```yml
networks:
  proxy:
    external: true
    name: proxy
```

Vær opmærksom på at denne syntax kræver `version: "3.5"`.

Din service kan derefter hægtes på proxyen.

```yml
networks: [proxy]
# eller
networks:
  - proxy
```

Alt i alt ser docker-compose.yml for shiny-cvr sådan ud:

```yml
version: "3.5"
services:
  shiny-server:
    build: .
    container_name: shiny-cvr
    restart: unless-stopped
    env_file: .env
    networks: [proxy]

networks:
  proxy:
    external: true
    name: proxy
```

## 4. Makefile

Alt i produktionssetupet køres i make. Dit projekt skal derfor have en Makefile.

Makefilen skal **mindst** have disse 5 targets, men kan have flere efter behov. Definitionerne i dette eksempel virker for de fleste projekter, men Makefilen kan tilpasses til det enkelte projekt.

```Makefile
MAKEFLAGS += --silent
.PHONY: deploy run build clean kill

deploy: | build clean
    docker-compose up -d

run: | build clean
    docker-compose up

clean: kill
    docker-compose rm -f

build:
    docker-compose build

kill:
    docker-compose down
```

## 5. Test

Test din service inden du deployer til produktionsmiljøet.

Du kan enten finde på dine egne tests, eller deploye produktionsmiljøet på en test server, og køre det med `-dev` suffixet for at få en test-proxy. Se dokumentationen for nærmere detajler.

## 6. Tilføj til git

Din nye service skal nu tilføjes til git. Repo'et bor på [https://github.com/frederiksberg/prod-app1-deployment](https://github.com/frederiksberg/prod-app1-deployment).

Du har mulighed for at oprette dit projekt som et submodule, eller at kopiere koden over i prosuktions repo'et. I dette eksempel kopierer vi koden.

Der er tre steder projekter kan bo på produktionsserveren.

* gis
* iot
* meta

I dette eksempel hører projektet hjemme i gis.
Projektet ligges i en undermappe under gis, så mappe strukturen er:

```unicode
prod/
├── gis/
    ├── shiny-cvr
```

## 7. Registrering i parent Makefil

Hvert underniveau har en Makefile, der holder styr på services under sig.

Når en ny service tilføjes skal den registreres i denne Makefile

Dette er en 2-trins process.

### 1. Referencer

Disse ligges under kommentaren `-------- Projects --------`

De skal være i dette format:

```Makefile
# -> shiny-cvr
kill-shiny-cvr:
    @${MAKE} --no-print-directory -C shiny-cvr kill

clean-shiny-cvr:
    @${MAKE} --no-print-directory -C shiny-cvr clean

build-shiny-cvr:
    @${MAKE} --no-print-directory -C shiny-cvr build

run-shiny-cvr:
    @${MAKE} --no-print-directory -C shiny-cvr run

deploy-shiny-cvr:
    @${MAKE} --no-print-directory -C shiny-cvr deploy
```

Navnet på targetsne er ikke væsentlige, men det er vigtigt at navnet efter `-C` er identisk med navnet på undermappen.

### 2. Registrering

De nye targets skal registreres i listerne under `-------- Project definitions --------`.

```Makefile
# -------- Project definitions --------
deploys     := deploy-tilehut deploy-posgrest deploy-vectortile deploy-shiny-cvr
runs        := run-tilehut run-posgrest run-vectortile run-shiny-cvr
builds      := build-tilehut build-posgrest build-vectortile build-shiny-cvr
cleans      := clean-tilehut clean-posgrest clean-vectortile clean-shiny-cvr
kills       := kill-tilehut kill-posgrest kill-vectortile kill-shiny-cvr
```

## 8. Registrering af domæne

I dette eksempel er domænet cvr.frb-data.dk sat af til denne service.

Domænet skal oprettes i proxyen. Vi opretter en .conf fil i `/proxy/conf/cvr.frb-data.dk.conf`.

```nginx
server {
    server_name cvr.frb-data.dk;
    listen 80;
    location / {
        proxy_pass http://shiny-server:80;
    }
}
```

Her er det vigtigt at server_name er sat til domænet, og at proxy_pass peger på servicen på den korrekte port.

Det er vigtigt at der peges på service-navnet og **ikke** container navnet. Porten er den port, servicen kører på internt i containeren.

Dernæst skal domænet tilføjes til `/proxy/init.sh`.

Filen har en certbot kommando med en række `-d` tags. Der skal tilføjes et nyt tag til kommandoen.

```shell
-d cvr.frb-data.dk
```

## 9. Deployment

Sørg for de ovennævnte ændringer er committet til github.

### 1. Pull ændringer

```shell
git pull
```

### 2. initenv

Hvis du har benyttet .env-filer, skal de initialises. Der ligger et script initenv.sh på serveren i /opt/.

Her kan der tilføjes en entry til de nye .env fil.

### 3. Start servicen

Naviger til servicens directory og kør make herfra.

```shell
cd gis/shiny-cvr
make
```

Du burde nu kunne se at servicen bygges og spinnes op.

Brug `docker logs` til at verificere at servicen kører som den skal inden du fortsætter.

### 4. Genstart proxy

Kør flg. kommandoer fra roden af repo'et.

Proxy'en skal genstartes for at sætte det nye domæne op.

Fra roden kør:

```shell
make restart
```

Verificer at domænet kan tilgås på http. Brug chrome eller kør flg. kommando fra en kommandoprompt.

```shell
curl http://cvr.frb-data.dk
```

### 5. SSL

Opdater certifikatet ved at køre init.sh scriptet i /proxy/.

```shell
./proxy/init.sh
```

Verificer at servicen kan tilgås på https og at http redirecter til http.
Du kan igen benytte chrome eller nedstående kommandoer.

```shell
curl -I http://cvr.frb-data.dk
curl -I -L http://cvr.frb-data.dk
curl -I https://cvr.frb-data.dk
```

Det forventede output er `301 Moced Permanently` for den første kommando.

Den anden bør give `301 Moced Permanently` efterfulgt af `200 OK`.

Den trejde bør give `200 OK`.

## 10. Profit

Servicen er nu oprettet og integreret i produktionen.
