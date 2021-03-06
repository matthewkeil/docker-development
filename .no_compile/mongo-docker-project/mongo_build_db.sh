#!/bin/bash

#
#
#   Setup environment
#
#
# set -x

#
#
#   verify parameters
#
#

if [[ $MONGO_DB_NAME == "" ]]; then
    read -p ">>> enter a db name (default: booger-eater): " MONGO_DB_NAME
    if [[ "$MONGO_DB_NAME" == "" ]]; then
        MONGO_DB_NAME="booger-eater"
    fi
    # echo "export MONGO_DB_NAME=$MONGO_DB_NAME" >> /.bashrc
fi

if [[ $MONGO_USERNAME == "" ]]; then
    read -p '>>> enter a username (default: apiUser): ' MONGO_USERNAME
    if [[ "$MONGO_USERNAME" == "" ]]; then
        MONGO_USERNAME="apiUser"
    fi
    # echo "export MONGO_USERNAME=$MONGO_USERNAME" >> /.bashrc
fi

if [[ $MONGO_PASSWORD == "" ]]; then
    read -p '>>> enter a password (default: apiPass): ' MONGO_PASSWORD
    if [[ "$MONGO_PASSWORD" == "" ]]; then
        MONGO_PASSWORD="apiUser"
    fi
    # echo "export MONGO_PASSWORD=$MONGO_PASSWORD" >> /.bashrc
fi

if [[ -f $SETUP_FILE ]]; then
    printf ">>>\n>>> ERROR: database with same name already exists\n>>>"
    exit 1
fi

# Wait for MongoDB to boot
NOT_RUNNING=1
while [[ NOT_RUNNING -ne 0 ]]; do
    echo ">>> waiting for of mongo daemon to start..."
    sleep 1
    mongo admin --eval "help" >/dev/null 2>&1
    NOT_RUNNING=$?
done

mongo admin << EOF
use $MONGO_DB_NAME
db.createUser({user: '$MONGO_USERNAME', pwd: '$MONGO_PASSWORD', roles:[{role:'dbOwner', db:'$MONGO_DB_NAME'}]})
EOF

sleep 1

printf "${MONGO_DB_NAME}\n${MONGO_USERNAME}\n${MONGO_PASSWORD}\n" >> $SETUP_FILE

echo "DB setup complete"

exit 0
