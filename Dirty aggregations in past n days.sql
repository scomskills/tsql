/*Dirty aggregations in past N days.
Update Days variable to desired number of days to go back.*/
DECLARE @Days AS int
SET @Days = 7
SELECT DS.DatasetDefaultName,
	CASE SDAH.AggregationTypeId
		WHEN 0 THEN 'Raw'
		WHEN 20 THEN 'Hourly'
		WHEN 30 THEN 'Daily'
		ELSE 'Unknown'
	END AS Type,
    SDAH.AggregationDateTime,
    DATEADD(HH, (datediff(HH, getutcdate(), getdate())), SDAH.AggregationDateTime) AS [LocalTime],
    SDAH.DirtyInd,
    SDAH.AggregationCount    
FROM Dataset AS DS INNER JOIN
    StandardDatasetAggregationHistory AS SDAH ON SDAH.DatasetId = DS.DatasetId
WHERE SDAH.DirtyInd <> 0 AND SDAH.AggregationDateTime > DATEADD(DD, -@Days, getdate())
ORDER BY SDAH.AggregationDateTime DESC, DS.DatasetDefaultName ASC, [Type] ASC