FROM nginx:latest

VOLUME /cache

COPY ../public /public/
COPY ./.docker/ssl /ssl

RUN set -x; chmod 600 /ssl

EXPOSE 80 443

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]


# To build:
# docker build -f nginx/.dockerfile --tag uc/nginx ../

# To run:
# docker run -d -p 80:6379 --name nginx uc/nginx