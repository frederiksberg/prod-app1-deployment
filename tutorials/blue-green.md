# Blue-green deployment

## 1. Lav ny instans af produktionsserveren

Spin en ny server op, sådan at den er identisk med produktionsmiljøet.

Sørg for at specce den korrekt, da det vil være her produktionen kører videre, når du er færdig.
Det er vigtigt at den kører i samme datacenter som den nuværende server.

I DigitalOcean kan dette gøres nemt ved tage et snapshot af produktionsserveren og spinne en ny server op ud fra det.

## 2. Opgrader din kode

De to vigtige kommandoer er `make` for at starte hele setupet of `make restart` for at genstarte et setup, der kører. Begge kommandoer skal køres fra roden af repoet.

Vær opmærksom på at proxy-servicen ikke vil køre korrekt i denne fase, da dns ikke er ændret endnu.

Under udviklingen kan det være en fordel at spinne enkelte services op og ned. Se guiden for [live opgradering](upgrade-service.md) for hjælp til dette.

## 3. Skift dns

Når det er verificeret at den nye server kører korrekt, skal dns'en peges over.

På DigitalOcean har produktionsserveren en "floating ip". Assign denne til den nye server.
Ændringen bør slå igennem med det samme.

## 4. Wrap up

Når den nye server kører og det er kontrolleret at alt fungerer som det skal, kan den gamle server lukkes ned.
