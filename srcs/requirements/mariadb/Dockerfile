FROM	debian:bullseye

RUN	apt-get update && apt-get upgrade && apt-get install mariadb-server -y

COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	./tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN	chmod 755 /usr/local/bin/init_mariadb.sh

ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
