FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install wget php7.4 php-fpm php-mysql vim  mariadb-client -y

RUN mkdir -p /var/www/html
 RUN chown -R root:root /var/www/html

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
 RUN chmod 755 /etc/php/7.4/fpm/pool.d/www.conf

COPY ./tools/wp_conf.sh /usr/local/bin/wp_conf.sh
RUN chmod 755 /usr/local/bin/wp_conf.sh

RUN mkdir /run/php #

RUN wget https://wordpress.org/wordpress-6.2.2.tar.gz -P /var/www/html
RUN cd /var/www/html && tar -xzf wordpress-6.2.2.tar.gz && rm wordpress-6.2.2.tar.gz


RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html/wordpress

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_conf.sh"]
