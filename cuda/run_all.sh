#!/bin/bash

export CUDA_VISIBLE_DEVICES=5

./run_scripts/01-add.sh
./run_scripts/02-mul.sh
./run_scripts/03-matrix-add.sh
./run_scripts/04-matrix-vector-mul.sh
./run_scripts/05-scalar-mul.sh
