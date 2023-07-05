all:	up

up:	build
	sudo docker compose -f srcs/docker-compose.yml up

down:
	sudo docker compose -f srcs/docker-compose.yml down

build:
	sudo docker compose -f srcs/docker-compose.yml build

run:	build
	sudo docker-compose  run

clean: 	down
	sudo docker system prune -af

re:	clean
	make all

.PHONY: all build up down run clean re
