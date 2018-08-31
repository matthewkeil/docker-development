FROM nginx:latest

COPY .docker/config/nginx.conf /etc/nginx/nginx.conf
COPY ./.docker/ssl /etc/ssl/certs

EXPOSE 80 443

ENTRYPOINT ["/bin/nginx_start"]

# To build:
# docker build -f nginx/.dockerfile --tag uc/nginx ../

# To run:
# docker run -d -p 80:6379 --name nginx uc/nginx