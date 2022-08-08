#!/bin/bash

get_n_blocks() {
        n_blocks=$(hdfs fsck $1 -files -blocks -locations | sed -n 2p)
        n_blocks=${n_blocks#*bytes, }
        n_blocks=${n_blocks% block*}
        echo $n_blocks
}

get_ip_block() {
        n_blocks=$(get_n_blocks $1)
        number=$((3 + $2))
#       echo $n_blocks

#        if [ $2 -ge $n_blocks ]
 #       then
  #              echo "number of block is too large"
   #     else
                line=$(hdfs fsck $1 -files -blocks -locations | sed -n ${number}p)
                ip=${line#*DatanodeInfoWithStorage[}
                ip=$(expr match "$ip" '\([0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\)')
                echo $ip
    #    fi
}

file=$1

get_ip_block $file 0
