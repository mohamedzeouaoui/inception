# Developer Documentation

## Setup (from scratch)

### Prerequisites

- Docker + Docker Compose
- Make

### Configuration

1) Hostname
```bash
sudo sh -c 'echo "127.0.0.1 mzeouaou.42.fr" >> /etc/hosts'
```

2) Environment file

Create `srcs/.env`:
```env
DOMAIN_NAME=mzeouaou.42.fr
DB_NAME=wordpress
DB_USER=wpuser
DB_PASSWORD=your_user_password
DB_ROOT_PASSWORD=your_root_password
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=admin@mzeouaou.42.fr
```

Secrets note: this setup uses `.env` (no Docker secrets).

## Build & Launch

### Makefile

```bash
make      # build + up
make re   # clean + rebuild
make stop
make start
make logs
make clean
```

### Docker Compose

```bash
docker compose -f srcs/docker-compose.yml build
docker compose -f srcs/docker-compose.yml up -d
docker compose -f srcs/docker-compose.yml down
```

## Manage containers & volumes

```bash
docker ps
docker compose -f srcs/docker-compose.yml logs -f
docker exec -it mariadb mysql -u root -p
docker volume ls
docker volume inspect srcs_db_data
docker volume inspect srcs_wp_data
```

## Data persistence

- The Compose stack uses named volumes (`db_data`, `wp_data`).
- In this repository, those volumes are configured with bind driver options to persist on the host at:
  - `/home/mzeouaou/data/mariadb/`
  - `/home/mzeouaou/data/wordpress/`


## Development Workflow

1. Make changes to Dockerfiles or configuration files
2. Rebuild affected services: `make re` or `docker-compose build`
3. Test changes: `make start`
4. Check logs: `make logs`
5. Debug issues by accessing container shells
6. Commit changes to version control
