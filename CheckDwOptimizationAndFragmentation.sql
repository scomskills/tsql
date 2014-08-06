/*
Check optimization and fragmentation levels of default domain tables.
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT dt.DomainTableRowId, dt.TableObjectId, dt.TableName, dt.SchemaName, dt.DatasetId, dt.CreatedDateTime, dti.DomainTableIndexOptimizationHistoryRowId, 
               dti.DomainTableIndexRowId, dti.OptimizationStartDateTime, dti.OptimizationDurationSeconds, dti.BeforeAvgFragmentationInPercent, 
               dti.AfterAvgFragmentationInPercent, dti.OptimizationMethod
FROM  DomainTable AS dt INNER JOIN
               DomainTableIndexOptimizationHistory AS dti ON dt.DomainTableRowId = dti.DomainTableIndexRowId
WHERE dti.OptimizationStartDateTime >= DATEADD(DD,-1,GETDATE())
ORDER BY dti.OptimizationDurationSeconds DESC