ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE borovetsan;

SELECT
client_info,
SUM(IF(sex='male', 1, 0)) AS n_male,
SUM(IF(sex='female', 1, 0)) AS n_female
FROM Logs INNER JOIN Users ON (Logs.ip = Users.ip)
GROUP BY client_info;

