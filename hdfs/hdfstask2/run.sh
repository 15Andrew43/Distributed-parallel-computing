#!/bin/bash

get_bytes() {
        reversed=$(curl -i -s -L "http://mipt-master.atp-fivt.org:50070/webhdfs/v1$1?op=OPEN&length=$2" | tac)

        echo ${reversed:0:$2}
}

file=$1

get_bytes $file 10

