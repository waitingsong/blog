#!/bin/bash
clear

nJobs=8

DB="${1:-}"
if [ -z "${DB}" ]; then
  echo '[ERR] DB undefined'
  echo usage: ./pgdump.sh mydb
  exit 1
fi

DIR="${2:-}"
if [ -z "${DIR}" ]; then
  DIR="./"
else
  mkdir -p "${DIR}"
fi
cd $DIR

find $DIR -type d -mtime +30 -print0 | xargs -0II rm -rf I ;

mydate=$(date +%Y-%m-%d.%H_%M_%S)
target="$DB-$mydate"
echo -e "-----------------------------\n"
echo -e "Starting Backup PostgreSQL\n"
echo database: $DB
echo target: $target
echo -e "-----------------------------\n"
#pg_dump -Upostgres $DB | gzip > $DB-$mydate.sql.gz
mkdir -p "$target"
chmod 755 "$target"
time pg_dump -Upostgres -Z7 --clean --if-exists -j${nJobs} -Fd "$DB" -f "$target"

echo "Finishd"

# 将上述脚本导入一个(新建的)数据库 newdb ：
# createdb newdb -E utf8 --locale=C.UTF-8  -Upostgres
# $ psql -d newdb -f db.sql
# gzip -cd db.sql.gz | psql -d newdb -f
# time pg_restore -Upostgres --clean --if-exists -j${nJobs} -d newdb dumpfolder
# time vacuumdb -Upostgres -z -P12 -j12 -d userdb0021-3

