#!/bin/bash

# GET VARIABLES
RAW_DOMAIN=$1

DOMAIN=$(echo $RAW_DOMAIN | sed "s/www.//g" | sed "s/http:\/\///g" | sed "s/https:\/\///g" )

touch ./process/$RAW_DOMAIN.running
echo '\n✨   PREPARING BACKUP\n'
mkdir -p $HOME/backup
cd $HOME/backup
rm -rf $DOMAIN
mkdir $DOMAIN
cd $DOMAIN
mkdir site vhost database

echo '\n✨   BACKUPING APP\n'
cp -r /var/www/$DOMAIN/* $HOME/backup/$DOMAIN/site

echo '\n✨   BACKUPING VHOST\n'
cp /etc/apache2/sites-available/$DOMAIN.conf $HOME/backup/$DOMAIN/vhost/$DOMAIN.conf

echo '\n✨   BACKUPING DATABASE\n'
cd $HOME/backup/$DOMAIN/database 
dokku mysql:export $(cat /etc/apache2/sites-available/$DOMAIN.conf | grep MYSQL_URL | grep -oE "[^/]+$") > backup.sql

echo '\n✨   ZIPPING BACKUP\n'
cd $HOME/backup
zip -r $DOMAIN.zip $DOMAIN
rm -rf $DOMAIN

echo '\n✅   BACKUP DONE\n'