#!/bin/bash

# set -x


if [[ $MONGODB_ROOT_USER == "" ]]; then
    read -p '>>> enter a ROOT username (default: admin): ' MONGODB_ROOT_USER
    if [[ "$MONGODB_ROOT_USER" == "" ]]; then
        MONGODB_ROOT_USER="admin"
    fi
    export MONGODB_ROOT_USER=$MONGODB_ROOT_USER
    echo "export MONGODB_ROOT_USER=$MONGODB_ROOT_USER" >> /.bashrc
fi


if [[ $MONGODB_ROOT_PASS == "" ]]; then
    read -p '>>> enter a ROOT password (default: pass): ' MONGODB_ROOT_PASS
    if [[ "$MONGODB_ROOT_PASS" == "" ]]; then
        MONGODB_ROOT_PASS="pass"
    fi
    export MONGODB_ROOT_PASS=$MONGODB_ROOT_PASS
    echo "export MONGODB_ROOT_PASS=$MONGODB_ROOT_PASS" >> /.bashrc
fi


# Wait for MongoDB to boot
NOT_RUNNING=1
while [[ NOT_RUNNING -ne 0 ]]; do
    echo ">>> waiting for of mongo daemon to start..."
    sleep 1
    mongo admin --eval "help" >/dev/null 2>&1
    NOT_RUNNING=$?
done


# Create the admin user
echo "=> Creating ROOT user $MONGODB_ROOT_USER for MongoDB"

mongo admin --eval "db.createUser({user: '$MONGODB_ROOT_USER', pwd: '$MONGODB_ROOT_PASS', roles:[{role:'root',db:'admin'}]});"

sleep 1

exit 0