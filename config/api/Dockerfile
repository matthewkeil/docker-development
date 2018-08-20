FROM node:latest

COPY ./dist/api ./src
COPY ./config/api ./config

WORKDIR .

RUN npm install

EXPOSE 3001

ENTRYPOINT ["nodemon", "./src"]

# To build:
# docker build -f server/.dockerfile --tag uc/api .

# To run:
# docker run -d -p 3001:3001 --name server uc/api
