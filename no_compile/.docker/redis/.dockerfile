FROM redis:latest

# change as appropriate for build
ENV APP_ENV development

COPY /.docker/redis/ /config
COPY ./.docker/ssl /config/ssl

EXPOSE 6379

ENTRYPOINT ["redis-server", "/config/redis.conf"]

# To build:
# docker build -f redis/.dockerfile --tag uc/redis ../

# To run:
# docker run -d -p 6379:6379 --name redis uc/redis