#!/bin/sh

# GET VARIABLES
APP_NAME=$1
APP_DOMAIN=$2
LETSENCRYPT_EMAIL=$3

# CREATING DOKKU APP
dokku apps:create $APP_NAME
dokku mysql:create $APP_NAME
dokku mysql:link $APP_NAME $APP_NAME
dokky domains:set $APP_NAME $APP_DOMAIN

# CREATING STORAGE
# Create the folders
sudo mkdir -p /var/lib/dokku/data/storage/$APP_NAME/plugins
sudo mkdir -p /var/lib/dokku/data/storage/$APP_NAME/themes
sudo mkdir -p /var/lib/dokku/data/storage/$APP_NAME/uploads

# Change the permission
sudo chown 32767:32767 /var/lib/dokku/data/storage/$APP_NAME/plugins
sudo chown 32767:32767 /var/lib/dokku/data/storage/$APP_NAME/themes
sudo chown 32767:32767 /var/lib/dokku/data/storage/$APP_NAME/uploads

# Mount the storage to the container
dokku storage:mount $APP_NAME /var/lib/dokku/data/storage/$APP_NAME/plugins:/app/wp-content/plugins
dokku storage:mount $APP_NAME /var/lib/dokku/data/storage/$APP_NAME/themes:/app/wp-content/themes
dokku storage:mount $APP_NAME /var/lib/dokku/data/storage/$APP_NAME/uploads:/app/wp-content/uploads

# ADDING HTTPS CERTIFICATION
# Set the global email
dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL

# Setup cronjob to auto-renew certificates when they expire
dokku letsencrypt:cron-job --add

# Add https to site
dokku letsencrypt:enable $APP_NAME

# RESTART APP TO APPLY SETTINGS
dokku ps:restart $APP_NAME
