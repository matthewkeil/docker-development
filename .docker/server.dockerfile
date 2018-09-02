FROM node:latest

COPY .docker/ssl /etc/ssl/certs

ENV HOME=/home/app

# RUN useradd --user-group --create-home --shell /bin/false app

WORKDIR ${HOME}

# USER app

EXPOSE 4000

ENTRYPOINT [ "npm", "run", "server" ]

#" "To build:
# docker build -f server/.dockerfile --tag uc/api .

# To run:
# docker run -d -p 3001:3001 --name server uc/api
