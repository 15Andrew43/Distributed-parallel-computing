#!/bin/bash

rm ./01-add.csv

for ((i=0; i < 29; i++))
do 
    ./build/01-add $i 64
    ./build/01-add $i 128
    ./build/01-add $i 256
done
