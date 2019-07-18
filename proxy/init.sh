#!/bin/bash
docker exec reverse_proxy certbot --nginx -d frb-data.dk -d *.frb-data.dk -nq --agree-tos --redirect --expand --server https://acme-v02.api.letsencrypt.org/directory --no-eff-email -m gis@frederiksberg.dk
