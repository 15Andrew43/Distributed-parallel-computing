#!/bin/bash

rm ./05-scalar-mul-sum-plus-reduction.csv
rm ./05-scalar-mul-two-reductions.csv


for ((i=0; i < 20; i++))
do 
    ./build/05-scalar-mul $i 64
    ./build/05-scalar-mul $i 128
    ./build/05-scalar-mul $i 256
done
