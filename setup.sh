# add repos for latest php, nginx & java
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo add-apt-repository -y ppa:webupd8team/java

# base
sudo apt-key update
sudo apt-get update
sudo apt-get install -y git vim curl wget sqlite build-essential python-software-properties

# nginx
sudo apt-get install -y nginx

# php
sudo apt-get install --force-yes -y php5 php5-cli php5-curl php5-gd php5-mcrypt php5-xdebug php5-pgsql php5-fpm php5-redis php5-sqlite phpunit

# php-fpm config
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sudo chown www-data:www-data /var/run/php5-fpm.sock
sudo service php5-fpm restart

# composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# postgres
sudo apt-get install -y postgresql postgresql-contrib

sudo service nginx restart

# create new user "vagrant" with defined password "vagrant" not a superuser
sudo -u postgres psql -c "CREATE ROLE vagrant LOGIN UNENCRYPTED PASSWORD 'vagrant' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# create new database "vagrant with vagrant as it's owner"
sudo -u postgres psql -c "CREATE DATABASE vagrant;"
sudo -u postgres psql -c "ALTER DATABASE vagrant OWNER TO vagrant;"

sudo service postgresql restart

# elasticsearch
sudo echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb
sudo dpkg -i elasticsearch-1.5.0.deb
sudo /etc/init.d/elasticsearch start
