printf "## Deploying a MYSQL DATABASE ## \n"
sleep 0.5
printf "Insert the password for your ROOT user: "
read root_password

printf "Do you want to create another user to manage this Database? (y/n)\n"
read response

if [ "$response" == "y" ]; then
  printf "Insert the name for the new USER: "
  read user_name
  printf "Insert the password for this USER: "
  read user_password

  printf "We are creating the database...\n"

  sleep 1.5

  docker_command="docker run --restart=always --name mysql -p 3306:3306 -e MYSQL_USER=$user_name -e MYSQL_PASSWORD=$user_password -e MYSQL_ROOT_PASSWORD=$root_password -d mysql:latest"
else
  docker_command="docker run --restart=always --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$root_password -d mysql:latest"
fi

eval $docker_command

printf "The database has already created successfully.\n"
sleep 1

exit