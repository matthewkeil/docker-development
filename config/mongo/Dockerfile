FROM mongo:latest

COPY config/mongo/first_run.js /docker-entrypoint-initdb.d/
COPY config/mongo config/ssl /config/

RUN chmod +rx /config/*.sh && . config/set_env.sh && apt-get update

EXPOSE 27017

ENTRYPOINT ["mongod"]
#
# To build:
# docker build -f config/mongo/Dockerfile --tag uc/mongo .
#
# To run the image (add -d to run in the background)
# docker run -p 27017:27017 --env-file ./.docker/mongo/dev.env -d --name mongo
#