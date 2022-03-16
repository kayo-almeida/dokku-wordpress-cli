#!/bin/bash

# GET VARIABLES
RAW_DOMAIN=$1
DB_NAME=$2
EMAIL=$3

DOMAIN=$(echo $RAW_DOMAIN | sed "s/www.//g" | sed "s/http:\/\///g" | sed "s/https:\/\///g" )
DB_URL=$(dokku mysql:info $DB_NAME --dsn | sed "s/3306/$(dokku mysql:info $DB_NAME --exposed-ports | sed "s/3306->//g")/g" | sed "s/ //g")
DATABASE_ENV_NAME="MYSQL_${DB_NAME^^}_ENV"
AUTHENTICATION_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)

echo '\n✨   CREATING SITE\n'
sudo mkdir /var/www/$DOMAIN
sudo chown -R $USER:$USER /var/www/$DOMAIN

echo '\n✨   CLONING WORDPRESS\n'
cd /var/www/$DOMAIN
git clone git@github.com:WordPress/WordPress.git .

echo '\n✨   FIXING PERMISSIONS\n'
chown www-data:master -R /var/www/$DOMAIN
find /var/www/$DOMAIN -type d -print0 | sudo xargs -0 chmod 0775
find /var/www/$DOMAIN -type f -print0 | sudo xargs -0 chmod 0664

echo '\n✨   SETUP HTACCESS\n'
cp $HOME/dwc/templates/.htaccess .

echo '\n✨   SETUP WP CONFIG\n'
cp $HOME/dwc/templates/wp-config.php .
sed -i "s/__DATABASE_ENV_NAME__/$DATABASE_ENV_NAME/g" wp-config.php
sed -i "s/__AUTHENTICATION_KEYS__/$(echo $AUTHENTICATION_KEYS | sed 's/\//\\\//g')/g" wp-config.php
cd -

echo '\n✨   SETUP APACHE\n'
cp $HOME/dwc/templates/domain.conf /etc/apache2/sites-available/$DOMAIN.conf
cd /etc/apache2/sites-available/
sed -i "s/__SERVERNAME__/$DOMAIN/g" $DOMAIN.conf
sed -i "s/__SERVERNAME__/$DOMAIN/g" $DOMAIN.conf
sed -i "s/__DATABASE_ENV_NAME__/$DATABASE_ENV_NAME/g" $DOMAIN.conf
sed -i "s/__DATABASE_URL__/$(echo $DB_URL | sed 's/\//\\\//g')/g" $DOMAIN.conf
sudo a2ensite $DOMAIN.conf
sudo systemctl restart apache2
cd -


echo '\n✨   SETUP SSL CERTIFICATE\n'
sudo certbot --apache --non-interactive --agree-tos -m $EMAIL -d $DOMAIN -d www.$DOMAIN

echo '\n✅   SITE DONE\n'
