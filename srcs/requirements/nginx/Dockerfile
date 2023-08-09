FROM debian:bullseye

# downloads
RUN apt-get update && apt-get upgrade && apt-get install \
	nginx openssl vim curl -y

# nginx certifcate
ARG DOMAIN_NAME
ARG CERT_UID
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/ssl/nginx-selfsigned.crt -keyout /etc/ssl/nginx-selfsigned.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Paul/CN=${DOMAIN_NAME}/UID=${CERT_UID}"

# nginx conf
RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/www/html/wordpress
RUN chmod 755 /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress

RUN mkdir -p /var/www/html/adminer
RUN chmod 755 /var/www/html/adminer
RUN chown -R www-data:www-data /var/www/html/adminer
RUN touch /var/www/html/adminer/adminer.php

EXPOSE 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]
