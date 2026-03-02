#!/bin/sh

# Create socket directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check if database needs initialization
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start temporary server
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
MYSQL_PID=$!

# Wait for MySQL to start
echo "Waiting for MySQL to start..."
for i in $(seq 1 30); do
    if [ -S /run/mysqld/mysqld.sock ]; then
        if mysqladmin --socket=/run/mysqld/mysqld.sock ping 2>/dev/null; then
            echo "MySQL is ready!"
            break
        fi
    fi
    sleep 1
done

# Configure database if not already done
if [ ! -f /var/lib/mysql/.init_done ]; then
    echo "Configuring database..."
    mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    touch /var/lib/mysql/.init_done
    echo "Database configured."
else
    echo "Database already configured."
fi

# Stop temporary server
echo "Stopping temporary server..."
mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown 2>/dev/null || kill $MYSQL_PID 2>/dev/null
wait $MYSQL_PID 2>/dev/null

# Start final server
echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql