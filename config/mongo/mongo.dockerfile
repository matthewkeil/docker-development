FROM mongo:latest

WORKDIR /the/workdir/path

VOLUME [ "/data/db:/data/db" ]

COPY config/mongo config/ssl /config/

RUN apt-get update && chmod +rx /config/*.sh && . /config/set_env.sh

COPY config/mongo/first_run.js /docker-entrypoint-initdb.d/

EXPOSE 27017

ENTRYPOINT ["mongod", "--config", "/config/mongo.conf"]
#
# To build:
# docker build -f config/mongo/Dockerfile --tag uc/mongo .
#
# To run the image (add -d to run in the background)
# docker run -p 27017:27017 --env-file ./.docker/mongo/dev.env -d --name mongo
#