#!/bin/bash

set -ea
source .env
set +a

docker rm -f -v ${CYPRESS_WP_DB_DOCKER_HOST}

docker rm -f -v wp-webserv

docker network rm ${CYPRESS_DOCKER_NETWORK}