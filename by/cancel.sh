#!/bin/bash -l
for i in $(seq 5346000 5348000)
do
    echo $i
    scancel $i
done
