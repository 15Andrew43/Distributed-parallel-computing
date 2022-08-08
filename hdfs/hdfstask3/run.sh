#!/bin/bash


get_n_blocks() {
        n_blocks=$(hdfs fsck $1 -files -blocks -locations | sed -n 2p)
        n_blocks=${n_blocks#*bytes, }
        n_blocks=${n_blocks% block*}
        echo $n_blocks
}



file=$1


get_n_blocks $file

