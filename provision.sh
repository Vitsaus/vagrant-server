# add repos for latest php, nginx & redis
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:ondrej/php5
sudo add-apt-repository -y ppa:rwky/redis

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

# nginx config
sudo rm -f /etc/nginx/sites-enabled/default
sudo service nginx restart

# redis
sudo apt-get install -y redis-server

# postgres
sudo apt-get install -y postgresql postgresql-contrib
