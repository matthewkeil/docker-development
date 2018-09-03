#!/bin/sh

set -x
# get gid of docker socket file
SOCK_DOCKER_GID=`ls -ng /var/run/docker.sock | cut -f3 -d' '`

# get group of docker inside container
CUR_DOCKER_GID=`getent group docker | cut -f3 -d: || true`

# if they don't match, adjust
if [ ! -z "$SOCK_DOCKER_GID" -a "$SOCK_DOCKER_GID" != "$CUR_DOCKER_GID" ]; then
  groupmod -g ${SOCK_DOCKER_GID} docker
fi
if ! groups mongo | grep -q docker; then
  usermod -aG docker mongo
fi

# drop access from root user to jenkins user and run jenkins entrypoint
 "$@"