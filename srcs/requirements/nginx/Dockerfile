FROM debian:bullseye

# downloads
RUN apt-get update && apt-get upgrade && apt-get install \
	nginx openssl vim curl -y

# nginx certifcate
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/inception.crt -keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=learner/CN=rertzer.42.fr/UID=rertzer"

# nginx conf
RUN mkdir -p /var/run/nginx
#COPY conf/nginx.conf /etc/nginx.conf
