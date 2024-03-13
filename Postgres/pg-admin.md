# <center>PostgreSQL 管理</center>


## 创建管理员
```sql
CREATE USER admin_user WITH PASSWORD 'PASSWORD';
ALTER USER admin_user WITH SUPERUSER;

```

## 创建普通用户
```sql
CREATE USER new_user WITH PASSWORD 'user_password';
GRANT CREATEDB TO new_user;

GRANT <permission> ON DATABASE <database_name> TO <username>;
GRANT <permission> ON TABLE <table_name> TO <username>;

GRANT ALL PRIVILEGES ON DATABASE db TO cherry;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cherry;

GRANT CONNECT ON DATABASE db TO cherry;
GRANT pg_read_all_data TO cherry;
GRANT pg_write_all_data TO cherry;

```


