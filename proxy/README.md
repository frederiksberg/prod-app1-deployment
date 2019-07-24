# Reverse proxy

## Nemt

<img src="https://github.com/frederiksberg/prod-app1-deployment/blob/master/figures/ssllabsA+.PNG" width="900px">

## Formål

Proxy servicen har til formål at styre hvilke services, der kan tilgås fra internettet, samt at styre forbindelsen til dem.

Proxy servicen står også for at styre SSL-certifikater, sådan at de udadvendte services kan tilgås over https, samt at dirigere alt http trafik over https.

## Teknologi

Proxy servicen bygger på nginx, og bruger certbot til at administrere letsencrypt-certifikater.

## Konfiguration

Hvert domæne, der skal kunnes tilgås udefra skal have en konfigurationsfil i `proxy/confs`. Filen navngives efter domænet, den konfigurerer; f.eks vil konfigurationsfilen for api.frb-data.dk hedde `api.frb-data.dk.conf`.

Formatet for conf-filerne er som følger

```nginx
server {
    # server navnet, der svarer til filnavnet.
    server_name api.frb-data.dk;
    # Lyt på port 80. certbot tager sig af at mappe til port 443.
    listen 80;

    # Locationtags til routing, disse skal tilpasses efter formål
    # og har ingen faste requirements
    # Her kan kun tilgås services, der er medlemmer af 'proxy'-netværket.
    # Porten der angives her er den interne port i containeren.
    # Hvis du mapper porten til en anden port på ydersiden (det skal du ikke gøre!), vil du ikke kunne tilgå dem her.
    location / {
        proxy_pass http://swagger:8080;
    }

    location /v1/ {
        proxy_pass http://api_wrapper:5000/;
    }
}
```

## Opsætning af https

Når et nyt domæne er blevet tilføjet skal SSL-certifikatet opdateres.

Dette gøres ved at køre scriptet `proxy/init.sh`.

Scriptet skal både køres første gang serveren sættes op og efter ændringer.

Vær opmærksom på at proxy servicen skal genstartes efter init er kørt for at tage effekt.

## Traps for new players

Når proxy-servicen spinnes op skal den generere et nyt Diffie-Hellman key pair.

Dette kan ikke gøres på deterministisk tid, og det kan derfor tage alt imellem få sekunder og flere minutter. Proxy'en og derfor alle services vil ikke være tilgængelige i denne periode.

Hvis det ønskes at overvåge om nginx er færdig med at generere nøgler kan man køre `watch -n 0.5 docker logs reverse_proxy`.
