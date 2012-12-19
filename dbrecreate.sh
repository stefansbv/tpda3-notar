#!/bin/bash

DB=notar
SHP="-s localhost"
#SHP="-s ds -po 5454"
USER=stefan
PASS=secret

createdb -U postgres -O $USER -T template0 -E UTF8 $DB

psql -d $DB < sql/schema-notar.sql

bash ./script/load-siruta.sh

bash ./script/load.sh

echo done.
