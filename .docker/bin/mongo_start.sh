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
        
        $BASE_CMD               &
        mongo_build_db.sh     && \
        mongod --shutdown
    fi
else
    printf ">>>\n>>> starting mongo for the first time and creating root account\n>>>\n>>> starting daemon\n>>>\n"

    $BASE_CMD               & 
    mongo_build_root.sh   && \
    mongo_build_db.sh     && \
    mongod --shutdown
fi

exec $MONGOD