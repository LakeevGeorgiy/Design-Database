#!/bin/bash

source_path="/mnt/c/labwork/Design database/Second step"
env_file="$source_path/.env"
M="$(less "$env_file" | grep -E '^M ' | grep -Eo "[0-9]*")"

backup(){

    count_number="$(ls | grep -E 'dump' | wc -l)"
    current_number="$(ls | grep -E 'dump' | grep -Eo "[0-9]*" | sort -n | tail -n 1)"
    echo "before:$current_number"
    let current_number="$current_number+1"

    if [[ "$count_number" -ge "$M" ]]
    then
        latest="$(ls | grep -E 'dump' | grep -Eo "[0-9]*" | sort -n | head -n 1)"
        rm "db$latest.dump"
    fi;
    echo "$count_number, $current_number"

    export PGPASSWORD='postgres'
    pg_dumpall --host=localhost -p 5000 -U postgres --database=postgres -f db$current_number.dump

}

backup_file="$source_path/Backups/backup.sh"

N="$(less "$env_file" | grep -E '^N ' | grep -Eo "[0-9]*")"
start_time="$(date +%s)"

while true
do
    current_time="$(date +%s)"
    diff="$(awk -v first="$start_time" -v second="$current_time" 'BEGIN { print (second - first) / 3600 }' )"

    if [[ $(echo "$diff > $N" | bc -l) -eq 1 ]]
    then
        backup
        start_time="$(date +%s)"
    fi;

    sleep 10
done;