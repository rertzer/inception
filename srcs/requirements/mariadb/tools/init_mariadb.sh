#!/bin/sh
if [ -d "/var/lib/mysql/${SQL_DATABASE}" ]
then
	echo "${SQL_DATABASE} already exists\n"
	#sleep 2
	#mysqladmin -u root -p${SQL_ROOT_PSSWD} shutdown
	sleep 5
else
	service mariadb start
	sleep 5
	echo "creating ${SQL_DATABASE}\n"
	mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
	mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '$SQL_PSSWD';"
	mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PSSWD}';"
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PSSWD}';"
	sleep 5

	mysqladmin -u root -p${SQL_ROOT_PSSWD} shutdown
	sleep 5
fi
exec mysqld
