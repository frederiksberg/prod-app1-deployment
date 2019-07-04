#!/bin/bash

docker exec reverse_proxy certbot --nginx -d grafana.frb-data.dk -d monitor.frb-data.dk -d nodered.frb-data.dk -d th.frb-data.dk -d api.frb-data.dk -d tegola.frb-data.dk -d maputnik.frb-data.dk -d frb-data.dk -nq --agree-tos --redirect --expand --no-eff-email -m gis@frederiksberg.dk

# docker exec reverse_proxy sh -c 'echo ''certbot renew --post-hook reload nginx'' > /etc/cron.daily'
