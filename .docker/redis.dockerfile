FROM redis:latest

COPY .docker/config/redis.conf /etc/redis/redis.conf
COPY .docker/ssl /etc/ssl/certs

# not sure if i need this 
# VOLUME [ "/var/lib/redis:/var/lib/redis" ]
# RUN chown redis:redis /var/lib/redis/*

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]

# To build:
# docker build -f redis/.dockerfile --tag uc/redis ../

# To run:
# docker run -d -p 6379:6379 --name redis uc/redis