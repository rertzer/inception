#!/bin/sh

if [ ! -f /var/www/html/wordpress/wp-config.php ]
then
	wp config create \
		--allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PSSWD \
		--dbhost=mariadb:3306 \
		--path=/var/www/html/wordpress
fi

/usr/sbin/php-fpm8.2 -F -R
