FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*


# Generate SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=MA/ST=Marrakech-Safi/L=BenGuerir/O=Student/OU=IT/CN=mzeouaou.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy static HTML files to nginx web root
COPY html/ /usr/share/nginx/html/

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]