FROM haproxy:latest
MAINTAINER Loup <loup@redice-inc.com>

# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

ENV DOCKER_GEN_VERSION 0.7.4
RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY . /app/
WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock
ENV STATS_PORT 1936

EXPOSE 80
EXPOSE 443
EXPOSE 1936

RUN touch /var/run/haproxy.pid

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["docker-gen", "-config", "/app/docker-gen.cfg"]
