#!/bin/bash -l
for i in $(seq 4555670 4556774)
do
    scancel $i
done
