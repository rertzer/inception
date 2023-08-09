FROM	debian:bullseye

RUN	apt-get update && apt-get upgrade && apt-get install mariadb-server -y

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 755 /var/run/mysqld
COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	./tools/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN	chmod 755 /usr/local/bin/init_mariadb.sh


EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init_mariadb.sh"]
