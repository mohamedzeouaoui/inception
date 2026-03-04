# Path to the docker-compose file
COMPOSE_FILE = srcs/docker-compose.yml
DB_VOLUME_PATH = /home/mzeouaou/data/mariadb
WP_VOLUME_PATH = /home/mzeouaou/data/wp_webfiles

.PHONY: all create_hdd build up down rmi-local rem-host-folder clean fclean re

# default target: build and start everything
all: up

# create host data directories
create_hdd:
	sudo mkdir -p $(DB_VOLUME_PATH) $(WP_VOLUME_PATH)

# build images
build:
	docker compose -f $(COMPOSE_FILE) build

# build and set-up all the containers, volumes, networks
up: create_hdd build
	docker compose -f $(COMPOSE_FILE) up -d

# stop and remove all the containers, networks, volumes
down:
	docker compose -f $(COMPOSE_FILE) down --volumes

# remove local project images
rmi-local:
	docker compose -f $(COMPOSE_FILE) down --rmi all

rem-host-folder:
	sudo rm -r $(DB_VOLUME_PATH) $(WP_VOLUME_PATH)

# clean-up
clean: down rmi-local

# clean-up + recreate host data directory
fclean: clean rem-host-folder

# stop, remove, clean, rebuild, set-up, run
re: clean up