FROM redis:latest

COPY .docker/config/redis.conf /etc/redis/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]

# To build:
# docker build -f redis/.dockerfile --tag uc/redis ../

# To run:
# docker run -d -p 6379:6379 --name redis uc/redis