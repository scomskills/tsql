/*
Check DW retention settings
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT Dataset.DatasetDefaultName AS Dataset, StandardDatasetAggregation.MaxDataAgeDays AS Days, 
	CASE StandardDatasetAggregation.AggregationTypeId WHEN 0 THEN 'Raw' WHEN 20 THEN 'Hourly' WHEN 30 THEN 'Daily' ELSE 'Unknown' END AS Type, 
	StandardDatasetAggregation.AggregationIntervalDurationMinutes AS AggInterval, StandardDatasetAggregation.GroomingIntervalMinutes AS GroomInterval, 
	StandardDatasetAggregation.MaxRowsToGroom, StandardDatasetAggregation.BuildAggregationStoredProcedureName AS SPROC 
FROM  Dataset INNER JOIN 
	StandardDatasetAggregation ON Dataset.DatasetId = StandardDatasetAggregation.DatasetId 
ORDER BY Dataset