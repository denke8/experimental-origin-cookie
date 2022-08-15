#!/bin/bash

set -ea
source .env
set +a

docker network create ${CYPRESS_DOCKER_NETWORK}

# Bring up a MariaDb container
docker run \
	--detach \
	--network ${CYPRESS_DOCKER_NETWORK} \
	-p 127.0.0.1:3306:3306 \
	--name ${CYPRESS_WP_DB_DOCKER_HOST} \
	--env MARIADB_DATABASE=${CYPRESS_WP_DB_NAME} \
	--env MARIADB_USER=${CYPRESS_WP_DB_USER} \
	--env MARIADB_PASSWORD=${CYPRESS_WP_DB_PASS} \
	--env MARIADB_RANDOM_ROOT_PASSWORD=yes \
	mariadb:latest

# Bring up a webserver pre-configured with WordPress, connect it to DB.
# This also generates the wp config file, and installs the DB
docker run \
	--detach \
	--network ${CYPRESS_DOCKER_NETWORK} \
	-p 127.0.0.1:80:80 \
	--name wp-webserv \
	--env WORDPRESS_DB_HOST=${CYPRESS_WP_DB_DOCKER_HOST} \
	--env WORDPRESS_DB_USER=${CYPRESS_WP_DB_USER} \
	--env WORDPRESS_DB_PASSWORD=${CYPRESS_WP_DB_PASS} \
	--env WORDPRESS_DB_NAME=${CYPRESS_WP_DB_NAME} \
	wordpress

# pull image for faster user
docker pull wordpress:cli