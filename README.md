*This project has been created as part of the 42 curriculum by mzeouaou.*

# Inception

## Description

Inception is a small Docker-based infrastructure orchestrated with Docker Compose. It runs:

- **NGINX** (HTTPS reverse proxy)
- **WordPress** (PHP-FPM)
- **MariaDB** (database)

All images are built from Debian Bookworm using custom Dockerfiles.

## Instructions

### Prerequisites

- Docker + Docker Compose
- Make
- Domain in `/etc/hosts`:
  ```bash
  sudo sh -c 'echo "127.0.0.1 mzeouaou.42.fr" >> /etc/hosts'
  ```

### Run

```bash
make        # build + up
make re     # clean + rebuild
make stop   # stop containers
make start  # start containers
make logs   # follow logs
make clean  # remove containers/images and /home/mzeouaou/data
```

### Access

- Website: `https://mzeouaou.42.fr`
- Admin: `https://mzeouaou.42.fr/wp-admin`

## Project Description

### Docker usage & sources

- Orchestration: `srcs/docker-compose.yml`
- Build context: `srcs/requirements/*/Dockerfile`
- Service configs/scripts: `srcs/requirements/*/conf/*` and `srcs/requirements/*/tools/*`

### Main design choices

- Separate containers per service + custom bridge network.
- HTTPS termination on NGINX with TLSv1.2/TLSv1.3.
- WordPress runs behind PHP-FPM.
- Persistence through Docker named volumes.

### Comparisons

#### Virtual Machines vs Docker

- **VMs**: full OS per instance; heavier; slower to boot.
- **Docker**: process isolation; lighter; fast startup.

#### Secrets vs Environment Variables

- **Secrets**: safer for sensitive values (mounted files).
- **Env vars**: simpler but can leak via process/env inspection.
- **Project Choice**: `.env` file (`srcs/.env`) used by Compose for configuration.

#### Docker Network vs Host Network

- **Docker network**: isolation + service-name DNS; fewer host port conflicts.
- **Host network**: no isolation; easier to conflict.

#### Docker Volumes vs Bind Mounts

- **Volumes**: Docker-managed lifecycle; portable.
- **Bind mounts**: direct host path mapping.
- **Project Choice**: named volumes `db_data` and `wp_data` (mapped to `/home/mzeouaou/data/*` in this setup).

## Resources

- Docs: Docker, Compose, NGINX, WordPress, MariaDB
  - https://docs.docker.com/
  - https://docs.docker.com/compose/
  - https://nginx.org/en/docs/
  - https://wordpress.org/documentation/
  - https://mariadb.com/kb/en/

