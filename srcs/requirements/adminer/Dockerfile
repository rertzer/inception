FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install adminer -y


COPY conf/000-default.conf /etc/apache2/sites-available

RUN echo "ServerName adminer" >> /etc/apache2/apache2.conf
RUN service apache2 start && a2enconf adminer.conf

ENV APACHE_RUN_DIR=/run/apache2
ENV APACHE_PID_FILE=/run/apache2/apache2.pid
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2

ENTRYPOINT ["/usr/sbin/apache2", "-DFOREGROUND"]
