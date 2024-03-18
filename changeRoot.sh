#!/bin/bash

CURRENT_ROOT="$(docker info | grep --colour=never -oP 'Docker Root Dir: \K.*')"

echo "Current docker root directory is: $CURRENT_ROOT"

read -p "Where should docker root be moved to [/mnt/docker_data/lib/docker]: " NEW_ROOT

NEW_ROOT=${NEW_ROOT:-/mnt/docker_data/lib/docker}

echo "Moving to: $NEW_ROOT"

DAEMON_CONFIG="/etc/docker/daemon.json"

echo "
{
   \"data-root\": \"$NEW_ROOT\"
}" > $DAEMON_CONFIG

echo "Restarting docker service"

systemctl daemon-reload
systemctl restart docker

sleep 3

VERIFY_ROOT="$(docker info | grep --colour=never -oP 'Docker Root Dir: \K.*')"

echo "Root has been changed to: $VERIFY_ROOT"
