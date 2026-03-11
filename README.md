# Inception
This project consists of having set up a small infrastructure composed of different services containerized with Docker.
## Implemented services:
- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress + php-fpm.
- A Docker container that contains MariaDB.
- A Docker container that contains a Redis cache for the WordPress website.
- A Docker container that contains Adminer.
- A volume that contains the WordPress database.
- A second volume that contains the WordPress website files.
- A docker-network that establishes the connection between the containers.
