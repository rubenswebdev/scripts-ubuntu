#!/bin/bash

#
# Script para a habilitação do módulo pcntl do php
#

#execute automatic with sudo
sudo -v 

if [ "$EUID" -ne 0 ]
  then echo "Rode com sudo, ou como root"
  exit
fi

TMP=/tmp/phpsource
PHP_MODULE_INI=/etc/php5/mods-available/pcntl.ini

echo "Creating temp dirs"

if [ ! -d $TMP ]; then
    mkdir $TMP
fi

cd $TMP

if [ ! -d $TMP/php5* ]; then
    echo "Getting the php source"
    apt-get source php5
else
   echo "Already has the source"
fi

cd $TMP/php5-*/ext/pcntl

echo "Phpizing..."
phpize

echo "Configuring..."
./configure

echo "Making..."
make

echo "Installing module"

if [ ! -e $PHP_MODULE_BIN ]; then
    cd modules
    cp pcntl.so /usr/lib/php5/20131106/pcntl.so
else
    echo "Already has compiled lib"
fi

if [ ! -e $PHP_MODULE_INI ]; then
    echo "extension=pcntl.so" > $PHP_MODULE_INI
else
    echo "Already has $PHP_MODULE_INI"
fi

echo "Enabling module"
php5enmod pcntl

echo "Restart fpm"

# CHANGE THIS IF USING mod_php
service php5-fpm restart

echo "Cleaning..."
rm -Rf $TMP
