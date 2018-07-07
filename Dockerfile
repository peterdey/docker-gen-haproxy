FROM alpine:3.7
MAINTAINER Peter Dey <docker@realmtech.net>

ENV DOCKER_GEN_VERSION 0.7.4

RUN apk add --no-cache \
        haproxy \
        bash wget ca-certificates \
   && wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
   && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
   && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
   && touch /var/run/haproxy.pid

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST=unix:///tmp/docker.sock \
    STATS_PORT=1936 \
    SSL_CERT_FILE=/certs/certificate.pem

EXPOSE 80 443 1936

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["docker-gen", "-config", "/app/docker-gen.cfg"]
