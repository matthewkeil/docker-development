FROM nginx:latest

COPY ./.docker/config/nginx.development.conf /etc/nginx/nginx.conf

COPY ./.docker/ssl /etc/ssl/certs

RUN ln -sf /dev/stdout /var/log/nginx/access.log

EXPOSE 80 443

ENTRYPOINT ["nginx", "-g", "daemon off;" ]

# To build:
# docker build -f nginx/.dockerfile --tag uc/nginx ../

# To run:
# docker run -d -p 80:6379 --name nginx uc/nginx