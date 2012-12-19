#!/bin/bash

# dropdb database
# createdb -E UTF8 -O user -U postgres -T template0 database
# psql -d database < sql/siruta.sql

DB=notar
SHP="-s localhost"
#SHP="-s ds -po 5454"
USER=stefan
PASS=secret

#- Import data

csv-import.pl -mo pg $SHP -db $DB -u $USER -pa $PASS -f data/codificari.dat
