# Reverse proxy

## Nemt

<img src="https://github.com/frederiksberg/prod-app1-deployment/blob/master/figures/ssllabsA+.PNG" width="900px">

## Formål

Proxy servicen har til formål at styre hvilke services, der kan tilgås fra internettet, samt at styre forbindelsen til dem.

Proxy servicen står også for at styre SSL-certifikater, sådan at de udadvendte services kan tilgås over https, samt at dirigere alt http trafik over https.

## Teknologi

Proxy servicen bygger på nginx, og bruger certbot til at administrere letsencrypt-certifikater.

Certifikaterne er signed med 4096-bit RSA og supporterer kun TLSv1.2.

For en detaljeret gennemgang af ssl konfigurationen henvises til [ssllabs](https://www.ssllabs.com/ssltest/analyze.html?d=th.frb-data.dk).

Servicen genererer sine egne 2048-bit Diffie-Hellman keys første gang containeren startes op.

Proxy serveren supporterer en relativt nøje udvalgt cipher suite. Dette kan give problemer i ældre browsere eller i gamle operativsystemer. Hvis dette bliver et problem kan cipher-suiten redigeres i `proxy/certs/options-ssl-nginx.conf`

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

Sikrer dig først at det nye domæne kan tilgås på http. Det kræver typisk en genstart af proxy-serveren.
Dette gøres ved at køre `cd proxy && make`.

Når det er verificeret kan SSL-certifikatet opdateres med `proxy/init.sh`-scriptet.
Certifikatændringen bør slå igennem med det samme.

Prøv nu igen at tilgå domænet på http og sikrer dig at din forespørgsel bliver dirigeret til https og at servicen er tilgængelig her.
