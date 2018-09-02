#!/bin/bash

#
#
#   Setup environment
#
#
# set -o noclobber
# set -x

export NODE_ENV=${NODE_ENV:-"development"}

# mongod command options
# add values to the below to set them otherwise leave blank
export MONGO_AUTH=${MONGO_AUTH:-""} # defaults to true, set to "false" to disable
export MONGO_SSL=${MONGO_SSL:-""} # defaults to true, set to "false" to disable
export MONGO_PROFILING=${MONGO_PROFILING:-""}
export MONGODB_ROOT_USER=${MONGODB_ROOT_USER:-"admin"}
export MONGODB_ROOT_PASS=${MONGODB_ROOT_PASS:-"pass"}
export MONGO_DB_NAME=${MONGO_DB_NAME:-"default"}
export MONGO_USERNAME=${MONGO_USERNAME:-"apiUser"}
export MONGO_PASSWORD=${MONGO_PASSWORD:-"apiPass"}
export MONGO_DATA="${MONGO_DATA:-"/data/db"}"
export SETUP_DIR="${MONGO_DATA}/.setup"
export SETUP_FILE="${SETUP_DIR}/${MONGO_DB_NAME}.conf"


#
#
#   build mongod command
#
#
BASE_CMD="mongod" #--dbpath=/usr/local/data/db --smallfiles --directoryperdb

MONGOD="${BASE_CMD} --noscripting"

if [[ "$MONGO_AUTH" == "false" ]]; then
    echo ">>> Auth Dissabled <<<"
else
    MONGOD="$MONGOD --auth"
fi

if [[ "$MONGO_SSL" == "false" ]]; then
    echo ">>> SSL Dissabled <<<"
else
    MONGOD="$MONGOD --sslMode requireSSL                \
    --sslPEMKeyFile /usr/local/etc/ssl/certs/uc.pem     \
    --sslCAFile /usr/local/etc/ssl/certs/root.crt "
fi

if [[ $MONGO_PROFILING != "" ]]; then
    MONGOD="$MONGOD --profile $MONGO_PROFILING"
fi


function wait_for_mongo() {
    # Wait for MongoDB to boot
    NOT_RUNNING=1
    while [[ NOT_RUNNING -ne 0 ]]; do
        echo ">>> waiting for of mongo daemon to start..."
        sleep 1
        mongo admin --eval "help" >/dev/null 2>&1
        NOT_RUNNING=$?
    done
}

function build_root() {
    # Create the admin user
    wait_for_mongo
    echo "=> Creating ROOT user $MONGODB_ROOT_USER for MongoDB"
    mongo admin --eval "db.createUser({user: '$MONGODB_ROOT_USER', pwd: '$MONGODB_ROOT_PASS', roles:[{role:'root',db:'admin'}]});"
    sleep 1
}

function build_db() {
    wait_for_mongo
    echo "=> Creating user $MONGO_USERNAME on database $MONGODB_DB_NAME"
    mongo admin << EOF
    use $MONGO_DB_NAME
    db.createUser({user: '$MONGO_USERNAME', pwd: '$MONGO_PASSWORD', roles:[{role:'dbOwner', db:'$MONGO_DB_NAME'}]})
EOF
    sleep 1
    printf "${MONGO_DB_NAME}\n${MONGO_USERNAME}\n${MONGO_PASSWORD}\n" >> $SETUP_FILE
}

#
#
#   determine mongo and database status
#
#
if [[ -d $SETUP_DIR ]]; then
   
    if [[ -f $SETUP_FILE ]]; then
        printf ">>>\n>>> found setup file ${SETUP_FILE}\n>>>\n>>> daemon starting\n>>>\n"
    else
        printf ">>>\n>>> creating ${MONGO_USERNAME} account on database named ${MONGO_DB_NAME}\n>>>\n>>> starting daemon\n>>>\n"
        
        $BASE_CMD           &
        build_db            && \
        mongod --shutdown
    fi
else
    printf ">>>\n>>> starting mongo for the first time and creating root account\n>>>\n>>> starting daemon\n>>>\n"

    $BASE_CMD               & 
    build_root              && \
    build_db                && \
    mongod --shutdown
fi

exec $MONGOD