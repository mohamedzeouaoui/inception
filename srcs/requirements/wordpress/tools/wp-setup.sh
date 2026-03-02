#!/bin/bash

# Wait for MariaDB
until mysql -h mariadb -u "${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" "${WORDPRESS_DB_NAME}" -e "SELECT 1" &> /dev/null
do
  echo "Waiting for MariaDB..."
  sleep 3
done
echo "MariaDB is ready!"

# Download WordPress if not already downloaded
if [ ! -f /var/www/html/wp-load.php ]; then
  wp core download --allow-root
fi

# Create wp-config.php if it doesn't exist
if [ ! -f /var/www/html/wp-config.php ]; then
  wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost=mariadb \
    --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
  wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="My Site" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root
    
  # Create second user
  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=author \
    --allow-root
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Create PHP-FPM runtime directory
mkdir -p /run/php

# Start PHP-FPM
php-fpm7.4 -F