# Deployment af produktionsserver 1

## Diagram over services

<img src="https://github.com/frederiksberg/prod-app1-deployment/blob/master/figures/tree.svg" width="800px">

### Folderstruktur

## Kom igang
1. Klon dette repository `git clone https://github.com/frederiksberg/prod-app1-deployment.git`
2. Tilret `*.env`under de forskellige projekter (brug evt. `init_env.sh` script)
3. Kør `make` i root folderen
Sikkerhed
4. Kør `/proxy/init.sh`
5. Byg det hele igen med `make`



### Make
Til at styrer docker-compose filerne bruges [Make](https://www.gnu.org/software/make/), som gør det muligt at bygge, fjerne,  starte eller stoppe produktionsserveren eller dele af den afhængigt af hvor man står i foldertræet. Som udgangpunkt har alle services en `docker-compose.yml` og en tilhørnede `Makefile` som kalder docker-compose filen med forskellige kommandoer.

* `make run` - Starter containerne med live logging (`docker-compose up`)
* `make deploy` - Starter containerne i detatch mode (`docker-compose up -d`)
* `make build` - Bygger images fra `Dockerfile` (`docker build -t frbsc/img_name:latest -f ./Dockerfile .`)
* `make kill` - Lukker og fjerne containere(`docker-compose down`)
* `make clean` - Fjerner containere (`docker-compose rm -f`)




## Konfiguration
Flere af containerne er 

## Sikkerhed

## God stil
* Commit ikke kode fra serveren fra Github

## Requirements

For at benytte setup kræves flgn. installeret på serveren.

* Docker
* docker-compose
* cmake

De enkelte projekter kan have yderligere dependencies.

