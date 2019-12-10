#!/bin/bash

# EXAMPLE
#docker network create wordpress
# docker run --name mysql --network wordpress -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_DATABASE=db_test -e MYSQL_USER=no_root -e MYSQL_PASSWORD=4321 --restart always mariadb
# docker run --name wordpress --network wordpress -p 8080:80 -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DB_USER=no_root -e WORDPRESS_DB_PASSWORD=4321 -e WORDPRESS_DB_NAME=db_test -d --restart always wordpress

#SCRIPT PARA LEVANTAR UN WORDPRESS CON DOCKER
echo "## ENV VARS ##"

# .-Las funciones de shell no suelen tener valor Return
    # -Si se quiere tener un valor de return es necesario pintarlo con un echo
# .-La concatenacion de strings se hace con comillas dobles
# .-Las invocaciones de las funciones se hacen sin los parentesis
    # -Si se le quiere pasar mas valores o args a la funciones, se hacen con un espacio de separacion

function input() {
    read -p "$1" name

    if [ -z "$name" ]; then
        name="$(whoami)_$2"
    fi
    echo $name
}
# Invocacion de la funcion con arg
# nombre=$(read_params "Introduzca su nombre: " "root")

### MAIN

# MYSQL ENV VARS
MYSQL_DATABASE=$(input "Set the name for your DATABASE [default: ${USER}_wordpressDB]: " "wordpressDB")
MYSQL_ROOT_PASS=$(input "Set the PASSWORD for your Database [default: ${USER}_1234]: " "1234")
MYSQL_USER=$(input "set the name of the USER you want to use in the DATABASE and WORDPRESS [default: ${USER}_wp]: " "wp")

# WORDPRESS ENV VARS
WP_DB_PASS=$(input "Set the password for your User to get access to your Database [default: ${USER}_wp_1234]: " "wp_1234")

# DOCKER VARS
wordpress="wordpress"
mysql="mariadb"
network_name="wordpress"
local_port=8080

printf "\n\t## SETTINGS / ENV VARS ##"
printf "\n\t=== DATABASE ==="
printf "\n\tDATABASE NAME: ${MYSQL_DATABASE}"
printf "\n\tDATABASE ROOT PASS: ${MYSQL_ROOT_PASS}"
printf "\n\tDATABASE USER: ${MYSQL_USER}"

printf "\n\n\t=== WORDPRESS ==="
printf "\n\tDATABASE NAME WP: ${MYSQL_DATABASE}"
printf "\n\tDATABASE USER WP: ${MYSQL_USER}"
printf "\n\tDATABASE PASS WP: ${WP_DB_PASS}"

printf "\n\n\t=== DOCKER ==="
printf "\n\tImage name and version (wordpress): ${wordpress}:latest"
printf "\n\tImage name and version (database): ${mysql}:latest"

printf "\n\n"
read -p "Are you sure to set all this settings?(y/n)" option

while [ -z "$option" ]
do
    read -p "You must select an option.(y/n): " option
done


if [ $option = "y" ]; then
    docker network create ${network_name}

    docker run --name mysql --network ${network_name} -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS} -e MYSQL_DATABASE=${MYSQL_DATABASE} -e MYSQL_USER=${MYSQL_USER} -e MYSQL_PASSWORD=${WP_DB_PASS} --restart always ${mysql}

    docker run --name ${wordpress} --network ${network_name} -p ${local_port}:80 -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DB_USER=${MYSQL_USER} -e WORDPRESS_DB_PASSWORD=${WP_DB_PASS} -e WORDPRESS_DB_NAME=${MYSQL_DATABASE} -d --restart always ${wordpress}

    printf "\n All good, to get more information about your containers type: docker ps"
    printf "\n Now you can config your wordpress in the ${local_port} port"
    sleep 3
    printf "\n Bye\n"
    sleep 1
elif [ $option = "n"  ]; then
    echo "Byeeee"
    exit
fi

#Delete all this containers and networks
# docker stop wordpress mysql && docker rm -f wordpress mysql && docker network rm wordpress
