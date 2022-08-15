#!/bin/bash

set -ea
source .env
set +a

###
# This script is called directly from Cypress before each and every test.
# It sends along the --base attribute to tell us how to set up WP
###

function args() {
	options=$(getopt --options --long base -- "$@")
	[ $? -eq 0 ] || {
		echo "Incorrect option provided"
		exit 1
	}
	eval set -- "$options"
	while [ "x$1" != "x" ]; do
		case "$1" in
			--base)
				BASE_DOMAIN=$2
				shift
				;;
		esac
		shift
	done
}

args $0 "$@"

if [ "x${BASE_DOMAIN}" == "x" ]; then
	echo "Base domain is missing"
	exit 1
fi

###
# Reset the database (remove all tables)
###
docker run \
	--rm \
	--volumes-from wp-webserv \
	--network ${CYPRESS_DOCKER_NETWORK} \
	--env WORDPRESS_DB_HOST=${CYPRESS_WP_DB_DOCKER_HOST} \
	--env WORDPRESS_DB_USER=${CYPRESS_WP_DB_USER} \
	--env WORDPRESS_DB_PASSWORD=${CYPRESS_WP_DB_PASS} \
	--env WORDPRESS_DB_NAME=${CYPRESS_WP_DB_NAME} \
	--user 33:33 \
	wordpress:cli \
	wp db reset --yes

# Install the WP site, configure administrator
# https://developer.wordpress.org/cli/commands/core/install/
docker run \
	--rm \
	--volumes-from wp-webserv \
	--network ${CYPRESS_DOCKER_NETWORK} \
	--env WORDPRESS_DB_HOST=${CYPRESS_WP_DB_DOCKER_HOST} \
	--env WORDPRESS_DB_USER=${CYPRESS_WP_DB_USER} \
	--env WORDPRESS_DB_PASSWORD=${CYPRESS_WP_DB_PASS} \
	--env WORDPRESS_DB_NAME=${CYPRESS_WP_DB_NAME} \
	--user 33:33 \
	wordpress:cli \
	wp core install \
	--title=ms-plugin-test \
	--admin_user=${CYPRESS_WP_ADMIN_USER} \
	--admin_password=${CYPRESS_WP_ADMIN_PASS} \
	--url=http://${BASE_DOMAIN} \
	--admin_email=${CYPRESS_WP_ADMIN_EMAIL} \
	--quiet
