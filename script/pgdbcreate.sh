#!/bin/bash

# Variables
DB=notar
USER=user
PASS=secret

createdb -U postgres -O $USER -T template0 -E UTF8 $DB
if [ $? -ne 0 ]
then
    # Don't continue after errors
    exit
fi

psql -d $DB < sql/schema-notar.sql
if [ $? -ne 0 ]
then
    # Don't continue after errors
    exit
fi

bash ./script/load-siruta.sh

bash ./script/load.sh

echo done.
