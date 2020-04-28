# Reverse proxy

## Nemt

<img src="https://github.com/frederiksberg/prod-app1-deployment/blob/master/figures/ssllabsA+.PNG" width="900px">

## Formål

Proxy servicen har til formål at styre hvilke services, der kan tilgås fra internettet, samt at styre forbindelsen til dem.

Proxy servicen står også for at styre SSL-certifikater, sådan at de udadvendte services kan tilgås over https, samt at dirigere alt http trafik over https.

## Teknologi

Proxy servicen bygger på nginx, og bruger certbot til at administrere letsencrypt-certifikater.

Certifikaterne er signed med 2048-bit RSA og supporterer kun TLSv1.2 og TLSv1.3.

For en detaljeret gennemgang af ssl konfigurationen henvises til [ssllabs](https://www.ssllabs.com/ssltest/analyze.html?d=th.frb-data.dk).

Servicen genererer sine egne 2048-bit Diffie-Hellman keys første gang containeren startes op.

Proxy serveren supporterer en relativt nøje udvalgt cipher suite. Dette kan give problemer i ældre browsere eller i gamle operativsystemer. Hvis dette bliver et problem kan cipher-suiten redigeres i `proxy/certs/options-ssl-nginx.conf`

Proxyen indeholder også en Web Application Firewall, der har til formål at blokere mistænkelige requests. Dette fungerer som det yderste lag i applikationssikkerheden.

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

Sikre dig først at det nye domæne kan tilgås på http. Det kræver typisk en genstart af proxy-serveren.
Dette gøres ved at køre `make` fra proxy mappen.

Når det er verificeret kan SSL-certifikatet opdateres med `make init-proxy` fra roden eller `make init` fra proxy folderen.
Inden det køres skal du sikre dig at domænet er tilføjet til domæne listen i `proxy/init.sh`. Der skal være et flag i kommandoen i init; `-d dit-domæne.dk`.
Certifikatændringen bør slå igennem med det samme.

Prøv nu igen at tilgå domænet på http og sikrer dig at din forespørgsel bliver dirigeret til https og at servicen er tilgængelig her.

Vær opmærksom på at Let's Encrypt har begrænsninger på, hvor tit man kan få certifikater. Spørg derfor ikke for mange gange inden for en kort periode, da vi derved kan blive "låst ude" af Let's Encrypt i 7 dage.

## Web Application Firewall (WAF)

WAF'en er den populære ModSecurity, der integrerer med NGINX.

WAF'en er konfigureret i `proxy/nginx/modsecurity.conf`. Her sættes alle indstillinger, der vedrører WAF'en, inklusiv undtagelser for tjek på de forskellige services.

WAF'en fungerer ved at matche mønstre i requestet og kan derfor blokere legitimate traffik, hvis det følger en ellers mistænkelig form. Derfor kan man definere undtagelser for de individuelle services i konfigurationsfilen.

Der er sat et dashboard op i grafana, til at overvåge loggen fra ModSecurity. De tre dashboards ligger i modsec mappen, der kun kan tilgås af administratorer.

Undtagelser følger denne form:

```config

SecRule SERVER_NAME "@streq <domæne>" "id:<unikt id>,phase:1,t:none,nolog,pass,ctl:ruleRemoveById=<vuln_id>"

```

WAF'ens regelsæt er baseret på OWASP's core regelsæt.

Der kører en lille Python service `modsec_monitor`, der overfører modsec's access_log til en tabel i produktionsdatabasen.
Det er herfra grafana trækker data.
