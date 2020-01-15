#!/bin/bash

# This script will
# -Create a volume to store your data between HOST and container
# -Download the latest version of Mysql
# -Add users and credentials

printf "## We are going to create a Mysql Database (container) ## \n"
sleep 0.5
read -p "Insert the name of the volume: " volume_name
read -p "Insert the password for your ROOT user: " root_password

printf "Do you want to create another user to manage this Database? (y/n)\n"
read response

if [ "$response" == "y" ]; then
  read -p "Insert the name for the new USER: " user_name
  read -p "Insert the password for this USER: " user_password

  printf "We are creating the database...\n"

  sleep 1.5
  docker volume create $volume_name
  docker_command="docker run --restart=always --name mysql -p 3306:3306 -e MYSQL_USER=$user_name -e MYSQL_PASSWORD=$user_password -e MYSQL_ROOT_PASSWORD=$root_password -v $volume_name:/usr/lib/mysql -d mysql:latest"
else
  docker_command="docker run --restart=always --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$root_password -v $volume_name:/usr/lib/mysql -d mysql:latest"
fi
docker volume create $volume_name
eval $docker_command

sleep 0.5
printf "The database has already created successfully.\n"
sleep 0.5

exit