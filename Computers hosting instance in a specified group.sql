/*
Return Health Service instances hosting one or more instances contained in specified group.
Update SET argument with group name in question.
*/
USE OperationsManagerDW
DECLARE @GroupName AS varchar(max)
SET @GroupName = 'All Windows Computers'
SELECT vManagedEntity.DisplayName AS Computer
FROM  vManagedEntity INNER JOIN
	vManagedEntityType ON vManagedEntity.ManagedEntityTypeRowId = vManagedEntityType.ManagedEntityTypeRowId
WHERE vManagedEntity.TopLevelHostManagedEntityRowId IN
	(SELECT DISTINCT ME1.TopLevelHostManagedEntityRowId
		FROM vManagedEntity AS ME2 INNER JOIN
		vRelationship ON ME2.ManagedEntityRowId = vRelationship.SourceManagedEntityRowId INNER JOIN
		vManagedEntity AS ME1 ON vRelationship.TargetManagedEntityRowId = ME1.ManagedEntityRowId
		WHERE (ME2.DisplayName = @GroupName))
	AND vManagedEntityType.ManagedEntityTypeSystemName = 'Microsoft.SystemCenter.HealthService'
ORDER BY Computer