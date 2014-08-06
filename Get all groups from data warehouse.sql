/*
Get all groups from Data Warehouse
*/
USE OperationsManagerDW
SELECT DISTINCT DisplayName
FROM vManagedEntity
WHERE ManagedEntityTypeRowId IN
	(SELECT ManagedEntityTypeRowId
	FROM dbo.ManagedEntityDerivedTypeHierarchy
		((SELECT ManagedEntityTypeRowId
		FROM vManagedEntityType
		WHERE ManagedEntityTypeSystemName = 'system.group'), 0))