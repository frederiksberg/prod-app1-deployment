#!/bin/bash

docker exec reverse_proxy certbot --nginx \
    -d frb-data.dk -d vejr.frb-data.dk -d grafana.frb-data.dk \
    -d monitor.frb-data.dk -d nodered.frb-data.dk -d th.frb-data.dk \
    -d api.frb-data.dk -d tegola.frb-data.dk -d maputnik.frb-data.dk \
    -d forecast.frb-data.dk \
    -nq --agree-tos --redirect --expand \
    --no-eff-email -m gis@frederiksberg.dk \
    --rsa-key-size=4096
