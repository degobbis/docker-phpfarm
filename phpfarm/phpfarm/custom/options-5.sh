configoptions="$configoptions \
    --with-imap=/usr --with-kerberos --with-imap-ssl \
    --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir --enable-gd-native-ttf \
    --with-mcrypt \
    --with-mysql \
    --with-openssl=/usr \
    --enable-zip \
"

echo "--- loaded custom/options.sh ----------"
echo $configoptions
echo "---------------------------------------"
