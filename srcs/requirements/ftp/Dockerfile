FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install vsftpd -y


ARG FTP_USER
ARG FTP_PSSWD

RUN mkdir -p /etc/vsftpd
RUN mkdir -p /var/run/vsftpd/empty
RUN mkdir -p /var/www/html/wordpress

RUN adduser \
	--gecos "$FTP_USER,42,42,42,ftp user" \
	--disabled-password \
	--home /var/www/html/wordpress \
	--no-create-home \
	$FTP_USER

RUN echo "$FTP_USER:$FTP_PSSWD" | /usr/sbin/chpasswd

RUN chown -R $FTP_USER:$FTP_USER /var/www/html/wordpress

RUN echo $FTP_USER | tee -a /etc/vsftpd.userlist

COPY ./conf/vsftpd.conf /etc/vsftpd/
COPY ./scripts/init.sh /etc/vsftpd/

STOPSIGNAL SIGKILL

ENTRYPOINT ["sh", "/etc/vsftpd/init.sh"]
	

