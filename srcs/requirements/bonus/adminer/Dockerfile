# Use Alpine as base image
FROM alpine:3.18

# Install PHP and required extensions
RUN apk add --no-cache php php-pdo_mysql php-mysqli php-session php-json php-iconv php-gd wget

# Create directory and download Adminer
RUN mkdir -p /var/www \
    && wget -O /var/www/adminer.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
    && php -l /var/www/adminer.php

# Add redirect index.php to /adminer.php
RUN echo '<?php header("Location: /adminer.php"); exit; ?>' > /var/www/index.php

# Expose port 8080
EXPOSE 8080

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www"]
