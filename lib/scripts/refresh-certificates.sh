#!/bin/bash
EMAIL=$1

# DELETING ALL CERTIFICATES
sudo rm -r /etc/apache2/sites-available/*-le-ssl-.config
for n in $(certbot certificates | grep "Certificate Name: " | sed "s/Certificate Name: //g"); do
 sudo certbot delete --cert-name $n
done

# CREATE NEW CERTIFICATES
for file in /etc/apache2/sites-available/*; do
  sudo certbot --apache --non-interactive --agree-tos -m $EMAIL $(cat $file | grep ServerName | sed 's/ServerName/-d/g')  $(cat $file | grep ServerAlias | sed 's/ServerAlias/-d/g') 
done
