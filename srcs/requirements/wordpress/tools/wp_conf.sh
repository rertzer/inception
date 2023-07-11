#!/bin/sh

echo "before sleep\n"
#export PATH=$PATH:/usr/local/mysql/bin
pwd
sleep 10
echo "after sleep\n"

if [ ! -f wp-config.php ]
then
	echo "Wordpress configuration\n"
	#echo "step 1"
	#wp core download --allow-root --path="/var/www/html/wordpress"

	echo "step 2"
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
	#cd /wordpress
	#sed -i "s/username_here/$SQL_USER/g" wp-config-sample.php
	#sed -i "s/password_here/$SQL_PSSWD/g" wp-config-sample.php
	#sed -i "s/localhost/mariadb/g" wp-config-sample.php
	#sed -i "s/database_name_here/$SQL_DATABASE/g" wp-config-sample.php
	#cp wp-config-sample.php wp-config.php	
fi
echo "starting php-fpm\n"
exec /usr/sbin/php-fpm7.4 -F
