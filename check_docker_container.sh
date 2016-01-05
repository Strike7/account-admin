#!/bin/bash

# Author: Erik Kristensen
# Email: erik@erikkristensen.com
# License: MIT
# Nagios Usage: check_nrpe!check_docker_container!_container_id_
# Usage: ./check_docker_container.sh _container_id_
#
# The script checks if a container is running.
#   OK - running
#   WARNING - container is ghosted
#   CRITICAL - container is stopped
#   UNKNOWN - does not exist

CONTAINER=$1

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

if [ $? -eq 1 ]; then
	docker run --name ad -e POSTGRES_DB=ad -p 5432:5432 -e POSTGRES_USER=ad -e POSTGRES_PASSWORD=ad -d postgres
fi

if [ "$RUNNING" == "false" ]; then
  docker start $CONTAINER
fi

STARTED=$(docker inspect --format="{{ .State.StartedAt }}" $CONTAINER)
NETWORK=$(docker inspect --format="{{ .NetworkSettings.IPAddress }}" $CONTAINER)

echo "OK - $CONTAINER is running. IP: $NETWORK, StartedAt: $STARTED"