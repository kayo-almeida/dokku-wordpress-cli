#!/bin/bash

EMAIL=$1

# DELETING ALL CERTIFICATES
for n in $(certbot certificates | grep "Certificate Name: " | sed "s/Certificate Name: //g"); do
 sudo certbot delete --cert-name $n
done

# CREATE NEW CERTIFICATES
for conf in /etc/apache2/sites-available/*/ ; do
  sudo certbot --apache --non-interactive --agree-tos -m $EMAIL $(cat $conf | grep ServerName | sed 's/ServerName/-d/g')  $(cat $conf | grep ServerAlias | sed 's/ServerAlias/-d/g') 
done
