Docker LAMPP
==============

This is an basic setup for a PHP development environment using [Docker and
PHPFarm](https://github.com/eugenesia/docker-phpfarm) based on Debian Jessie with Apache 2.4.10.

This docker images are also used:
- mariadb:10.5
- phpmyadmin/phpmyadmin:latest
- mailhog/mailhog:latest

Usage
-----

After cloning the git repository, You can copy the `default.env` to `.env`, then you can set separate paths for Your websites document root or the database data dir. Also the project name can be set. This is optional. If you don't set the project name, it will default to the folder name of `docker-compose.yml`.


Run `docker-compose up -d`, then browse to `http://localhost:8056/` as example, you should see the phpinfo page running with PHP 5.6.

Port | PHP Version | Binary
-----|-------------|-------
8053 | 5.3.29      | php53
8056 | 5.6.40      | php56
8073 | 7.3.22      | php73
8074 | 7.4.10      | php74

The port `80` is basicly mapped to PHP 7.4.10. You can change this in `.env`.


Loading custom php.ini settings
-------------------------------

All PHP versions are compiled with the config-file-scan-dir pointing to `/YOUR_DOCUMENT_ROOT/.php/`. You can place custom `.ini` files in your the `.php/` directory and they should be automatically be picked up by all PHP versions after a new start.



XDebug debugging
---------------------------------------

XDebug is enabled in all of the PHP versions. It is preconfigured for immeadiate use.

Remote debugging is triggered through the `XDEBUG_SESSION` cookie. You can use the [browser debugging extensions](https://www.jetbrains.com/help/phpstorm/2020.2/browser-debugging-extensions.html?utm_source=product&utm_medium=link&utm_campaign=PS&utm_content=2020.2) to set the correct `KEY` for your `IDE`, also it expects a debugger on port `10000` on the `HOST-IP` that requested the page.

Of course you can always reconfigure xdebug through a custom ini file as described above.


Supported PHP extensions
------------------------

Here's a list of the extensions available in each of the PHP versions available in the Jessie image. It should cover all the default extensions plus a few popular ones and xdebug for debugging.

Extension    | PHP 5.3 | PHP 5.6 | PHP 7.3 | PHP 7.4 |
------------:|:-------:|:-------:|:-------:|:-------:|
bcmath       |    ✓    |    ✓    |    ✓    |    ✓    |
bz2          |    ✓    |    ✓    |    ✓    |    ✓    |
calendar     |    ✓    |    ✓    |    ✓    |    ✓    |
cgi-fcgi     |    ✓    |    ✓    |    ✓    |    ✓    |
ctype        |    ✓    |    ✓    |    ✓    |    ✓    |
curl         |    ✓    |    ✓    |    ✓    |    ✓    |
date         |    ✓    |    ✓    |    ✓    |    ✓    |
dom          |    ✓    |    ✓    |    ✓    |    ✓    |
ereg         |    ✓    |    ✓    |         |         |
exif         |    ✓    |    ✓    |    ✓    |    ✓    |
fileinfo     |    ✓    |    ✓    |    ✓    |    ✓    |
filter       |    ✓    |    ✓    |    ✓    |    ✓    |
ftp          |    ✓    |    ✓    |    ✓    |    ✓    |
gd           |    ✓    |    ✓    |    ✓    |    ✓    |
gettext      |    ✓    |    ✓    |    ✓    |    ✓    |
hash         |    ✓    |    ✓    |    ✓    |    ✓    |
iconv        |    ✓    |    ✓    |    ✓    |    ✓    |
imap         |    ✓    |    ✓    |    ✓    |    ✓    |
intl         |    ✓    |    ✓    |    ✓    |    ✓    |
json         |    ✓    |    ✓    |    ✓    |    ✓    |
ldap         |    ✓    |    ✓    |    ✓    |    ✓    |
libxml       |    ✓    |    ✓    |    ✓    |    ✓    |
mbstring     |    ✓    |    ✓    |    ✓    |    ✓    |
mcrypt       |    ✓    |    ✓    |    ✓    |    ✓    |
mhash        |    ✓    |    ✓    |         |         |
mysql        |    ✓    |    ✓    |         |         |
mysqli       |    ✓    |    ✓    |    ✓    |    ✓    |
mysqlnd      |         |    ✓    |    ✓    |    ✓    |
openssl      |    ✓    |    ✓    |    ✓    |    ✓    |
pcntl        |    ✓    |    ✓    |    ✓    |    ✓    |
pcre         |    ✓    |    ✓    |    ✓    |    ✓    |
pdo          |    ✓    |    ✓    |    ✓    |    ✓    |
pdo_mysql    |    ✓    |    ✓    |    ✓    |    ✓    |
pdo_pgsql    |    ✓    |    ✓    |    ✓    |    ✓    |
pdo_sqlite   |    ✓    |    ✓    |    ✓    |    ✓    |
pgsql        |    ✓    |    ✓    |    ✓    |    ✓    |
phar         |    ✓    |    ✓    |    ✓    |    ✓    |
posix        |    ✓    |    ✓    |    ✓    |    ✓    |
reflection   |    ✓    |    ✓    |    ✓    |    ✓    |
session      |    ✓    |    ✓    |    ✓    |    ✓    |
simplexml    |    ✓    |    ✓    |    ✓    |    ✓    |
soap         |    ✓    |    ✓    |    ✓    |    ✓    |
sockets      |    ✓    |    ✓    |    ✓    |    ✓    |
spl          |    ✓    |    ✓    |    ✓    |    ✓    |
sqlite       |    ✓    |         |         |         |
sqlite3      |    ✓    |    ✓    |    ✓    |    ✓    |
standard     |    ✓    |    ✓    |    ✓    |    ✓    |
tokenizer    |    ✓    |    ✓    |    ✓    |    ✓    |
wddx         |    ✓    |    ✓    |    ✓    |    ✓    |
xdebug       |    ✓    |    ✓    |    ✓    |    ✓    |
xml          |    ✓    |    ✓    |    ✓    |    ✓    |
xmlreader    |    ✓    |    ✓    |    ✓    |    ✓    |
xmlwriter    |    ✓    |    ✓    |    ✓    |    ✓    |
xsl          |    ✓    |    ✓    |    ✓    |    ✓    |
zip          |    ✓    |    ✓    |    ✓    |    ✓    |
zlib         |    ✓    |    ✓    |    ✓    |    ✓    |
