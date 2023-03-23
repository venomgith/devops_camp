#!/bin/bash

sudo apt-get update
sudo apt install apache2 php-mysql libapache2-mod-php -y
sudo systemctl enable --now apache2

sudo echo "<h1>My web-site on apache2<h1>" > /var/www/html/index.html

sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
sudo service apache2 restart

SQL ON GCP IS EMPTY