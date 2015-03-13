#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Rode com sudo, ou como root"
  exit
fi

echo "Updating the repos"
apt-get update > /dev/null

echo "Upgrading what it have to do so"
apt-get upgrade -y > /dev/null

echo "Installing required packages"
apt-get install -y php-pear ocaml > /dev/null

echo "Installing PHP Code Sniffer"
pear install PHP_CodeSniffer

echo "Installing PHP Depend"
pear channel-discover pear.pdepend.org
pear install pdepend/PHP_Depend

echo "Installing PHP Mess Detector"
curl http://static.phpmd.org/php/2.2.1/phpmd.phar -o "/usr/bin/phpmd"
chmod +x "/usr/bin/phpmd"

echo "Installing PHPcs Fixer"
curl "http://get.sensiolabs.org/php-cs-fixer.phar" -o "/usr/local/bin/php-cs-fixer"
chmod a+x "/usr/local/bin/php-cs-fixer"

echo "Installing facebook pfff"
cd /opt/
git clone --depth 1 https://github.com/facebook/pfff.git

cd /opt/pfff

echo "Configuring pfff"
./configure > /dev/null

echo "Making depend"
make depend > /dev/null

echo "Making generic"
make > /dev/null

echo "Making opt"
make opt > /dev/null

echo "Done."
