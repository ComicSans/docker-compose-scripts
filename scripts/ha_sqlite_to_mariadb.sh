#!/usr/bin/env sh
#sudo apt install sqlite3
#sqlite3 ../configs/homeassistant/home-assistant_v2.db .dump > /tmp/ha-database_sqlite.dump.sql

if test -z "$VARCHAR"
  then
    VARCHAR="255"
fi
sed \
 -e 's/PRAGMA foreign_keys=OFF;/SET FOREIGN_KEY_CHECKS=0;/g' \
 -e '/ PRAGMA.*;/ d' \
 -e 's/BEGIN TRANSACTION;/BEGIN;/g' \
 -e '/COMMIT.*/ d' \
 -e '/ANALYZE sqlite_schema;/ d' \
 -e '/INSERT INTO sqlite_stat1.*/d' \
 -e '/.*sqlite_sequence.*;/d' \
 -e "s/ varchar/ varchar($VARCHAR)/g" \
 -e 's/"events"/events/g ' \
 -e 's/"recorder_runs"/recorder_runs/g' \
 -e 's/"schema_changes"/schema_changes/g' \
 -e 's/"states"/states/g' \
 -e 's/" end"/end/g' \
 -e 's/CREATE TABLE \(`\w\+`\)/DROP TABLE IF EXISTS \1;\nCREATE TABLE \1/' \
 -e 's/\(CREATE TABLE .*\)\(PRIMARY KEY\) \(AUTOINCREMENT\)\(.*\)\();\)/\1AUTO_INCREMENT\4, PRIMARY KEY(id)\5/' \
 -e "s/'t'/1/g" \
 -e "s/'f'/0/g" \
 /tmp/ha-database_sqlite.dump.sql > /tmp/mysql_import_me.sql
