*This project has been created as part of the 42 curriculum by mzeouaou.*

<h1 align="center">Inception</h1>

<p align="center">
  <em>A small web infrastructure built with Docker and Docker Compose.</em>
</p>

<p align="center">
  <img alt="Docker" src="https://img.shields.io/badge/docker-compose-blue">
  <img alt="Base" src="https://img.shields.io/badge/base-debian%20bookworm-red">
  <img alt="42" src="https://img.shields.io/badge/school-42-black">
</p>

---

## Description

**Inception** is a system administration project that sets up a small, complete web infrastructure using **Docker Compose**. Every service runs in its own container, built from a custom Dockerfile on **Debian Bookworm**, with no ready-made images pulled from Docker Hub (except the base OS image).

The stack is made of three services:

| Service       | Role                                      | Exposed to the host        |
|---------------|-------------------------------------------|----------------------------|
| **NGINX**     | HTTPS reverse proxy (TLSv1.2 / TLSv1.3)   | Port `443`                 |
| **WordPress** | CMS running on PHP-FPM                    | No (internal only)         |
| **MariaDB**   | Database for WordPress                    | No (internal only)         |

### Architecture

```text
                    ┌──────────────────────────────── Docker network ───────────────────────────────┐
                    │                                                                               │
 Browser ──HTTPS──► │  NGINX :443  ──FastCGI :9000──►  WordPress (PHP-FPM)  ──SQL :3306──►  MariaDB  │
                    │                                          │                               │    │
                    └──────────────────────────────────────────┼───────────────────────────────┼────┘
                                                               ▼                               ▼
                                                      volume: wp_data                  volume: db_data
```

Only NGINX is reachable from outside, and only through HTTPS on port 443.

## Instructions

### Prerequisites

- Docker and Docker Compose
- Make
- The domain name added to `/etc/hosts`:

```bash
sudo sh -c 'echo "127.0.0.1 mzeouaou.42.fr" >> /etc/hosts'
```

### Configuration

The configuration is read from `srcs/.env`. Create it before the first run, with the values for the domain, the database and the WordPress users:

```bash
# srcs/.env (example, use your own values)
DOMAIN_NAME=mzeouaou.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=change_me
MYSQL_ROOT_PASSWORD=change_me_too

WP_ADMIN_USER=<admin_name>
WP_ADMIN_PASSWORD=change_me
WP_ADMIN_EMAIL=admin@example.com
WP_USER=<user_name>
WP_USER_PASSWORD=change_me
WP_USER_EMAIL=user@example.com
```

> The `.env` file contains credentials and must **never** be committed to Git.

### Run

```bash
make          # build the images and start the containers
```

| Command      | Description                                                 |
|--------------|-------------------------------------------------------------|
| `make`       | Build and start everything                                  |
| `make re`    | Clean and rebuild from scratch                              |
| `make stop`  | Stop the containers                                         |
| `make start` | Start the containers again                                  |
| `make logs`  | Follow the logs of all services                             |
| `make clean` | Remove containers, images and the data in `/home/mzeouaou/data` |

### Access

- Website: <https://mzeouaou.42.fr>
- Admin panel: <https://mzeouaou.42.fr/wp-admin>

The certificate is self-signed, so the browser will show a security warning the first time. Accept it to continue.

## Project Description

### Docker usage and sources

| What                | Where                                                       |
|---------------------|-------------------------------------------------------------|
| Orchestration       | `srcs/docker-compose.yml`                                   |
| Build contexts      | `srcs/requirements/<service>/Dockerfile`                    |
| Service configs     | `srcs/requirements/<service>/conf/*`                        |
| Setup scripts       | `srcs/requirements/<service>/tools/*`                       |
| Environment values  | `srcs/.env`                                                 |

```text
.
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

### Main design choices

- **One service per container**, each built from its own Dockerfile.
- **Custom bridge network** so the containers talk to each other by service name.
- **HTTPS only**: NGINX terminates TLS with TLSv1.2 and TLSv1.3.
- **WordPress behind PHP-FPM**: NGINX forwards PHP requests over FastCGI.
- **Persistence through named volumes**, so data survives container restarts and rebuilds.
- **Containers restart automatically** if they crash.

### Comparisons

#### Virtual Machines vs Docker

| Virtual Machines                          | Docker                                        |
|-------------------------------------------|-----------------------------------------------|
| A full OS per instance                    | Processes isolated on the host kernel         |
| Heavy on disk and memory                  | Lightweight                                   |
| Slow to boot (minutes)                    | Fast startup (seconds)                        |
| Strong isolation through a hypervisor     | Lighter isolation, shared kernel              |

#### Secrets vs Environment Variables

| Secrets                                       | Environment variables                          |
|-----------------------------------------------|------------------------------------------------|
| Mounted as files inside the container         | Injected into the process environment          |
| Safer for sensitive values                    | Simpler to use                                 |
| Not visible in `docker inspect` output        | Can leak through env or process inspection     |

**Project choice**: a `.env` file (`srcs/.env`) read by Docker Compose, kept out of version control.

#### Docker Network vs Host Network

| Docker network                                | Host network                                   |
|-----------------------------------------------|------------------------------------------------|
| Isolated from the host                        | No isolation                                   |
| Service-name DNS between containers           | Shares the host's network stack                |
| Fewer port conflicts                          | Ports can conflict with host services          |

**Project choice**: a custom bridge network.

#### Docker Volumes vs Bind Mounts

| Docker volumes                                | Bind mounts                                    |
|-----------------------------------------------|------------------------------------------------|
| Lifecycle managed by Docker                   | Direct mapping of a host path                  |
| Portable and easy to back up                  | Depend on the host's directory layout          |

**Project choice**: named volumes `db_data` and `wp_data`, stored under `/home/mzeouaou/data/` on the host.

## Resources

### Documentation

- [Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [NGINX](https://nginx.org/en/docs/)
- [WordPress](https://wordpress.org/documentation/)
- [MariaDB](https://mariadb.com/kb/en/)

### Use of AI

> Describe here how AI was used in this project (which tasks, which parts), and what you checked and understood yourself.
