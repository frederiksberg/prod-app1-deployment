#!/bin/bash

DOMAINS="grafana.frb-data.dk,monitor.frb-data.dk,nodered.frb-data.dk,th.frb-data.dk"

docker exec reverse_proxy certbot --nginx -d grafana.frb-data.dk -d monitor.frb-data.dk -d nodered.frb-data.dk -d th.frb-data.dk -n --agree-tos --no-eff-email -m gis@frederiksberg.dk --staging

docker exec reverse_proxy sh -c 'echo ''certbot renew --post-hook reload nginx'' > /etc/cron.daily'
