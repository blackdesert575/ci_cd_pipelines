#!/bin/bash

# MySQL credentials
DB_USER="worker"
DB_PASSWORD="d26N7MKLzlhk"
DB_HOST="192.168.88.206"
DB_NAME="image_board"

# Retrieve table names
TABLES=$(mysql -u"$DB_USER" -p"$DB_PASSWORD" -h"$DB_HOST" "$DB_NAME" -e "SHOW TABLES;" | awk '{if (NR!=1) {print $1}}')