#!/bin/bash

export PGPASSWORD='postgres'

migrations_path="/docker-entrypoint-initdb.d/Migrations"
migration_version="$(cat "/docker-entrypoint-initdb.d/env" | grep -E MIGRATION | awk '{ print $3 } ')"

if [[ "$migration_version" == "" ]]
then
    migration_version="1.0.1"
fi

list="$(ls "$migrations_path" | sort -V)"
for migration_file in $list
do
    psql -h localhost -p 5000 -U postgres -v cnt=100 -f "$migrations_path/$migration_file"

    if [[ "$migration_file" == "$migration_version.sql" ]]
    then
        break
    fi

done;

generators_path="/docker-entrypoint-initdb.d/Data generators"
generator_version="gen $migration_version"
generator_cnt="$(cat "/docker-entrypoint-initdb.d/env" | grep -E GENERATOR_CNT | awk '{ print $3 } ')"

list="$(ls "$generators_path" | sort -V)"
for generator_file in $list
do
    psql -h localhost -p 5000 -U postgres -v cnt=$generator_cnt -f "$generators_path/$generator_file"

    if [[ "$generator_file" == "gen$migration_version.sql" ]]
    then
        break
    fi

done;

psql -h localhost -p 5000 --username "postgres" --dbname "postgres" << EOF

CREATE ROLE reader;
CREATE ROLE writer;

GRANT CONNECT ON DATABASE postgres TO reader, writer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO writer;

CREATE USER analytic;
GRANT SELECT ON public.bonds TO analytic;

CREATE ROLE developers WITH NOLOGIN;
GRANT SELECT, INSERT, DELETE ON ALL TABLES IN SCHEMA public TO developers;

EOF

users="$(cat "/docker-entrypoint-initdb.d/env" | grep -E "USERS" | grep -Eo "\[.*\]" )"
users="$(echo "$users" | tr -d '[,]' )"

for user in $users
do
    user="${user//\'/}"
    echo "$user"
    psql -h localhost -p 5000 -v user=$user --username "postgres" --dbname "postgres" << EOF
        CREATE USER :user WITH PASSWORD 'pass';
        GRANT CONNECT ON DATABASE postgres TO :user;
        GRANT :user TO developers;

EOF

done;