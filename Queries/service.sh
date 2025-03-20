#!/bin/bash

export PGPASSWORD='postgres'
source_path="/mnt/c/labwork/Design database/Second step/"

number="$(ls "$source_path/Explain results" | wc -l)"
let "number=$number+1"
result_file_name="$source_path/Explain results/explain.log"
env_file="$source_path/.env"

if [[ ! -f "$result_file_name" ]]
then
    touch "$result_file_name"
fi;

queries_path="$source_path/Queries"
attempts="$(less "$env_file" | grep -E "ATTEMPTS" | grep -Eo "[0-9]*")"

list="$(ls "$queries_path" | sort -V)"
j=0

for query_file in $list
do

    if [[ "$query_file" != *.sql ]]
    then
        continue
    fi;

    let "j=$j+1"
    min_cost=100000000
    max_cost=0
    average_cost=0

    for ((i=0; i < attempts ; i++ ))
    do
        psql_result="$(psql -U postgres -d postgres -h localhost -p 5000 -f "$queries_path/$query_file")"
        cost="$(echo "$psql_result" | grep -Eo 'Execution Time: [0-9]*\.{1}[0-9]*' | grep -Eo '[0-9]*\.{1}[0-9]*')"
        
        if [[ $(echo "$min_cost > $cost" | bc -l) -eq 1 ]]
        then
            min_cost="$cost"
        fi;

        if [[ $(echo "$max_cost < $cost" | bc -l) -eq 1 ]]
        then
            max_cost="$cost"
        fi;

        average_cost="$(echo "$average_cost + $cost" | bc -l)"
    done;

    average_cost="$(awk -v sum="$average_cost" -v cnt="$attempts" ' BEGIN{ print sum / cnt }')"
    echo "sql: $j, min: $min_cost, avg: $average_cost, max: $max_cost" >> "$result_file_name"

done;

echo "" >> "$result_file_name"
echo "" >> "$result_file_name"
echo "" >> "$result_file_name"