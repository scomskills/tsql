/*List primary and failover management servers for agents*/
USE OperationsManager
SELECT rgv.SourceObjectPath AS [Agent], rgv.TargetObjectPath AS [ManagementServer], 
	CASE
		WHEN rtv.DisplayName = 'Health Service Communication' THEN 'Primary'
		ELSE 'Failover'
	END AS [Type]
FROM ManagedTypeView mt INNER JOIN
	ManagedEntityGenericView AS meg ON meg.MonitoringClassId = mt.Id INNER JOIN
	RelationshipGenericView rgv ON rgv.SourceObjectId = meg.Id INNER JOIN
	RelationshipTypeView rtv ON rtv.Id = rgv.RelationshipId
WHERE mt.Name = 'Microsoft.SystemCenter.Agent' AND
	rtv.Name like 'Microsoft.SystemCenter.HealthService%Communication' AND
	rgv.IsDeleted = 0
ORDER BY rgv.SourceObjectPath ASC, rtv.DisplayName ASC