#!/bin/bash

RESULT=$(
  printf "["
  for d in /var/www/*/ ; do
    SITE=$(echo $d | sed 's/\///g' | sed 's/varwww//g') 
    DATABASE=$(cat /etc/apache2/sites-available/${SITE}.conf | grep MYSQL_URL | grep -oE "[^/]+$")
    STATUS=unknow
    URLS=$(cat /etc/apache2/sites-available/${SITE}.conf | grep -E 'ServerName|ServerAlias' | sed 's/ //g' | sed 's/\t//g' | sed 's/\n//g'  | sed 's/ServerName/https:\/\//g' | sed 's/ServerAlias/https:\/\//g')

    for URL in ${URLS}; do
      STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL})
      if [ "$STATUS" = "200" ]; then
        break 
      fi
    done


    printf "{"
      printf "\"domain\": \"${SITE}\","
      printf "\"status\": \"${STATUS}\","
      printf "\"database\": \"${DATABASE}\","
    printf "},"
  done
  printf "]"
)

echo $RESULT | sed 's/,}/}/g' | sed 's/,]/]/g'