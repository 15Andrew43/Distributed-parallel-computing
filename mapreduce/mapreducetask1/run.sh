#!/usr/bin/env bash

OUT_DIR="pd202253_110"
NUM_REDUCERS=8

hdfs dfs -rm -r -skipTrash $OUT_DIR* > /dev/null 2>&1

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapreduce.job.name="pd202253_110" \
    -D mapreduce.job.reduces=$NUM_REDUCERS \
    -files mapper.py,reducer.py \
    -mapper mapper.py \
    -reducer reducer.py \
    -input /data/ids \
    -output $OUT_DIR > /dev/null

files_to_read=""
for num in `seq 0 $(($NUM_REDUCERS - 1))`
do
    files_to_read="$files_to_read $OUT_DIR/part-0000$num"
done

hdfs dfs -cat 2>/dev/null $files_to_read | head -n 50

