#!/bin/sh

# GET VARIABLES
APP_NAME=$1

# DESTROYING DOKKU APP
dokku domains:clear $APP_NAME
dokku mysql:unlink $APP_NAME $APP_NAME
dokku apps:destroy --force $APP_NAME
dokku mysql:destroy --force $APP_NAME

# DELETING STORAGE
sudo rm -r /var/lib/dokku/data/storage/$APP_NAME/plugins
sudo rm -r /var/lib/dokku/data/storage/$APP_NAME/themes
sudo rm -r /var/lib/dokku/data/storage/$APP_NAME/uploads

# REMOVE CLONED WORDPRESS
sudo rm -r $APP_NAME                          

