#!/bin/bash -l
for ijob in $(seq 5290000 5292000)
do
    scancel $ijob &
done    
