FROM nginx:latest

RUN addgroup --system nginx && useradd -g nginx nginx

RUN set -ex;                                                                                            \
	fetchDeps='ca-certificates wget';                                                                   \
    apt-get update;                                                                                     \
	apt-get install -y --no-install-recommends $fetchDeps;                                              \
	rm -rf /var/lib/apt/lists/*;                                                                        \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";                                  \
	wget -O /usr/local/bin/gosu                                                                         \
    "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch";                   			\
	wget -O /usr/local/bin/gosu.asc                                                                     \
    "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch.asc";                			\
	export GNUPGHOME="$(mktemp -d)";                                                                    \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;    \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;                                   \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc;                                                         \
	chmod +x /usr/local/bin/gosu;                                                                       \
	gosu nobody true;                                                                                   \
	apt-get purge -y --auto-remove $fetchDeps

COPY ./config/nginx/default.conf /etc/nginx/conf.d/

COPY ./config/ssl /usr/local/etc/ssl/certs/

RUN ln -sf /dev/stdout /var/log/nginx/access.log

EXPOSE 80 443

ENTRYPOINT [ "gosu", "nginx", "nginx", "-g", "daemon off;" ]

# To build:
# docker build -f nginx/.dockerfile --tag uc/nginx ../

# To run:
# docker run -d -p 80:6379 --name nginx uc/nginx