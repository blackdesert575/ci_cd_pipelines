#!/bin/bash

# MySQL credentials
DB_USER="your_username"
DB_PASSWORD="your_password"
DB_HOST="localhost"
DB_NAME="your_database"

# Retrieve table names
TABLES=$(mysql -u"$DB_USER" -p"$DB_PASSWORD" -h"$DB_HOST" "$DB_NAME" -e "SHOW TABLES;" | awk '{if (NR!=1) {print $1}}')

# Truncate each table
for TABLE in $TABLES
do
    echo "Truncating table: $TABLE"
    mysql -u"$DB_USER" -p"$DB_PASSWORD" -h"$DB_HOST" "$DB_NAME" -e "TRUNCATE TABLE $TABLE;"
done

echo "All tables truncated successfully."