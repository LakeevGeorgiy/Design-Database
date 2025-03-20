#!/bin/bash

docker stop business_broker
docker rm business_broker
docker volume prune

if [[ -f "Explain results/explain.log" ]]
then
    rm "Explain results/explain.log"
fi;

rm Backups/*.dump