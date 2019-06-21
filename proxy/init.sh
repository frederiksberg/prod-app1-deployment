#!/bin/bash

DOMAINS="grafana.frb-data.dk,monitor.frb-data.dk,nodered.frb-data.dk,th.frb-data.dk"

docker exec reverse_proxy certbot --nginx -d $(DOMAINS) -nq --agree-tos --no-eff-email -m gis@frederiksberg.dk --staging

docker exec reverse_proxy sh -c 'echo ''certbot renew --post-hook reload nginx'' > /etc/cron.daily'