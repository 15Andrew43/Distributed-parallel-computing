#!/bin/bash

rm ./03-matrix-add.csv

for ((i=0; i < 15; i++))
do 
    ./build/03-matrix-add $i 14 64
    ./build/03-matrix-add $i 14 128
    ./build/03-matrix-add $i 14 256
done
