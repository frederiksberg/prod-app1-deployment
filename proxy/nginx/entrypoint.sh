#!/bin/bash

if [ ! -f "/etc/ssl/certs/dhparam.pem" ]; then
    /usr/bin/openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    echo "Generated Diffie-Helmman key"
fi

nginx -g "daemon off;"
