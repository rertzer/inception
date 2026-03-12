# Inception - Docker Infrastructure Project

## Overview

Inception is a comprehensive Docker-based infrastructure project that sets up a complete containerized environment featuring WordPress with multiple supporting services.

## Build and Deployment

### Makefile

- `make build` # Create volumes and build all Docker images
- `make up` # Start all containers in detached mode
- `make down` # Stop all running containers
- `make clean` # Stop containers and remove Docker system data
- `make fclean` # Completely remove containers, images, and data volumes
- `make re` # Full rebuild: clean and build fresh

### Prerequisites

- Docker Engine (latest version)
- Docker Compose (version 3+)
- sudo access (required for docker commands)

### Setup Steps

1. Create `.env` file in the `srcs/` directory with all required variables
2. Run `make build` to create volumes and build images
3. Run `make up` to start the infrastructure
4. Access services:
   - WordPress: `https://localhost` (HTTPS only)
   - Adminer: `http://localhost:80`
   - FTP: `localhost:21`

## Credentials

All services use `.env` file for credentials and configuration

### Database

- `SQL_DATABASE`
- `SQL_USER`
- `SQL_PSSWD`
- `SQL_ROOT_PSSWD`

### WordPress

- `WP_TITLE`
- `WP_USERNAME`
- `WP_PASSWD`
- `WP_EMAIL`
- `WP_URL`

### SSL Certificate

- `COUNTRY`
- `STATE`
- `CITY`
- `ORG`
- `ORG_UNIT`
- `DOMAIN_NAME`
- `CERT_UID`

### FTP Credentials

- `FTP_USER`
- `FTP_PSSWD`

### Adminer Configuration

- `APACHE_LOG_DIR`

### Path Configuration

- `VOLUMES_PATH`

## Architecture

The project follows a microservices architecture where each service runs in its own Docker container and communicates through a custom Docker network. The system is managed through `docker-compose` for easy orchestration and deployment.

![Inception Diagram](inception_schema.pdf)

### NGINX (Web Server)

- **Container**: `nginx`
- **Port**: 443
- **Purpose**: Reverse proxy and web server

#### Features:

- **TLS/SSL Encryption:** Enforces TLSv1.2 and TLSv1.3 only for maximum security
- **Self-Signed Certificates:** Generated during container build with customizable certificate information (country, state, city, organization, etc.)
- **Reverse Proxy:** Routes PHP requests to the WordPress PHP-FPM container
- **Static File Serving:** Serves WordPress files and static assets

#### Configuration (`nginx.conf`)

- Listens on port 443 for both IPv4 and IPV6
- Routes HTTP requests to `/var/www/html/vordpress`
- Forwards `.php` requests to the WordPress PHP-FPM container via `fastcgi_pass`
- Uses named DNS resolution to communicate with containers

### WordPress + PHP-FPM (Application Server)

- **Container**: `wordpress`
- **Internal Port**: 9000 (PHP-FPM FastCGI)
- **Purpose**: WordPress CMS with PHP application execution

#### Features:

- **WordPress 6.2.2**: Latest stable version automatically downloaded and extracted
- **PHP-FPM 7.4**: Runs as Fast CGI Process Manager for optimal performance
- **WP-CLI**: Command-line tool for WordPress Management
- **Redis Integration**: Automatically configured for caching
- **Dynamic Process Manager**: Scales PHP processes based on demand

#### Configuration (`www.conf`):

- Listen on all interfaces on port 9000
- Dynamic process manager
  - Maximum 5 concurrent PHP processes
  - 2 Initial processes
  - Between 1 and 3 idle processes

#### Initialization Process (`wp_conf.sh`):

1. Waits 20 seconds for MariaDB to start (graceful startup delay)
2. Generates `wp-config.php` with database credentials
3. Installs WordPress core
4. Configures Redis for caching:
   - Installs and activates the Redis Cache plugin
   - Sets Redis as primary cache backend
   - Points to Redis container at redis:6379
5. Updates all plugins
6. Starts PHP-FPM in foreground mode

### MariaDB (Database Server)

- **Container**: `mariadb`
- **Internal Port**: 3306
- **Purpose**: Relational database for WordPress

#### Features

- **Persitent Storage**: Data survives container restarts via volume mount
- **Automated Initialization**: Creates database and users on first run

#### Initialization Process (`init_mariadb.sh`)

- Creates the database if it don't exists
- Creates the users and sets their passwords according to the environment variable
- Grants users privileges
- Root access is restricted to `localhost`
- Restart the database

### Redis (Cache Layer)

- **Container**: `redis`
- **Internal Port**: 6379
- **Purpose**: In-memory caching for WordPress

#### Features and Configuration (`Dockerfile`)

- **Memory Limit**: 128 MB maximum memory usage
- **Eviction Policy**: Last Recently Used (LRU)
- **Network Mode**: Accessible only from containers in the `inception` network
- **Protected Mode**: Disabled to allow container-to-container communication

### Adminer (Database Management Tool)

- **Container**: `adminer`
- **External Port**: 8080
- **Purpose**: Web-based database administration interface. Browse, query and manage MariaDB database

#### Features and Configuration (`000-default.conf`, `www.conf`)

- **Apache Web Server**: Runs on port 8080
- **Access**: `http://localhost:8080` (HTTP only)
- Automatically connects to MariaDB container
- Enables viewing of WorPress database structure and content

### vsftpd (FTP Server)

- **Container**: `ftp`
- **External Ports**:
  - 21 FTP control channel
  - 20 FTP data channel
  - 42100-42105: passive mode data transfer
- **Purpose**: File transfer to WordPress files

#### Features and Configuration (`vsftpd.conf`)

- **Secure Access**:
  - User authentication required
  - Local user login enabled
  - Anonymous access disabled
- **WordPress Directory**: Access restricted to `/var/www/html/wordpress`
- **Passive Mode**: Configured for firewall-friendly passive mode transfers

#### Initialization (Dockerfile and `init.sh`)

- Create user `FTP_USER` and sets it's password
- Add user and group `FTP_USER` to `vsftpd` userlist
- Change `/var/www/html/wordpress` ownership to `FTP_USER:FTP_USER`

## How Everything Works Together

### Startup Sequence

1. Docker Daemon receives `docker-compose up` command
2. Volume Creation: Bind mounts created at `${VOLUMES_PATH}/wordpress` and `${VOLUMES_PATH}/mariadb`
3. Network Creation: Custom bridge network named inception created for inter-container communication
4. Container Startup Order:
   1. MariaDB starts first (no dependencies)
   2. Redis starts independently
   3. MariaDB initialization script runs:
      - Checks if database exists
      - If not, creates database and users
      - Starts MariaDB service
   4. WordPress and Adminer wait for MariaDB
   5. NGINX waits for WordPress
   6. FTP starts independently

### Data Persistence

- **WordPress Files**: Stored on `${VOLUMES_PATH}/wordpress` volume, mounted to all containers needing access
- **Database Files**: Stored on `${VOLUMES_PATH}/mariadb` volume, survives container restarts
- **Container Removal**: Data volumes remain; infrastructure can be rebuilt without data loss

### Network Communication

Containers communicate using DNS names (Docker's embedded DNS):

- nginx → wordpress:9000 (FastCGI)
- wordpress → mariadb:3306 (MySQL protocol)
- wordpress → redis:6379 (Redis cache)
- adminer → mariadb:3306 (MySQL protocol)
- ftp → Volume mount (direct file access)

### Service Restart Policy

- Automatically restart failed containers

### Security Features

- **TLS/SSL Encryption**: HTTPS only on NGINX (TLS 1.2 & 1.3)
- **Network Isolation**: Services only accessible via bridge network (except exposed ports)
- **FTP Authentication**: Username/password required for FTP access
- **Database Permissions**: Limited user permissions for WordPress database
- **Chroot Jail**: FTP users restricted to WordPress directory

## Troubleshooting

### Services won't start

- Check `.env` file exists and has all required variables
- Verify Docker daemon is running
- Check port availability (443, 8080, 21, 20)

### Database connection errors

- Ensure MariaDB fully initializes (wait 10-15 seconds)
- Verify `SQL_*` environment variables are set correctly
- Check mariadb container logs: docker logs mariadb

### WordPress not loading

- Verify NGINX and PHP-FPM containers are running
- Check NGINX logs: docker logs nginx
- Verify certificate generation worked

### FTP connection issues

- Verify FTP container is running
- Check `FTP_USER` and `FTP_PSSWD` are set
- Use passive mode (ports 42100-42105)
