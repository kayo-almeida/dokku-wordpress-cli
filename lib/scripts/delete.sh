#!/bin/bash

# GET VARIABLES
DOMAIN=$1

echo '\n✨   DELETING DATABASE\n'
dokku mysql:destroy $(cat /etc/apache2/sites-available/$DOMAIN.conf | grep MYSQL_ | grep -oE "[^/]+$") -f

echo '\n✨   DELETING SITE\n'
sudo rm -rf /var/www/$DOMAIN

echo '\n✨   DELETING SSL CERTIFICATE\n'
sudo certbot delete --cert-name $DOMAIN

echo '\n✨   SETUP APACHE\n'
sudo a2dissite $DOMAIN.conf
sudo rm -rf /etc/apache2/sites-available/$DOMAIN*
sudo systemctl restart apache2

echo '\n✅   SITE DELETED\n'
