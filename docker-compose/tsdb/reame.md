
# Upgrade Extension

## default db

```sh
docker exec -it timescaledb psql -U postgres -X
```

```sql
ALTER EXTENSION timescaledb UPDATE;
CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;
ALTER EXTENSION timescaledb_toolkit UPDATE;
```

## custom db

```sh
docker exec -it timescaledb psql -U postgres -X mydb
```

```sql
ALTER EXTENSION timescaledb UPDATE;
CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;
ALTER EXTENSION timescaledb_toolkit UPDATE;
```

https://docs.timescale.com/timescaledb/latest/how-to-guides/upgrades/upgrade-docker/