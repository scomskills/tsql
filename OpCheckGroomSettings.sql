/*
Check OP groom settings
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT ObjectName, DaysToKeep AS Days
FROM  PartitionAndGroomingSettings
ORDER BY ObjectName