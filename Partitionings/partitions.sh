#!/bin/bash

export PGPASSWORD='postgres'
source_path="$PWD/.."
result_file_name="$source_path/Explain results/explain.log"
service_path="$source_path/Queries/service.sh"

psql -U postgres -d postgres -h localhost -p 5000 -f CreatePartitionFunction.sql
psql -U postgres -d postgres -h localhost -p 5000 -f SecurityPaperPartition.sql

echo >> "$result_file_name"
echo "Result of explain analyze after partitions" >> "$result_file_name"
echo >> "$result_file_name"

chmod u+x "$service_path"
bash "$service_path"