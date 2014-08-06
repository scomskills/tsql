/*
Check optimization (update statistics) jobs in DW.
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT sdas.BaseTableName, sdoh.OptimizationStartDateTime, sdoh.OptimizationDurationSeconds, sdoh.BeforeAvgFragmentationInPercent, 
               sdoh.AfterAvgFragmentationInPercent, sdoh.OptimizationMethod, sdasi.OnlineRebuildLastPerformedDateTime
FROM  StandardDatasetOptimizationHistory AS sdoh INNER JOIN
               StandardDatasetAggregationStorageIndex AS sdasi ON 
               sdoh.StandardDatasetAggregationStorageIndexRowId = sdasi.StandardDatasetAggregationStorageIndexRowId INNER JOIN
               StandardDatasetAggregationStorage AS sdas ON sdasi.StandardDatasetAggregationStorageRowId = sdas.StandardDatasetAggregationStorageRowId
WHERE sdoh.OptimizationStartDateTime >= DATEADD(DD,-1,GETDATE())
ORDER BY sdoh.OptimizationDurationSeconds DESC