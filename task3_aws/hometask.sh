#!/bin/bash

sudo apt update
sudo apt-get install apache2 mysql-client mysql-server php libapache2-mod-php -y
sudo apt-get install graphviz aspell ghostscript clamav php-pspell php-curl php-gd php-intl php-mysql php-xml php-xmlrpc php-ldap php-zip php-soap php-mbstring -y
sudo service apache2 restart
sudo apt-get install git
cd /opt
sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch --track MOODLE_401_STABLE origin/MOODLE_401_STABLE
sudo git checkout MOODLE_401_STABLE
sudo cp -R /opt/moodle /var/www/html/
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 777 /var/moodledata
sudo chmod -R 0755 /var/www/html/moodle

sudo mysql -u root -proot << EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create user 'moodledude'@'localhost' IDENTIFIED BY 'passwordformoodledude';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO moodledude@localhost;
exit
EOF

#php_version=`php --ini | grep Loaded | cut -d'/' -f4`
#sudo chmod 777 /etc/php/$php_version/apache2/php.ini
#sudo sed -i "426 s#;max_input_vars = 1000#max_input_vars = 5000#1" /etc/php/$php_version/apache2/php.ini
#sudo service apache2 restart

sudo sed -i "s#var/www/html#var/www/html/moodle#" /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

sudo cp /var/www/html/moodle/config-dist.php /var/www/html/moodle/config.php
cd /var/www/html/moodle
sudo sed -i "s/pgsql/mysqli/1" config.php
sudo sed -i "s/username/moodledude/1" config.php
sudo sed -i "s/password/passwordformoodledude/1" config.php

public_ip=`wget -qO- https://ipecho.net/plain ; echo`
sudo sed -i "136 s#example.com/moodle#$public_ip#1" config.php
sudo sed -i "152 s#home/example#var#1" config.php
sudo service apache2 stop
sudo service apache2 start