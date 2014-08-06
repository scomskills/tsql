/*
Check update statistics jobs.
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
USE OperationsManagerDW
SELECT dt.DomainTableRowId, dt.TableObjectId, dt.TableName, dt.SchemaName, dt.DatasetId, dt.CreatedDateTime, dti.DomainTableStatisticsUpdateHistoryRowId, 
               dti.DomainTableRowId AS DTRowId, dti.StatisticName, dti.UpdateStartDateTime, dti.UpdateDurationSeconds, dti.RowsSampledPercentage
FROM  DomainTable AS dt INNER JOIN
               DomainTableStatisticsUpdateHistory AS dti ON dt.DomainTableRowId = dti.DomainTableRowId
WHERE dti.UpdateStartDateTime >= DATEADD(DD,-1,GETDATE())
ORDER BY dti.UpdateDurationSeconds DESC