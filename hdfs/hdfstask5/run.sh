#!/bin/bash


file_size=$1
dd if=/dev/zero of=pep  bs=$file_size count=1
hdfs dfs -put pep /tmp/pep

block_list=$(hdfs fsck /tmp/pep -files -blocks -locations | grep -o blk_[0-9]*)
sum_size=0

#echo "blocklist = $block_list"

for block_id in $block_list
do
        node_name=$(hdfs fsck -blockId $block_id | grep -o -m 1 mipt-node[0-9]*.atp-fivt.org)
#        echo "blockid = $block_id <---------------------"
        path=$(get_block_server $block_id)
#        echo $path
        node=${path%:*}
#        echo $node
        path_to_block=${path#*:}
#        echo "-------------------->>> $path_to_block -----------------"

block_size=$(
sudo -u hdfsuser ssh hdfsuser@$node << EOF
    du $path_to_block
EOF
)

        block_size=$(echo $block_size | awk '{print $1}')
#        echo
#        echo $block_size
        sum_size=$(($sum_size + $block_size))
done

hdfs dfs -rm /tmp/pep
rm pep


#echo $(($sum_size - $file_size))
echo 0
