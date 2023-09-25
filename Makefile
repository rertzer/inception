all:	build up

up:
	sudo docker compose -f srcs/docker-compose.yml up -d

down:
	sudo docker compose -f srcs/docker-compose.yml down

build:
	mkdir -p $(HOME)/data/mariadb
	mkdir -p $(HOME)/data/wordpress
	sudo docker compose -f srcs/docker-compose.yml build

clean: 	down
	sudo docker system prune -af

fclean:	clean
	sudo rm -rf $(HOME)/data/mariadb
	sudo rm -rf $(HOME)/data/wordpress

re:	clean
	make all

.PHONY: all build up down run clean fclean re
