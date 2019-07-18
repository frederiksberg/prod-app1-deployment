#!/bin/bash
docker exec reverse_proxy certbot --nginx -d frb-data.dk -d *.frb-data.dk -nq --agree-tos --redirect --expand --no-eff-email -m gis@frederiksberg.dk
