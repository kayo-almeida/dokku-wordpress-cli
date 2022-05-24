#!/bin/bash
for d in /var/www/*/ ; do
  chown www-data:master -R /var/www/$d
  find /var/www/$d -type d -print0 | sudo xargs -0 chmod 0775
  find /var/www/$d -type f -print0 | sudo xargs -0 chmod 0664  
done
