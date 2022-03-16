#!/bin/sh

# GET VARIABLES
APP_NAME=$1
DEBUG=$2
TABLE_PREFIX=$3
SERVER_IP=$4

# CLONE PROJECT
git clone git@github.com:kayo-almeida/wordpress-dokku.git $APP_NAME
cd $APP_NAME

# SETUP WP CONFIG
cp ./wp-config-sample.php ./wp-config.php
echo "\n\n # TABLE PREFIX" >> wp-config.php
echo "\$table_prefix = '$TABLE_PREFIX';" >> wp-config.php
echo "\n\n # DEBUG MODE" >> wp-config.php
echo "define( 'WP_DEBUG', $DEBUG );" >> wp-config.php
echo "\n\n # AUTHORIZATION KEYS" >> wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
echo "\n\n # THAT'S ALL" >> wp-config.php
echo "require_once ABSPATH . 'wp-settings.php';" >> wp-config.php

# DEPLOY
git init
git add .
git commit -m "feat: deploy $APP_NAME"
git remote add dokku dokku@$SERVER_IP:$APP_NAME
git push dokku main

# RETURN TO PATH
cd ..
