FROM node:latest

# RUN groupadd -r graphql && useradd -r -g graphql graphql

# RUN set -ex;                                                                                            \
# 	fetchDeps='ca-certificates wget';                                                                   \
#     apt-get update;                                                                                     \
# 	apt-get install -y --no-install-recommends $fetchDeps;                                              \
# 	rm -rf /var/lib/apt/lists/*;                                                                        \
# 	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";                                  \
# 	wget -O /usr/local/bin/gosu                                                                         \
#     "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch";                   			\
# 	wget -O /usr/local/bin/gosu.asc                                                                     \
#     "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch.asc";                			\
# 	export GNUPGHOME="$(mktemp -d)";                                                                    \
# 	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;    \
# 	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;                                   \
# 	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc;                                                         \
# 	chmod +x /usr/local/bin/gosu;                                                                       \
# 	gosu nobody true;                                                                                   \
# 	apt-get purge -y --auto-remove $fetchDeps


COPY .docker/ssl /usr/local/etc/ssl/certs

COPY  package.json tsconfig.json /usr/local/graphql/

WORKDIR /usr/local/graphql/server

RUN npm install

VOLUME [ "/usr/local/graphql/server" ]

EXPOSE 4000

ENTRYPOINT [ "ls" ]

#" "To build:
# docker build -f server/.dockerfile --tag uc/api .

# To run:
# docker run -d -p 3001:3001 --name server uc/api
