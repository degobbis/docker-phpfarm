#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-jessie:latest

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR "/root"

LABEL author="Andreas Gohr <andi@splitbrain.org>, Eugene Sia <eugene@eugenesia.co.uk>"

ENV \
  # Packages needed for running various build scripts.
  SCRIPT_PKGS=" \
    debian-keyring \
    wget \
  " \
  # Packages only needed for PHP build.
  BUILD_PKGS=" \
    apt-utils \
    autoconf \
    build-essential \
    lemon \
    bison \
    pkg-config \
    re2c \
  " \
  # PHP runtime dependencies.
  RUNTIME_PKGS=" \
    # Needed for PHP and Git to connect with SSL sites.
    ca-certificates \
    curl \
    git \
    # apt-get complains that this is an 'essential' package.
    debian-archive-keyring \
    imagemagick \
    libbz2-dev \
    libc-client2007e-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmhash-dev \
    libmysqlclient-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssl-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
  " \
  # Packages needed to run Apache httpd.
  APACHE_PKGS="\
    apache2 \
    apache2-mpm-prefork \
    # Fcgid mod for Apache - not a build dependency library.
    libapache2-mod-fcgid \
  "

# Install packages we need for runtime usage.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    $RUNTIME_PKGS \
    $APACHE_PKGS \
    # Install packages needed for build.
    $SCRIPT_PKGS \
    $BUILD_PKGS && \
    apt-get upgrade -y

# Configure sendmail to use mailhog
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail \
    && mv /root/go/bin/mhsendmail /usr/bin/mhsendmail \
    && echo '#!/usr/bin/env bash' > /usr/sbin/sendmail \
    && echo "/usr/bin/mhsendmail --smtp-addr mailhog:1025" >> /usr/sbin/sendmail \
    && chmod 755 /usr/sbin/sendmail \
    && rm -rf /root/go


# Reconfigure Apache
RUN rm -rf /var/www/*
# Import our Apache configs.
COPY apache /etc/apache2/


# Import our own modifications for the PhpFarm script.
COPY phpfarm /phpfarm_mod

# The PHP versions to compile.
ENV PHP_FARM_VERSIONS="5.3.29 5.6.40 7.3.22 7.4.10" \
  \
  # Flags for C Compiler Loader: make php 5.3 work again.
  LDFLAGS="-lssl -lcrypto -lstdc++" \
  \
  # Add path to built PHP executables, for module building and for Apache.
  PATH="/phpfarm/inst/bin/:$PATH"


# Download PhpFarm scripts into /phpfarm/.
RUN wget -O /phpfarm.tar.gz https://github.com/fpoirotte/phpfarm/archive/develop.tar.gz && \
  mkdir /phpfarm && \
  tar -xf /phpfarm.tar.gz -C /phpfarm --strip 1 && \
  #
  # Overwrite PhpFarm with our own modifications.
  rm -rf /phpfarm/src/bzips /phpfarm/src/custom && \
  mv /phpfarm_mod/* /phpfarm/src/ && \
  #
  # Wait for docker.sh to finish moving else trying to exec a file being
  # written will output "Text file busy" error.
  sleep 5s && \
  rmdir /phpfarm_mod && \
  #
  # Build all PHP versions.
  cd /phpfarm/src && \
  ./docker.sh && \
  #
  # Clean up.
  apt-get purge -y $SCRIPT_PKGS $BUILD_PKGS && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*


# expose the ports
EXPOSE 8053 8056 8073 8074

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]

