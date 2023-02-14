#!/bin/bash

nJobs=4


DB="${1:-}"
if [ -z "${DB}" ]; then
  echo '[ERR] DB undefined'
  echo usage: ./pgrestore.sh mydb src-folder
  exit 1
fi

DIR="${2:-}"
if [ -z "${DIR}" ]; then
  echo '[ERR] DIR undefined'
  echo usage: ./pgrestore.sh mydb src-folder
  exit 1
fi


while true; do
  echo -n "[Question] "; read -e -p "Whether create target database: \"$DB\" ? [y|n] " -i "" yn
  case ${yn} in
    [Nn]*)
      echo -e "-----------------------------\n"
      echo -e "ensure database exits\n"
      echo -e "sql creating database:"
      echo -e "createdb -Upostgres -E utf8 --locale=C.UTF-8 newdb "
      echo -e "-----------------------------\n"
      break;;
    [Yy]*)
      echo -e "> Creating database: \"$DB\" \n"

      # createdb -Upostgres -E utf8 --locale=en_US.UTF-8 newdb
      # createdb -Upostgres -E utf8 --locale=zh_CN.UTF-8 newdb
      createdb -Upostgres -E utf8 --locale=C.UTF-8 $DB

      status=$?
      if [ $status -ne 0 ]; then
        exit 1;
      fi
      break;;
    *)     echo 'Please answer (y)es or (n)o';;
  esac;
done;

clear

while true; do
  echo -n "[Question] "; read -e -p "Restore database parallel ? [y|n] " -i "" yn
  case ${yn} in
    [Nn]*)
      echo -e "-----------------------------\n"
      echo -e "Starting Restore PostgreSQL\n"
      echo database: $DB
      echo source: $DIR
      echo -e "-----------------------------\n"
      time pg_restore -Upostgres --single-transaction --no-data-for-failed-tables -d $DB $DIR
      # time pg_restore -Upostgres --single-transaction --clean --if-exists -d $DB $DIR

      status=$?
      if [ $status -ne 0 ]; then
        exit 1;
      fi
      break;;
    [Yy]*)
      echo -e "-----------------------------\n"
      echo -e "Starting Restore PostgreSQL\n"
      echo database: $DB
      echo source: $DIR
      echo jobs: $nJobs
      echo -e "-----------------------------\n"
      time pg_restore -Upostgres --no-data-for-failed-tables -j${nJobs} -d $DB $DIR
      # time pg_restore -Upostgres --data-only --no-data-for-failed-tables -j${nJobs} -d $DB $DIR
      # time pg_restore -Upostgres --clean --if-exists -j${nJobs} -d $DB $DIR

      status=$?
      if [ $status -ne 0 ]; then
        exit 1;
      fi
      break;;
    *)     echo 'Please answer (y)es or (n)o';;
  esac;
done;



echo "Finishd"

while true; do
  echo -n "[Question] "; read -e -p "Do you want to analyze database? [y|n] " -i "" yn
  case ${yn} in
    [Nn]*) exit 0;;
    [Yy]*)
      echo -e "-----------------------------\n"
      echo -e "Analyzing PostgreSQL\n"
      echo database: $DB
      echo jobs: $nJobs
      echo -e "-----------------------------\n"
      time vacuumdb -Upostgres --analyze-in-stages -j${nJobs} -d $DB

      status=$?
      if [ $status -ne 0 ]; then
        exit 1;
      fi
      break;;
    *)     echo 'Please answer (y)es or (n)o';;
  esac;
done;


# 将上述脚本导入一个(新建的)数据库 newdb ：
# createdb newdb -E utf8 --locale=C.UTF-8  -Upostgres
# $ psql -d newdb -f db.sql
# gzip -cd db.sql.gz | psql -d newdb -f
# time vacuumdb -Upostgres -z -P12 -j12 -d userdb0021-3

# http://www.postgres.cn/docs/14/app-pgrestore.html

