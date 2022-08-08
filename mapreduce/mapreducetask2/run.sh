#!/usr/bin/env bash

OUT_DIR="pd202253_114"
NUM_REDUCERS=8


hadoop fs -rm -r -skipTrash $OUT_DIR* > /dev/null 2>&1

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="pd202253_114" \
    -D mapreduce.job.reduces=$NUM_REDUCERS \
    -files mapper1.py,reducer1.py \
    -mapper mapper1.py \
    -combiner reducer1.py \
    -reducer reducer1.py \
    -input /data/wiki/en_articles_part \
    -output $OUT_DIR/part1 > /dev/null

yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
    -D mapred.job.name="pd202253_114" \
    -D mapreduce.job.reduces=$NUM_REDUCERS \
    -files mapper2.py,reducer2.py \
    -mapper mapper2.py \
    -combiner reducer2.py \
    -reducer reducer2.py \
    -input $OUT_DIR/part1 \
    -output $OUT_DIR/part2 > /dev/null

hdfs dfs -cat 2>/dev/null $OUT_DIR/part2/part-00000 | head -n 10



