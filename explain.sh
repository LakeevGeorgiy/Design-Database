#!/bin/bash

export PGPASSWORD='postgres'

number="$(ls "$PWD/Explain results" | wc -l)"
let "number=$number+1"
result_file_name="$PWD/Explain results/explain$number.log"
touch "$result_file_name"

queries_path="$PWD/Queries"
attempts="$(less ".env" | grep -E "ATTEMPTS" | grep -Eo "[0-9]*")"

list="$(ls "$queries_path" | sort -V)"
j=0

for query_file in $list
do

    let "j=$j+1"
    min_cost=100000000
    max_cost=0
    average_cost=0

    for ((i=0; i < attempts ; i++ ))
    do
        psql_result="$(psql -U postgres -d postgres -h localhost -p 5433 -f "$queries_path/$query_file")"
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

echo "#######################################"
echo "#######################################"
echo "Result of explain analyze after indexes"
echo "#######################################"
echo "#######################################"

echo >> "$result_file_name"
echo "Result of explain analyze after indexes" >> "$result_file_name"
echo >> "$result_file_name"

j=0
index_version="$(less ".env" | grep -E "INDEX_VERSION" | awk '{ print $3} ')"
indexes_path="$PWD/Indexes/$index_version.sql"

psql -U postgres -d postgres -h localhost -p 5433 -f "$indexes_path"

for query_file in $list
do
    let "j=$j+1"
    min_cost=100000000
    max_cost=0
    average_cost=0

    for (( i=0; i < attempts; i++ ))
    do
        psql_result="$(psql -U postgres -d postgres -h localhost -p 5433 -f "$queries_path/$query_file")"
        echo -E "$psql_result"
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