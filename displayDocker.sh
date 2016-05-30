#!/bin/bash

echo "--------------------------"
echo "--- containers running ---"
echo "--------------------------"
docker ps --filter status=running --format "{{.Names}}\t{{.Status}}" | awk '{print " " $1 "\t" $2}'

echo " "
echo "--------------------------"
echo "--- containers  exited ---"
echo "--------------------------"
docker ps -a --filter status=exited --format "{{.Names}}\t{{.Status}}" | \
  awk '{print " " $1 "\t" $3}' | \
  sed 's/(0)/OK/g;s/(6)/Error: backend tests/g;s/(7)/Error: frontend tests/g;s/(8)/Error: packaging/g'
echo " "
echo "--------------------------"
