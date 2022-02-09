#!/bin/bash

# https://hub.docker.com/_/postgres?tab=description#Initialization%20scripts
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER ci;
  CREATE DATABASE db_ci_test;
  ALTER USER ci WITH PASSWORD 'ci';
  GRANT ALL PRIVILEGES ON DATABASE db_ci_test TO ci;
EOSQL

