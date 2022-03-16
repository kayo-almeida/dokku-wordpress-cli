#!/bin/sh

touch ./process/cron.running

apps=$(echo $(dokku mysql:list) | sed -e 's/=====> MySQL services//g')

echo "checking if mysql is running"
for app in $apps ; do
    mysql_status=$(dokku mysql:info $app --status)
    if [ $mysql_status != "running" ]; then
      echo "🐬 mysql ${app} is offline"
      dokku mysql:restart $app
    fi
done

echo "checking if apache is running"
if service apache2 status | grep -q running; then
    echo "🪶 apache is ok"
else
  echo "🪶 apache is offline"
  sudo service apache2 restart
fi