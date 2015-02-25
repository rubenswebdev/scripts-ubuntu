#!/bin/bash

sudo groupadd www-pub
sudo usermod -a -G www-pub root
sudo usermod -a -G www-pub $USER
sudo usermod -a -G www-pub www-data
sudo chown -R $USER:www-pub /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} +
sudo find /var/www -type f -exec chmod 0664 {} +
echo "umask 0002" | sudo tee -a /etc/profile
clear
echo "Configuração concluida..."
echo "Reinicie a máquina para as alterações terem efeito "
