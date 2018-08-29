FROM node:latest

RUN set -x; ls;

VOLUME [ "../../.build/api:/srv/www" ]

WORKDIR /srv/www

# COPY ../../dist/api /srv/www
# COPY ../ssl /etc/ssl/certs
# COPY ../../package.json ../../tsconfig.json /
# WORKDIR .

# RUN npm install

EXPOSE 3001

ENTRYPOINT ["nodemon index"]

# To build:
# docker build -f server/.dockerfile --tag uc/api .

# To run:
# docker run -d -p 3001:3001 --name server uc/api
