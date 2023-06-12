# pg_stat_statements 性能记录

## 开启

`conf`
```
shared_preload_libraries = 'pg_stat_statements'

log_duration = on
log_min_messages = warning #  error warning info notice debug debug5
log_statement = 'mod'                  # none, ddl, mod, all
log_line_prefix = '%m [%p]: [%c-%l] s=%e,u=%u,d=%d,a=%a,h=%h,q=%Q,vt=%v '
compute_query_id = on
```

重启集群服务，然后执行

```
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
-- OR 
docker exec -i tsdb psql -U postgres -d userdb0021 -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements"
```

## 查询

```sql
SELECT 
  userid,
  dbid,
  queryid,
  query,
  max_exec_time::numeric(24, 3),
  mean_exec_time::numeric(24, 3),
  stddev_exec_time::numeric(24, 3),
  total_exec_time::numeric(24, 3),
  rows,
  (1.0 * shared_blks_hit / nullif(shared_blks_hit + shared_blks_read, 0))::numeric(24, 2) AS hit_percent,
  shared_blks_hit, -- 语句的共享块缓存命中总数 
  shared_blks_read,  -- 语句读取的共享块总数 
  plans,
  max_plan_time::numeric(24, 3),
  mean_plan_time::numeric(24, 3)

  FROM pg_stat_statements
  WHERE true 
    AND query NOT LIKE 'set client_encoding%'
    AND query NOT LIKE '-- %'
    AND query NOT LIKE '%pg_get_userbyid(%'
    AND query NOT IN ('BEGIN', 'END')
    AND query NOT LIKE 'CREATE %'
    AND query NOT LIKE 'DROP %'
    AND query NOT LIKE 'COMMENT ON %'
    AND query NOT LIKE '%FROM pg_stat_statements%'
    AND query NOT LIKE '%FROM pg_constraint c%'
    -- AND query LIKE '%goods%'
    -- AND queryid = '173994706094682957'
  ORDER BY
    max_exec_time DESC,
    total_exec_time DESC,
    rows DESC,
    calls DESC
  LIMIT 50
```

## Docs

- [doc](http://www.postgres.cn/docs/14/pgstatstatements.html)
- [Using Query ID in Postgres 14](https://blog.rustprooflabs.com/2021/10/postgres-14-query-id)

SELECT c.oid, n.nspname AS schemaname, c.relname AS tablename, c.relacl, pg_get_userbyid(c.relowner) AS tableowner, obj_description(c.oid) AS description, c.relkind, ci.relname As cluster, c.relhasindex AS hasindexes, c.relhasrules AS hasrules, t.spcname AS tablespace, c.reloptions AS param, c.relhastriggers AS hastriggers, c.relpersistence AS unlogged, ft.ftoptions, fs.srvname, c.relispartition, pg_get_expr(c.relpartbound, c.oid) AS relpartbound, c.reltuples, ((SELECT count(*) FROM pg_inherits WHERE inhparent = c.oid) > $1) AS inhtable, i2.nspname AS inhschemaname, i2.relname AS inhtablename FROM pg_class c LEFT JOIN pg_namespace n ON n.oid = c.relnamespace LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace LEFT JOIN (pg_inherits i INNER JOIN pg_class c2 ON i.inhparent = c2.oid LEFT JOIN pg_namespace n2 ON n2.oid = c2.relnamespace) i2 ON i2.inhrelid = c.oid LEFT JOIN pg_index ind ON(ind.indrelid = c.oid) and (ind.indisclustered = $2) LEFT JOIN pg_class ci ON ci.oid = ind.indexrelid LEFT JOIN pg_foreign_table ft ON ft.ftrelid = c.oid LEFT JOIN pg_foreign_server fs ON ft.ftserver = fs.oid WHERE ((c.relkind = $3::"char") OR (c.relkind = $4::"char") OR (c.relkind = $5::"char")) AND n.nspname = $6 ORDER BY schemaname, tablename