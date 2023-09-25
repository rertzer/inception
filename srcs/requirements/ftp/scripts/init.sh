chown -R $FTP_USER:$FTP_USER /var/www/html/wordpress
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
