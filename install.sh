#!/bin/sh

sudo apt update

echo "ðŧ  installing Make"
which brew
if [[ $? != 0 ]] ; then
    echo "ð§ linux system detected"
    sudo apt-get -y install make
else
    echo "ð mac system detected"
fi

which zip
if [[ $? != 0 ]] ; then
    echo "ðĶ installing zip"
    sudo apt-get -y install zip
else
    echo "ðĶ zip already installed"
fi

which dokku
if [[ $? != 0 ]] ; then
    echo "ðģ installing Dokku"
    wget https://raw.githubusercontent.com/dokku/dokku/v0.27.0/bootstrap.sh
    sudo DOKKU_TAG=v0.27.0 bash bootstrap.sh
    sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql
    sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    cat $HOME/.ssh/id_rsa.pub | sudo dokku ssh-keys:add server
else
    echo "ðģ dokku already installed"
fi

which apache2
if [[ $? != 0 ]] ; then
    echo "ðŠķ installing apache"
    sudo apt install -y apache2
    sudo ufw allow 'Apache Full'
    sudo ufw status
    sudo systemctl status apache2
    sudo a2enmod rewrite
else
    echo "ðŠķ apache already installed"
fi

which php
if [[ $? != 0 ]] ; then
    echo "ð installing php"
    sudo apt install -y php libapache2-mod-php php-mysql
    sudo systemctl restart apache2
else
    echo "ð php already installed"
fi

which certbot
if [[ $? != 0 ]] ; then
    echo "ð installing certbot"
    sudo apt install -y certbot python3-certbot-apache
    sudo systemctl status certbot.timer
else
    echo "ð  certbot already installed"
fi

which aws
if [[ $? != 0 ]] ; then
    echo "âïļ installing aws client"
    sudo apt-get -y install awscli
else
    echo "âïļ  aws already installed"
fi

echo "ð  deleting old versions"
sudo rm -rf $HOME/dwc

echo "ðĶ  building new version"
git pull origin main
sudo rm -rf $HOME/dwc
sudo cp -a ./lib $HOME/dwc

if grep -rnw $HOME/.bashrc -e 'dwc'
then 
   echo "alias command already set"
else
    sudo echo "alias dwc='make -C $HOME/dwc'" >> $HOME/.bashrc
fi

if [ $(getent group master) ]; then
  echo "group master already exists"
else
  echo "creating master group"
  sudo addgroup master
  sudo adduser www-data master
fi

source $HOME/.bashrc

echo "ð§đ cleaning up the mess"
sudo rm -rf bootstrap.sh

sudo service nginx stop
sudo service apache2 start

echo "ðš thank you!!"