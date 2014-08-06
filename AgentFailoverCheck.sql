/*
Agent Failover Configuration
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2015
*/
SELECT rgv.SourceObjectPath AS [Agent], count(*) AS [Count]
FROM ManagedTypeView mt INNER JOIN
	ManagedEntityGenericView AS meg ON meg.MonitoringClassId = mt.Id INNER JOIN
	RelationshipGenericView rgv ON rgv.SourceObjectId = meg.Id INNER JOIN
	RelationshipTypeView rtv ON rtv.Id = rgv.RelationshipId
WHERE mt.Name = 'Microsoft.SystemCenter.Agent' AND
	rtv.Name like 'Microsoft.SystemCenter.HealthService%Communication' AND
	rgv.IsDeleted = 0
GROUP BY rgv.SourceObjectPath
HAVING count(*) <> 2