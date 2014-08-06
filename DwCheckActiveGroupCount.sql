/*
Check DW active group count
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT COUNT(DISTINCT vManagedEntity.DisplayName) AS 'Group Count'
FROM  vManagedEntity INNER JOIN
               vManagedEntityManagementGroup ON vManagedEntity.ManagedEntityRowId = vManagedEntityManagementGroup.ManagedEntityRowId
WHERE (vManagedEntity.ManagedEntityTypeRowId IN
                   (SELECT ManagedEntityTypeRowId
                    FROM   dbo.ManagedEntityDerivedTypeHierarchy
                                       ((SELECT ManagedEntityTypeRowId
                                         FROM   vManagedEntityType
                                         WHERE (ManagedEntityTypeSystemName = 'system.group')), 0) AS ManagedEntityDerivedTypeHierarchy_1)) AND 
               (vManagedEntityManagementGroup.ToDateTime IS NULL)