ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE borovetsan;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=500;
SET hive.exec.max.dynamic.partitions.pernode=500;



DROP TABLE IF EXISTS LogsWithNoPartiotion;
CREATE EXTERNAL TABLE LogsWithNoPartiotion (
    ip STRING,
    time INT,
    http STRING,
    size SMALLINT,
    status SMALLINT,
    client_info STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = '^(\\S+)\\t{3}(\\d{8})\\S+\\t(\\S+)\\t(\\d+)\\t(\\d+)\\t(\\S+).*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_logs_M';



DROP TABLE IF EXISTS Logs;
CREATE EXTERNAL TABLE Logs (
    ip STRING,
    http STRING,
    size SMALLINT,
    status SMALLINT,
    client_info STRING
)
PARTITIONED BY (time INT)
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE Logs PARTITION (time) 
SELECT ip, http, size, status, client_info, time
FROM LogsWithNoPartiotion;



DROP TABLE IF EXISTS IPRegions;
CREATE EXTERNAL TABLE IPRegions (
    ip STRING,
    region STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/user_logs/ip_data_M';



DROP TABLE IF EXISTS Users;
CREATE EXTERNAL TABLE Users (
    ip STRING,
    browser STRING,
    sex STRING,
    age TINYINT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_data_M';



DROP TABLE IF EXISTS Subnets;
CREATE EXTERNAL TABLE Subnets (
    ip STRING,
    mask STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/subnets/variant2';



SELECT * FROM Logs LIMIT 10;
SELECT * FROM IPRegions LIMIT 10;
SELECT * FROM Users LIMIT 10;
SELECT * FROM Subnets LIMIT 10;
