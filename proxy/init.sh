#!/bin/bash

# SSL/TLS
docker exec reverse_proxy certbot --nginx \
    -d frb-data.dk -d vejr.frb-data.dk -d grafana.frb-data.dk \
    -d monitor.frb-data.dk -d nodered.frb-data.dk \
    -d th.frb-data.dk \
    -d api.frb-data.dk -d tegola.frb-data.dk -d maputnik.frb-data.dk \
    -d forecast.frb-data.dk -d cvr.frb-data.dk \
    -d 3d.frb-data.dk \
    -d rute.frb-data.dk \
    -nq --agree-tos --redirect --expand \
    --no-eff-email -m gis@frederiksberg.dk \
    --rsa-key-size=2048

# Update tls CAA to BBR
echo "net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr" > /etc/sysctl.d/10-custom-kernel-bbr.conf
sysctl --system
