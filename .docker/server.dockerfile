FROM node:latest

# VOLUME [ "/server:/server" ]

COPY config/ssl /etc/ssl/certs
COPY package.json tsconfig.json /
RUN npm install

EXPOSE 4000

ENTRYPOINT ["npm", "run", "api:dev"]

# To build:
# docker build -f server/.dockerfile --tag uc/api .

# To run:
# docker run -d -p 3001:3001 --name server uc/api
