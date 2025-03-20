#!/bin/bash

docker compose up -d
docker exec -it lab-haproxy bash
bash /usr/lib/postgresql/16/bin/initdb


echo "shared_preload_libraries = 'pg_stat_statements'" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.max = 10000" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.track = all" >> $PGDATA/postgresql.conf

cat "$PGDATA/postgresql.conf"