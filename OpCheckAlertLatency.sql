/*
Check OP Alert Latency
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT CONVERT(VARCHAR(10), TimeAdded, 101) AS Date,
	COUNT(*) AS 'Alert Count',
	(SUM(CASE WHEN DateDiff(second, TimeRaised, TimeAdded) < 31 THEN 1 ELSE 0 END) * 100) / COUNT(*) '% under 30s',
	(SUM(CASE WHEN DateDiff(second, TimeRaised, TimeAdded) < 61 THEN 1 ELSE 0 END) * 100) / COUNT(*) '% under 60s'
FROM AlertView A
WHERE TimeRaised IS NOT NULL
GROUP BY CONVERT(VARCHAR(10), TimeAdded, 101)
ORDER BY CONVERT(VARCHAR(10), TimeAdded, 101) DESC