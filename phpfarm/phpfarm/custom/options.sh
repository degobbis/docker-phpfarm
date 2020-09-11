# we need the correct path, is there a better way to find it?
if [ -d "/lib/i386-linux-gnu" ]; then
    LIBPATH="/lib/i386-linux-gnu/"
else
    LIBPATH="/lib/x86_64-linux-gnu/"

    # fix problem with imap http://bit.ly/1WZcTWD
    ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a
fi

configoptions="$configoptions \
    --with-config-file-scan-dir=/var/www/.php \
    --with-bz2 \
    --with-curl \
    --enable-intl \
    --with-ldap --with-libdir=$LIBPATH \
    --with-mhash \
    --enable-mysqlnd
    --with-mysqli=/usr/bin/mysql_config \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-pspell \
    --with-xsl=/usr \
    --with-zlib \
"

echo "--- loaded custom/options.sh ----------"
echo $configoptions
echo "---------------------------------------"
