#!/bin/bash

RESULT=$(
  printf "["
  for d in /var/www/*/ ; do
    SITE=$(echo $d | sed 's/\///g' | sed 's/varwww//g') 
    DATABASE=$(cat /etc/apache2/sites-available/${SITE}.conf | grep MYSQL_ | grep -oE "[^ ]+$")
    STATUS=unknow
    URLS=$(cat /etc/apache2/sites-available/${SITE}.conf | grep -E 'ServerName|ServerAlias' | sed 's/ //g' | sed 's/\t//g' | sed 's/\n//g'  | sed 's/ServerName/https:\/\//g' | sed 's/ServerAlias/https:\/\//g')

    for URL in ${URLS}; do
      STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${URL})
      CHECKED_URL=$URL
      if [ "$STATUS" = "200" ]; then
        break 
      fi
    done


    printf "{"
      printf "\"domain\": \"${SITE}\","
      printf "\"status\": \"${STATUS}\","
      printf "\"database\": \"${DATABASE}\","
      printf "\"url\": \"${CHECKED_URL}\","
    printf "},"
  done
  printf "]"
)

echo $RESULT | sed 's/,}/}/g' | sed 's/,]/]/g'