#!/bin/bash
# set -x

trap cleanup SIGINT SIGTERM EXIT

BUILT=
NGINX_STARTED=
export DOCKER_MACHINE_IP=

function cleanup() {
    echo "$(docker-compose down 2>&1)" 1>&2 #&& printf "\n\n>>>\n>>> docker-compose is down\n>>>\n>>>\n>>>\n"
    JOBS="$(jobs -p)"
    if [[ -n $JOBS ]]; then
        kill $(jobs -p)
    fi
}

function kill_process() {
    if [[ $( pgrep $1 ) ]]; then
        printf "\n>>>\n>>>\n>>> existing $1 instances, running pkill $1\n>>>\n>>>\n"
        pkill "$1"
    else
        printf "\n>>>\n>>>\n>>> no instances of $1 are running\n>>>\n>>>\n"
    fi
}

function docker_compose_build() {

    printf "\n>>>\n>>>\n>>> building nginx.conf for uc_nginx n\n>>>\n>>>\n>>>\n"
    envsubst '${HOST}' < config/nginx/${NODE_ENV}.conf > config/nginx/nginx.conf

    printf "\n>>>\n>>>\n>>> running docker-compose build\n>>>\n>>>\n"
    docker-compose build 1> /dev/stdout 2> /dev/stderr
    
    if [[ $? -ne 0 ]]; then
        printf "\n>>>\n>>>\n>>> docker-compose build encoutered an error\n>>>\n>>>\n" > /dev/stderr
        exit 1
    fi

    BUILT=true
}

function docker_compose_up() {
    while [[ ! $BUILT || ! NGINX_STARTED  ]]; do
        printf "\n>>>\n>>>\n>>> waiting for build to finish\n>>>\n>>>\n"
        sleep 1
    done
    printf "\n>>>\n>>>\n>>> running docker-compose up\n>>>\n>>>\n"
    docker-compose up 1> /dev/stdout 2> /dev/stderr
}

function start_nginx() {
    #
    #
    #   substitute environment variables into nginx config template and start nginx
    #
    #
    kill_process nginx
    
    printf "\n>>>\n>>>\n>>> building nginx.conf\n>>> starting nginx with the following configuration\n>>>\n>>>\n>>>\n"
    envsubst '${PROJECT_ROOT},${NGINX_PORT},${DOCKER_MACHINE_IP}' < config/nginx/dev-server.tmpl > config/nginx/dev-server.conf

    printf "\n>>>\n>>>\n>>> nginx serving dev env on localhost:$NGINX_PORT\n>>>\n"
    nginx -c config/nginx/dev-server.conf -g "daemon off;" 1>> /dev/stdout 2>> /dev/stderr &
    
    sleep 1

    if [[ $( pgrep nginx ) ]]; then
        printf "\n>>>\n>>>\n>>> nginx redirecting traffic from on localhost:${NGINX_PORT} to $DOCKER_MACHINE_IP\n>>>\n>>>\n"
        NGINX_STARTED=true
    else
        printf "\n>>>\n>>>\n>>> error starting nginx\n>>>\n>>>\n"
        exit 1
    fi
}

function get_docker_ip() {
    #
    #
    #   see if docker-machine is running and if not start it
    #
    #
    IP="$(docker-machine ip 2> /dev/null)"
    if [[ ! $IP ]]; then
        printf "\n>>>\n>>>\n>>> starting docker-machine\n>>> waiting for of IP address\n>>>\n"
        docker-machine start > /dev/stdout 2>> /dev/stderr && IP="$(docker-machine ip 2> /dev/null)"
    fi

    #
    #
    #   verify docker-machine is running and the IP is known
    #
    #
    if [[ ! $IP ]]; then
        printf "\n>>>\n>>>\n>>> ERROR: couldnt determine IP of docker-machine\n>>>\n" >> /dev/stderr
        exit 1
    fi
    printf "\n>>>\n>>>\n>>> docker-machine running at $IP\n>>>\n"

    DOCKER_MACHINE_IP="$IP"
    return 0
}

#
#
#   build env from .env file
#
#
# export PROJECT_ROOT=~/Documents/dev/uc
while IFS='' read -r line || [[ -n "$line" ]]; do
    export "$line"
done < ".env"

#
#
#   build docker images, start docker-machine if not running
#   get IP address for 'localhost' forwarding and start nginx
#
#
docker_compose_build &
get_docker_ip
eval $(docker-machine env)    
start_nginx &

#
#
#   transpile server code
#
#
node_modules/.bin/tsc-watch --onFirstSuccess docker_compose_up \
--project config/tsconfig/tsconfig.server.dev.json --watch --preserveWatchOutput 1>> /dev/stdout 2>> /dev/stderr &

