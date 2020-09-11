#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-jessie:latest

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /

LABEL author="Andreas Gohr <andi@splitbrain.org>, Eugene Sia <eugene@eugenesia.co.uk>"

###
### Upgrade (install ps)
###
RUN set -eux \
	&& rm -f /etc/apt/sources.list \
	&& { \
		echo "deb http://ftp.debian.org/debian jessie main"; \
		echo "#deb http://ftp.debian.org/debian jessie-updates main"; \
		echo "deb http://security.debian.org/debian-security jessie/updates main"; \
	} | tee /etc/apt/sources.list
RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq

ENV \
  # Packages needed for running various build scripts.
  SCRIPT_PKGS=" \
    debian-keyring \
  " \
  # Packages only needed for PHP build.
  BUILD_PKGS=" \
    autoconf \
    autoconf2.13 \
    build-essential \
    lemon \
    m4 \
    pkg-config \
    re2c \
    xz-utils \
    libpcre3-dev \
    libmysqlclient-dev \
    libtool-bin \
    libonig-dev \
    # Fore bz2
    libbz2-dev \
    # For cUrl
    libcurl4-openssl-dev \
    # For GD
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libvpx-dev libwebp-dev \
    # For imagick
    libmagickwand-dev \
    # For imap
    libc-client2007e-dev \
    libkrb5-dev \
    libc-client-dev \
    # For intl
    libicu-dev \
    # For ldap
    libldap2-dev \
    # For mcrypt
    libmcrypt-dev \
    # For mhash
    libmhash-dev \
    # For pgsql / pdo_pgsql
    libpq-dev \
    libsqlite3-dev \
    # For pspell
    libpspell-dev \
    # For tidy
    libtidy-dev \
    # For xsl
    libxslt-dev \
    # For zip
    cmake gnutls-dev libssl([0-9]+(\.[0-9]+)*)?-dev$ libzip-dev libbz2-dev zlib1g-dev \
  " \
  # PHP runtime dependencies.
  RUNTIME_PKGS=" \
    apt-utils \
    # Needed for PHP and Git to connect with SSL sites.
    ca-certificates \
    wget \
    curl \
    git \
    openssl \
    libpcre3 \
    libmysqlclient18 \
    libonig2 \
    # apt-get complains that this is an 'essential' package.
    debian-archive-keyring \
    # For GD
    libfreetype6 libjpeg62-turbo libpng[0-9]+-[0-9]+$ libxpm4 libvpx[0-9]+$ libwebp[0-9]+$ \
    # For imagick
    libmagickwand-6.q16-[0-9]+$ \
    # For imap
    libc-client2007e \
    # For intl
    libicu[0-9]+$ \
    # For mcrypt
    libmcrypt4 \
    # For pgsql / pdo_pgsql
    libpq5 \
    # For pspell
    libaspell15 \
    # For tidy
    libtidy5* \
    # For xsl
    libxslt1.1 \
    # For zip
    libzip[0-9]$ \
  " \
  # Packages needed to run Apache httpd.
  APACHE_PKGS="\
    apache2 \
    apache2-mpm-prefork \
    # Fcgid mod for Apache - not a build dependency library.
    libapache2-mod-fcgid \
  "

# Install packages we need for runtime usage.
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
    # Install packages needed for build.
    $RUNTIME_PKGS \
    $SCRIPT_PKGS \
    $BUILD_PKGS \
    $APACHE_PKGS
#    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq -y --no-install-recommends --no-install-suggests


# -------------------- mhsendmail for sendmail --------------------
COPY mhsendmail /usr/local/bin/mhsendmail
RUN echo '#!/usr/bin/env bash' > /usr/sbin/sendmail \
    && echo "/usr/local/bin/mhsendmail --smtp-addr mailhog:1025" >> /usr/sbin/sendmail \
    && chmod 755 /usr/sbin/sendmail


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

RUN wget -O /tmp/bison-2.6.4.tar.gz http://ftp.gnu.org/gnu/bison/bison-2.6.4.tar.gz \
  && tar -xf /tmp/bison-2.6.4.tar.gz -C /tmp  \
  && cd /tmp/bison-2.6.4 \
  && ./configure --prefix=/usr/local \
  && make \
  && make install


# Download PhpFarm scripts into /phpfarm/.
RUN wget -O /tmp/phpfarm.tar.gz https://github.com/fpoirotte/phpfarm/archive/develop.tar.gz \
  && mkdir -p /phpfarm/inst/bin \
  && tar -xf /tmp/phpfarm.tar.gz -C /phpfarm --strip 1 \
  #
  # Overwrite PhpFarm with our own modifications.
  && rm -rf /phpfarm/src/bzips /phpfarm/src/custom \
#  && find /phpfarm_mod -type f -perm +0111 -exec strip --strip-all '{}' + || true
  && mv /phpfarm_mod/* /phpfarm/src/ \
  #
  # Wait for docker.sh to finish moving else trying to exec a file being
  # written will output "Text file busy" error.
  && sleep 5s \
  && rm -rf /phpfarm_mod

#
# Build all PHP versions.
RUN cd /phpfarm/src \
  && ./docker.sh \
  #
  # Clean up.
  && cd / \
  && rm -rf /phpfarm/src \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y $SCRIPT_PKGS $BUILD_PKGS \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && (rm -rf /tmp/.* || true)


# expose the ports
EXPOSE 8053 8056 8073 8074

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]

