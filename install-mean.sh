#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install unzip
sudo apt-get install apache2
sudo apt-get install libapache2-mod-proxy-html libxml2-dev
sudo a2enmod proxy proxy_http proxy_ajp rewrite deflate headers proxy_balancer proxy_connect proxy_html
sudo apt-get install curl
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo npm install grunt-cli -g
git clone https://github.com/rubensfernandes/vhost-manager.git
cd vhost-manager
sudo chmod +x vhost.bash
sudo ./vhost.bash -install
sudo apt-add-repository ppa:fish-shell/release-2
sudo apt-get update
sudo apt-get install fish
chsh -s /usr/bin/fish
sudo apt-get install mercurial
