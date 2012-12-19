REM @echo off

REM dropdb database
REM createdb -E UTF8 -O user -U postgres -T template0 database
REM psql -d database < sql/siruta.sql

call perl script\csv-import.pl -mo pg -db notar -u stefan -pa secret -f data\tari.dat
call perl script\csv-import.pl -mo pg -db notar -u stefan -pa secret -f data\siruta_tip.dat
call perl script\csv-import.pl -mo pg -db notar -u stefan -pa secret -f data\judete.dat
call perl script\csv-import.pl -mo pg -db notar -u stefan -pa secret -f data\siruta.dat
