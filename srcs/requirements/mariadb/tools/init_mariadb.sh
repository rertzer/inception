#!/bin/sh

service mariadb start

sleep 5

mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '$SQL_PSSWD';"
mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PSSWD}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PSSWD}';"

sleep 3
mysqladmin -u root -p${SQL_ROOT_PSSWD} shutdown
sleep 5
mysqld_safe
