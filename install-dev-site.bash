#!/bin/bash

#
# Script para a habilitação do módulo pcntl do php
#

# ---------------------------------------------------------------------------- #
# Verificando se o usuário é root ou tem permissões de                         #
#                                                                              #
# Precisamos disso para as configurações do servidor                           #
# ---------------------------------------------------------------------------- #
if [ "$EUID" -ne 0 ]; then
    echo "Rode com sudo, ou como root"
    exit
fi
# ---------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------- #
# Verificando o número de argumentos no script                                 #
#                                                                              #
# Necessitamos do path para o diretório de projetos e do nome do projeto       #
# ---------------------------------------------------------------------------- #
if [ "$#" -ne '2' ]; then
    cat <<USAGE
Usage: $0 [PATH_TO_PROJECT_DIR] [PROJECT_NAME]
USAGE
    exit
fi
# ---------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------- #
# Verificando se o diretório de projeto se é novo e se tem arquivos dentro     #
#                                                                              #
# Para garantir que não sobreecrevamos nenhum arquivo antigo                   #
# ---------------------------------------------------------------------------- #
PROJECT_PATH="$1/$2"
PROJECT_NAME="$2"

# Se o diretório existe, se não, cria-o com o usuário logado
if [ -d "$PROJECT_PATH" ]; then
    # se há arquivos dentro dele, aborta o script
    if find "$PROJECT_PATH" -maxdepth 0 -empty | read v; then
        echo "Empty dir";
    else
        echo "$PROJECT_PATH is not empty, aborting..."
        exit
    fi
else
    sudo -u $USER mkdir "$PROJECT_PATH"
fi
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# Criando link simbólico para a pasta do projeto, verificando se o mesmo já    #
# existe                                                                       #
#                                                                              #
# Necessitamos para que o servidor web faça seu trabalho de servir as páginas  #
# ---------------------------------------------------------------------------- #
SERVER_ROOT="/var/www"

cd $SERVER_ROOT

if [ ! -e "$PROJECT_PATH" ]; then
    ln -s $PROJECT_PATH
fi
# ---------------------------------------------------------------------------- #

# Path do server
SERVER_ROOT="$SERVER_ROOT/$PROJECT_NAME"

# ---------------------------------------------------------------------------- #
# Criando arquivo de teste no diretório do projeto, com o usuário logado       #
#                                                                              #
# Para verificar se o php pelo menos está processando o arquivo                #
# ---------------------------------------------------------------------------- #
NUMBINDEX="$SERVER_ROOT/index.php"
if [ ! -e "$NUMBINDEX" ]; then
    sudo -u $USER cat <<numbindex > $NUMBINDEX
<html>
    <head>
        <title>$PROJECT_NAME</title>
    </head>
    <body>
        <h1>HELLO FUCKING WORLD!! IMA $PROJECT_NAME ROCKIN IN YA FACE</h1>
        <p>This is my address: <?= $_SERVER['ADDR'] ?></p>
    </body>
</html>
numbindex
fi
# ---------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------- #
# Criando o arquivo de pool para o php-fpm                                     #
#                                                                              #
# Para podermos utilizar outras configurações do php para diferentes projetos  #
# ---------------------------------------------------------------------------- #
PHPFPM_POOL_DIR="/etc/php5/fpm/pool.d/"
POOL_FILE="$PHPFPM_POOL_DIR/$PROJECT_NAME.conf"

if [ ! -e $POOL_FILE ]; then
    cat <<POOL > $POOL_FILE
[$PROJECT_NAME]
user = www-data
group = www-data
listen = /var/run/pool-$PROJECT_NAME.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = $SERVER_ROOT
POOL

service php5-fpm reload
fi
# ---------------------------------------------------------------------------- #


# ---------------------------------------------------------------------------- #
# Criando o arquivo de VHOST do apache2                                        #
#                                                                              #
# Para podermos utilizar um subdomínio com o nome do projeto e ficar mais      #
# fácil a sua manutenção localmente                                            #
# ---------------------------------------------------------------------------- #
APACHE_VHOST_DIR="/etc/apache2/sites-avaliable"
VHOST_FILE="$APACHE_VHOST_DIR/$PROJECT_NAME.conf"

if [ ! -e $VHOST_FILE ];  then
    cat <<VHOST > $VHOST_FILE
<VirtualHost *:80>

    ServerName http://$PROJECT_NAME.localhost:80
    ServerAlias $PROJECT_NAME.localhost

    ServerAdmin reinaldo@websix.com.br
    DocumentRoot $PROJECT_PATH

    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>

    <Directory $PROJECT_PATH>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
        Order allow,deny
        Allow from all
    </Directory>

    # Configuração do PHP-FPM
    <IfModule mod_fastcgi.c>
        AddHandler php5-fcgi .php
        Action php5-fcgi /php5-fcgi
        Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
        FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -flush -socket /var/run/pool-$PROJECT_NAME.sock -pass-header Authorization

        <Directory /usr/lib/cgi-bin>
            Require all granted
        </Directory>
    </IfModule>

    SetEnv APP_ENV "development"

</VirtualHost>
VHOST
fi
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# Criando o arquivo de VHOST do apache2                                        #
#                                                                              #
# Para podermos utilizar um subdomínio com o nome do projeto e ficar mais      #
# fácil a sua manutenção localmente                                            #
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
