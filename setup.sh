# change to root user
sudo su

DEBIAN_FRONTEND=noninteractive

# update locales
sudo apt-get install language-pack-fi
locale-gen fi_FI.utf8
> /etc/default/locale # clears locale
cp /var/www/sites/conf/locale /etc/default/locale

# update timezone
echo "Europe/Helsinki" | tee /etc/timezone

# add repos for latest php, nginx, java
add-apt-repository -y ppa:nginx/stable
add-apt-repository -y ppa:ondrej/php

# base
apt-key update
apt-get update
apt-get install -y git vim curl wget sqlite build-essential python-software-properties

# php & nginx
apt-get install -y nginx php7.0 php7.0-cli php7.0-curl php7.0-gd php7.0-mcrypt php7.0-pgsql php7.0-fpm php7.0-sqlite php7.0-pgsql php7.0-zip php7.0-dom php7.0-mbstring php7.0-mysql

# php-fpm config
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php7.0/fpm/php.ini
chown www-data:www-data /var/run/php7.0-fpm.sock
service php5-fpm restart

# composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# install some usefull php stuff
composer global require "phpunit/phpunit=5.5.*"
composer global require "laravel/installer"

# default php installation for nginx
rm /etc/nginx/sites-available/default
cp /var/www/sites/conf/default /etc/nginx/sites-available/default
service nginx restart

# install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# postgres
apt-get install -y postgresql postgresql-contrib

# create new user "vagrant" with defined password "vagrant" not a superuser
sudo -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# create new database "vagrant with vagrant as it's owner"
sudo -u postgres psql -c "CREATE DATABASE vagrant;"
sudo -u postgres psql -c "ALTER DATABASE vagrant OWNER TO vagrant;"

service postgresql restart

# mariadb
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://mirror.jmu.edu/pub/mariadb/repo/10.2/ubuntu xenial main'
apt-get update

debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password PASS'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password PASS'
apt-get install -y mariadb-server
mysql -uroot -pPASS -e "SET PASSWORD = PASSWORD('root');"

# allow remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# drop the anonymous users
mysql -u root -proot -e "DROP USER ''@'localhost';"
mysql -u root -proot -e "DROP USER ''@'$(hostname)';"

# drop the demo database
mysql -u root -proot -e "DROP DATABASE test;"

# install node
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs

# install common node packages globally
npm install -g gulp
npm install -g jspm
npm install -g babel
npm install -g knex
npm install -g mocha
npm install -g live-server
npm install -g n
npm install -g webpack
npm install -g webpack-dev-server
npm install -g typescript
npm install -g typings
