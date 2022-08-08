USE borovetsan;

SET mapred.job.name=hive_task2_borovetsan;

SELECT time, COUNT(DISTINCT status) AS n_status
FROM Logs
GROUP BY time
ORDER BY n_status DESC

