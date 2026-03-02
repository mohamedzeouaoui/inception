# User Documentation

## Services Provided

- **NGINX**: HTTPS entrypoint (TLSv1.2/TLSv1.3)
- **WordPress**: website (PHP-FPM)
- **MariaDB**: database for WordPress

## Start / Stop

```bash
make        # build + start
make stop   # stop
make start  # start
make logs   # logs
make clean  # removes containers/images and /home/mzeouaou/data
```

## Access

- Website: `https://mzeouaou.42.fr`
- Admin panel: `https://mzeouaou.42.fr/wp-admin`

If your browser warns about the certificate, that’s expected with a self-signed/local TLS setup.

## Credentials (.env)

Credentials/config are in `srcs/.env` (do not commit it):

- DB: `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_ROOT_PASSWORD`
- WP admin: `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`

View:
```bash
cat srcs/.env
```

## Check Services Are Running

```bash
docker ps
make logs
```

Quick checks:

```bash
curl -kI https://mzeouaou.42.fr
docker exec mariadb mysql -u root -p -e "SELECT 1;"
```
