FROM mongo:latest

WORKDIR .

VOLUME [ "/data/db:/data/db" ]
VOLUME [ "/var/log/mongodb:/var/log/mongodb" ]

COPY .docker/bin /bin/

COPY .docker/ssl /etc/ssl/certs/

RUN chmod +rx /bin/* && \
    chown -R mongodb:mongodb /data /var /bin && \
    ln -sf /dev/stdout /var/log/mongodb/mongod.log

EXPOSE 27017

ENTRYPOINT ["/bin/mongo_start"]
#
# To build:
# docker build -f config/mongo/Dockerfile --tag uc/mongo .
#
# To run the image (add -d to run in the background)
# docker run -p 27017:27017 --env-file ./.docker/mongo/dev.env -d --name mongo
#