FROM debian:stretch-slim

# Create nginx user <- Taken from official dockerfile
RUN set -x && \
    addgroup --system --gid 101 nginx && \
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistant --gecos "nginx user" --shell /bin/False --uid 101 nginx

# Install all dependencies
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    gnupg1 apt-transport-https ca-certificates cron \
    automake gcc libpcre3-dev zlib1g-dev make wget curl gpg

# Get source
RUN wget -q http://nginx.org/download/nginx-1.17.1.tar.gz && \
    wget -q http://nginx.org/download/nginx-1.17.1.tar.gz.asc

# Get signing key
RUN curl -sS http://nginx.org/keys/mdounin.key | gpg --import

# Verify signature
RUN gpg --trusted-key 0x520A9993A1C052F8 --verify nginx-1.17.1.tar.gz.asc nginx-1.17.1.tar.gz

# Build and install
RUN tar -zxf nginx-1.17.1.tar.gz && \
    cd nginx-1.17.1 && \
    ./configure --user=nginx --group=nginx \
        --without-http_uwsgi_module \
        --without-http_autoindex_module && \
    make && make install
    
# Backports repo for newer certbot version
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

# Install certbot
RUN apt-get update && apt-get install -y certbot python-certbot-nginx python3-pip

# Fix broken urllib3
RUN pip3 install --upgrade --force-reinstall urllib3 requests

# Set up nice output of nginx to docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Renewal
RUN echo "30 3 * * * certbot renew" | crontab -

COPY ./nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /entrypoint.sh

# Run service not as daemon
ENTRYPOINT [ "/entrypoint.sh" ]
