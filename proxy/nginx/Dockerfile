FROM debian:stretch-slim

WORKDIR /

# Create nginx user <- Taken from official dockerfile
RUN set -x && \
    addgroup --system --gid 101 nginx && \
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistant --gecos "nginx user" --shell /bin/False --uid 101 nginx

# Install all dependencies
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    gnupg1 apt-transport-https ca-certificates cron python3 python3-pip \
    automake gcc libpcre3 libpcre3-dev zlib1g-dev make wget curl gpg git \
    build-essential libssl-dev libtool autoconf libxml2-dev \
    libcurl4-openssl-dev pkgconf flex bison libyajl-dev libgeoip-dev \
    dh-autoreconf libmaxminddb-dev

# Install OpenSSL 1.1.1
RUN wget -q https://www.openssl.org/source/openssl-1.1.1.tar.gz && \
    tar -zxf openssl-1.1.1.tar.gz && cd openssl-1.1.1 && \
    ./config -Wl,-rpath,'$(LIBRPATH)' && \
    make && make install && rm /usr/bin/openssl && \
    cp /usr/local/bin/openssl /usr/bin/ && openssl version

# Get modsec source
RUN git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity

# Build modsec
RUN cd ModSecurity \
    && git submodule init \
    && git submodule update \
    && ./build.sh \
    && ./configure \
    && make \
    && make install

# Audit logging for modsec
RUN mkdir -p /opt/modsecurity/var/audit/

# Get modsec-nginx
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx

# Purge build in nginx
RUN apt-get purge nginx

# Get nginx source
RUN wget -q http://nginx.org/download/nginx-1.17.3.tar.gz && \
    wget -q http://nginx.org/download/nginx-1.17.3.tar.gz.asc

# Get signing key
RUN curl -sS http://nginx.org/keys/mdounin.key | gpg --import

# Verify signature
RUN gpg --trusted-key 0x520A9993A1C052F8 --verify nginx-1.17.3.tar.gz.asc nginx-1.17.3.tar.gz

# Build and install
RUN tar -zxf nginx-1.17.3.tar.gz && \
    cd nginx-1.17.3 && \
    ./configure --user=nginx --group=nginx \
        --prefix=/etc/nginx \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --without-http_uwsgi_module \
        --with-http_ssl_module \
        --with-openssl=../openssl-1.1.1 \
        --with-openssl-opt="no-async enable-ec_nistp_64_gcc_128 no-shared no-ssl2 no-ssl3 no-comp no-idea no-weak-ssl-ciphers -DOPENSSL_NO_HEARTBEATS -O3 -fPIE -fstack-protector-strong -D_FORTIFY_SOURCE=2" \
        --with-http_v2_module \
        --add-module=/ModSecurity-nginx \
        --without-http_autoindex_module && \
    make

# Install nginx
RUN cd nginx-1.17.3 && make install
    
# Backports repo for newer certbot version
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

# Install certbot
RUN apt-get update && apt-get install -y certbot

# Install certbot-nginx + deps
RUN cd ~ && pip3 install setuptools && pip3 install virtualenv && virtualenv /env && \
    git clone --branch v1.1.0 https://github.com/certbot/certbot && \
    cd certbot/certbot-nginx && python3 setup.py install

# Forece upgrade urllib3 and requests because bugs
RUN pip3 install --upgrade --force-reinstall urllib3 requests

# Set up nice output of nginx to docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Renewal
RUN echo "30 3 * * * certbot renew > /proc/1/fd/1 2>/proc/1/fd/2" | crontab -

# Get OWASP CRS
RUN wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.2.0.tar.gz \
    && tar -xzvf v3.2.0.tar.gz \
    && rm v3.2.0.tar.gz \
    && mv owasp-modsecurity-crs-3.2.0 /usr/local \
    && cd /usr/local/owasp-modsecurity-crs-3.2.0 \
    && cp crs-setup.conf.example crs-setup.conf

RUN cp /ModSecurity/unicode.mapping /etc/nginx/unicode.mapping

# Touch temp
RUN mkdir -p /var/tmp/nginx \
    && mkdir -p /var/log/modsecurity/audit \
    && chown nginx:nginx /var/log/modsecurity/audit

# Get the configs
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./modsecurity.conf /etc/nginx/modsecurity.conf

# Get the entrypoint
COPY entrypoint.sh /entrypoint.sh

# Run service not as daemon
ENTRYPOINT [ "/entrypoint.sh" ]
