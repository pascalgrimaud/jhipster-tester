#!/bin/bash

retryCount=1
maxRetry=10
running=$(docker ps -q --filter status=running --filter "label=test")
while [ "$running" != "" ] && [ $retryCount -le $maxRetry ]; do
    echo "[$(date)] Containers still running... " $retryCount "/" $maxRetry
    docker ps --filter label=test --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}"
    echo " "
    retryCount=$((retryCount+1))
    sleep 30
    running=$(docker ps -q --filter status=running --filter "label=test")
    status=$?
done

if [ "$running" != "" ]; then
    echo "[$(date)] Containers running too long..."
else
    echo "[$(date)] Finished!"
fi
docker ps -a --filter label=test --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}"
