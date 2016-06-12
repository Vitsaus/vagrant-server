# change to root user
sudo su

# update locales
locale-gen fi_FI.utf8
> /etc/default/locale # clears locale
cp /var/www/sites/conf/locale /etc/default/locale

# update timezone
echo "Europe/Helsinki" | tee /etc/timezone

# add repos for latest php, nginx & java
add-apt-repository -y ppa:nginx/stable
add-apt-repository -y ppa:ondrej/php

# base
apt-key update
apt-get update
apt-get install -y git vim curl wget sqlite build-essential python-software-properties

# php & nginx
apt-get install -y nginx php7.0 php7.0-cli php7.0-curl php7.0-gd php7.0-mcrypt php7.0-xdebug php7.0-pgsql php7.0-fpm php7.0-sqlite

# php-fpm config
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php7.0/fpm/php.ini
chown www-data:www-data /var/run/php7.0-fpm.sock
service php5-fpm restart

# composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# default php installation for nginx
rm /etc/nginx/sites-available/default
cp /var/www/sites/conf/default /etc/nginx/sites-available/default
service nginx restart

# postgres
apt-get install -y postgresql postgresql-contrib

# create new user "vagrant" with defined password "vagrant" not a superuser
sudo -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# create new database "vagrant with vagrant as it's owner"
sudo -u postgres psql -c "CREATE DATABASE vagrant;"
sudo -u postgres psql -c "ALTER DATABASE vagrant OWNER TO vagrant;"

service postgresql restart

# install node
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs

# install bower and gulp
npm install -g bower
npm install -g gulp
npm install -g jspm
npm install -g babel
npm install -g knex
npm install -g mocha
npm install -g live-server
npm install -g n
