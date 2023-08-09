FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install redis  procps -y

RUN sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/g" /etc/redis/redis.conf
RUN sed -i "s/# maxmemory <bytes>/maxmemory 128mb/g" /etc/redis/redis.conf
RUN sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/g" /etc/redis/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode", "no"]
