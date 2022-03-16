#!/bin/bash

# GET VARIABLES
DB_NAME=$1

echo '\n✨   CREATING DATABASE\n'
dokku mysql:create $DB_NAME --config-options "--default-authentication-plugin=mysql_native_password"
dokku mysql:expose $DB_NAME
echo '\n✅   DATABASE DONE\n'