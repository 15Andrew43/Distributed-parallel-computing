#!/bin/bash

rm ./02-mul.csv

for ((i=0; i < 29; i++))
do 
    ./build/02-mul $i 64
    ./build/02-mul $i 128
    ./build/02-mul $i 256
done
