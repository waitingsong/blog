# <center>PostgreSQL 安装</center>

以 Docker 方式安装 PostgreSQL 13

以 `root` 用户登录执行以下操作

## 准备环境

下载镜像
```sh
docker pull postgres:13.1
```

拷贝目录 [./asset](./asset) 到服务器

- [postgresql.conf] 原文件
- [custom.conf] 自定义设置
  - `log_statement = 'mod'` 用于测试，生产环境应修改为需要的级别


## 测试启动服务

```sh
docker-compose up
```

## 测试控制台登录
```bash
docker exec -it pg bash
psql -U postgres
postgres=# \l
```
应有输出 

| Name       | Owner    | Encoding | Collate    | Ctype      | Access privileges      |
| ---------- | -------- | -------- | ---------- | ---------- | ---------------------- |
| db_ci_test | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres         + |
|            |          |          |            |            | postgres=CTc/postgres+ |
|            |          |          |            |            | ci=CTc/postgres        |
| postgres   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                        |
| template0  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          + |
|            |          |          |            |            | postgres=CTc/postgres  |
| template1  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          + |
|            |          |          |            |            | postgres=CTc/postgres  |
| (4 rows)   |          |          |            |            |                        |
|            |          |          |            |            |                        |


## 启动服务

编辑 docker-compose.yml 文件
- 注销此行 `./entrypoint-initdb.d:/docker-entrypoint-initdb.d`
- 启用下列行
  - `./conf/postgresql.conf:/var/lib/postgresql/data/postgresql.conf`
  - `./conf/custom.conf:/var/lib/postgresql/data/custom.conf`

启动
```sh
docker-compose up -d
```

查看日志
```sh
docker logs -f pg
```


<br>

[postgresql.conf]: asset/conf/postgresql.conf
[custom.conf]: asset/conf/custom.conf
