#!/bin/sh

echo "having a nap\n"
sleep 20

if [ ! -f wp-config.php ]
then
	echo "Wordpress configuration\n"
	wp core config \
		--dbhost=mariadb:3306 \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PSSWD \
		--allow-root
	wp core install \
		--title=$WP_TITLE \
		--admin_user=$WP_USERNAME \
		--admin_password=$WP_PASSWD \
		--admin_email=$WP_EMAIL \
		--url=$WP_URL \
		--allow-root
fi
echo "starting php-fpm\n"
exec /usr/sbin/php-fpm7.4 -F
