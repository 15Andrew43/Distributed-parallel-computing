#!/bin/bash

rm ./04-matrix-vector-mul.csv


for ((i=0; i < 15; i++))
do 
    ./build/04-matrix-vector-mul 14 $i 64
    ./build/04-matrix-vector-mul 14 $i 128
    ./build/04-matrix-vector-mul 14 $i 256
done
