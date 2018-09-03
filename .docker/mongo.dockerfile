FROM mongo:latest

RUN groupadd -r mongo && useradd -r -g mongo mongo

ENV GOSU_VERSION 1.10

RUN set -ex;                                                                                            \
	fetchDeps='ca-certificates wget';                                                                   \
    apt-get update;                                                                                     \
	apt-get install -y --no-install-recommends $fetchDeps;                                              \
	rm -rf /var/lib/apt/lists/*;                                                                        \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";                                  \
	wget -O /usr/local/bin/gosu                                                                         \
    "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch";                    \
	wget -O /usr/local/bin/gosu.asc                                                                     \
    "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc";                \
	export GNUPGHOME="$(mktemp -d)";                                                                    \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;    \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;                                   \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc;                                                         \
	chmod +x /usr/local/bin/gosu;                                                                       \
	gosu nobody true;                                                                                   \
	apt-get purge -y --auto-remove $fetchDeps
    
RUN set -x;                                                                                             \
    mkdir -p /data/db;                                                                                  \
    chown -R 1001:1001 /data/db;                                                                      \
    chmod -R o+rwx /data/db;                                                                            \
    ln -sf /dev/stdout /var/log/mongodb/mongod.log

VOLUME /data/db

COPY .docker/bin /usr/local/bin/

COPY .docker/ssl /usr/local/etc/ssl/certs/mongo

WORKDIR /usr/local/bin

EXPOSE 27017

ENTRYPOINT [ "mongo_start.sh" ]
#
# To build:
# docker build -f config/mongo/Dockerfile --tag uc/mongo .
#
# To run the image (add -d to run in the background)
# docker run -p 27017:27017 --env-file ./.docker/mongo/dev.env -d --name mongo
#