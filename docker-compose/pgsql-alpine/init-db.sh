#!/bin/bash
# 初始化 pg 集群
# 将会自动执行 entrypoint-initdb.d/ 目录下文件
# 数据库服务成功启动之后使用 ctrl-c 退出
# 然后正常启动服务 `docker-compose up -d`
#
# @date 2021.03.09
# @example `./init-db.sh <password of Postgres>`
#

cwd=`pwd`
PASSWD="${1:-}"
# 可与 docker-compose.yml 值不相同
container_name=pg-init
# docker-compose.yml services 键值，空格分隔输入多个值
SVC="db"


# docker-compose down -v

if [[ -z ${PASSWD} ]]; then
  echo '[ERR] password not passed. Please input password for db user postgres. Remember the password!'
  exit 1
fi

docker-compose run \
  --name $container_name \
  -v $cwd/entrypoint-initdb.d/:/docker-entrypoint-initdb.d \
  -e POSTGRES_PASSWORD="$PASSWD" \
  $SVC

