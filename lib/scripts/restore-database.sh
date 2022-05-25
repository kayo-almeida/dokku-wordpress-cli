#!/bin/bash

# GET VARIABLES
BACKUP_PATH=$1


for file in $BACKUP_PATH; do
  filename=$(basename $file)
  db_name=$(cat /etc/apache2/sites-available/$(echo $filename | sed 's/.sql//g').conf | grep MYSQL_ | grep -oE "[^/]+$")

  dokku mysql:destroy $db_name -f
  dokku mysql:create $db_name --config-options "--default-authentication-plugin=mysql_native_password"
  dokku mysql:expose $db_name
  dokku mysql:import $db_name < $file

  # fixing apache config
  db_url=$(dokku mysql:info cemiterioaraca --dsn | sed "s/3306/$(dokku mysql:info cemiterioaraca --exposed-ports | sed "s/3306->//g")/g" | sed "s/ //g")
  sed -i "s/SetEnv MYSQL_URL.*/SetEnv MYSQL_URL $(echo $db_url)/g" $(echo $filename | sed 's/.sql//g').conf
  sed -i "s/SetEnv MYSQL_URL.*/SetEnv MYSQL_URL $(echo $db_url)/g" $(echo $filename | sed 's/.sql//g')-le-ssl.conf

  echo "\n✨ $filename done\n"
done

