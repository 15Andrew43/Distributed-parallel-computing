#!/bin/bash



get_block_server() {
        line=$(hdfs fsck -blockId $1 | tail -n 1)
        node=${line#*: }
        node=${node%/*}

#       echo "$node  =========================================================="

path_to_block=$(
sudo -u hdfsuser ssh hdfsuser@$node << EOF
    cd /
    find -name $1 2>/dev/null
EOF
)
        path_to_block=$(echo $path_to_block | tail -n -1)
        path_to_block=${path_to_block:1}

        echo "$node:$path_to_block"
}


get_block_server $1
