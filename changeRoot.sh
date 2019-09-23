#!/bin/bash

CURRENT_ROOT="$(docker info | grep --colour=never -oP 'Docker Root Dir: \K.*')"

echo "Current docker root directory is: $CURRENT_ROOT"

read -p "Where should docker root be moved to [/mnt/docker_data/lib/docker]: " NEW_ROOT

NEW_ROOT=${NEW_ROOT:-/mnt/docker_data/lib/docker}

echo "Moving to: $NEW_ROOT"

SERVICE_LOCATION="$(systemctl show -p FragmentPath docker.service | grep --colour=never -oP 'FragmentPath=\K.*')"

SERVICE_D="${SERVICE_LOCATION}.d/"
SERVICE_NEWCONF="${SERVICE_D}docker.root.conf"

mkdir -p $SERVICE_D

echo "[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --data-root=$NEW_ROOT -H fd:// --containerd=/run/containerd/containerd.sock
" > $SERVICE_NEWCONF

echo "Restarting docker service"

systemctl daemon-reload
systemctl restart docker

VERIFY_ROOT="$(docker info | grep --colour=never -oP 'Docker Root Dir: \K.*')"

echo "Root has been changed to: $VERIFY_ROOT"
