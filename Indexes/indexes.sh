#!/bin/bash

export PGPASSWORD='postgres'
source_path="$PWD/.."
result_file_name="$source_path/Explain results/explain.log"
service_path="$source_path/Queries/service.sh"
env_file="$source_path/.env"

echo >> "$result_file_name"
echo "Result of explain analyze after indexes" >> "$result_file_name"
echo >> "$result_file_name"

j=0
index_version="$(less "$env_file" | grep -E "INDEX_VERSION" | grep -Eo "[0-9]*")"
indexes_path="$source_path/Indexes/$index_version.sql"

psql -U postgres -d postgres -h localhost -p 5000 -f "$indexes_path"

bash "$service_path"