#!/bin/bash -l
for i in $(seq 4859146 4859946)
do
    echo $i
    scancel $i
done
