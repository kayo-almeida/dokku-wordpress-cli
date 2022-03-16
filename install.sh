#!/bin/sh

sudo apt update

echo "💻  installing Make"
which brew
if [[ $? != 0 ]] ; then
    echo "🐧 linux system detected"
    sudo apt-get -y install make
else
    echo "🍎 mac system detected"
fi

which zip
if [[ $? != 0 ]] ; then
    echo "📦 installing zip"
    sudo apt-get -y install zip
else
    echo "📦 zip already installed"
fi

which dokku
if [[ $? != 0 ]] ; then
    echo "🐳 installing Dokku"
    wget https://raw.githubusercontent.com/dokku/dokku/v0.27.0/bootstrap.sh
    sudo DOKKU_TAG=v0.27.0 bash bootstrap.sh
    sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql
    sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    cat $HOME/.ssh/id_rsa.pub | sudo dokku ssh-keys:add server
else
    echo "🐳 dokku already installed"
fi

which apache2
if [[ $? != 0 ]] ; then
    echo "🪶 installing apache"
    sudo apt install -y apache2
    sudo ufw allow 'Apache Full'
    sudo ufw status
    sudo systemctl status apache2
    sudo a2enmod rewrite
else
    echo "🪶 apache already installed"
fi

which php
if [[ $? != 0 ]] ; then
    echo "🐘 installing php"
    sudo apt install -y php libapache2-mod-php php-mysql
    sudo systemctl restart apache2
else
    echo "🐘 php already installed"
fi

which certbot
if [[ $? != 0 ]] ; then
    echo "🔒 installing certbot"
    sudo apt install -y certbot python3-certbot-apache
    sudo systemctl status certbot.timer
else
    echo "🔒  certbot already installed"
fi

which aws
if [[ $? != 0 ]] ; then
    echo "☁️ installing aws client"
    sudo apt-get -y install awscli
else
    echo "☁️  aws already installed"
fi

echo "🗑  deleting old versions"
sudo rm -rf $HOME/dwc

echo "📦  building new version"
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

echo "🧹 cleaning up the mess"
sudo rm -rf bootstrap.sh

sudo service nginx stop
sudo service apache2 start

echo "🍺 thank you!!"