# Live opgradering af en enkelt service

## 1. Opdatering af kodebasen

Når kodebasen opdateres anbefales det at lade servicen køre under hele processen.
Det er den bedste måde at minimere nedetid, og det har den positive effekt at det ikke risikere at påvirke proxy-servicen med at resolve adresser, der ikke findes.

Stil dig i den directory hvor servicen er. Når du kører `make` kommandoer herfra vil de kun påvirke den ene service. Det er **meget vigtigt** at der ikke køres docker/docker-compose kommandoer manuelt, da de kan risikere at påvirke de andre services. Hvis du har behov for at gøre dette anbefales det at lave en green/blue deployment. Se guiden i [her](green-blue.md).

Når koden er bragt up-to-date kan servicen genstartes.

## 2. Restart

Vær helt sikker på at koden er som den skal være. Det næste trin vil tage servicen ned, hvis der opstår en fejl. Det frarådes kraftigt at lave større ændringer (ændringer i det hele taget) live i produktionsmiljøet.

Kør `make`.

Du vil nu se at servicen lukkes ned, bygges om og starter igen.

Som regel tager dette ikke mere end 10-15 sekunder. Hvis din service tager lang til at tænde/slukke/bygge eller hvis oppetid er kritisk, må der igen henvises til guiden for [blue/green deployment](green-blue.md).

## 3. Test + profit

Nu da servicen er opgraderet er det tid til at verificere at ændringen er slået igennem som forventet og at servicen kører stabilt.

## Eksempel
I eksemplet herunder ses opgradering af Grafana til nyeste version:
1. `$ docker pull grafana/grafana`
2. `$ cd /opt/prod-app1-deployment/iot/iot-pipeline`
3. `$ make`
Vær opmærksom på at denne kommando også lukker ned for NodeRED i en kort periode.

## Bemærkninger

Det kan ikke understreges nok at metoden forklaret i denne guide frarådes på det kraftigste live i produktionen.

Husk at du arbejder i et produktionsmiljø!
