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
add-apt-repository -y ppa:ondrej/php5-5.6
add-apt-repository -y ppa:webupd8team/java

# base
apt-key update
apt-get update
apt-get install -y git vim curl wget sqlite build-essential python-software-properties

# php & nginx
apt-get install -y nginx php5 php5-cli php5-curl php5-gd php5-mcrypt php5-xdebug php5-pgsql php5-fpm php5-sqlite

# php-fpm config
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
chown www-data:www-data /var/run/php5-fpm.sock
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

# elasticsearch
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java8-installer
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb
dpkg -i elasticsearch-1.5.0.deb
/etc/init.d/elasticsearch start

# install node
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get install -y nodejs

# install bower and gulp
npm install -g bower
npm install -g gulp
