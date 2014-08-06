/*
Modified properties past 24 hours
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2015
*/
SELECT DISTINCT MP.ManagementPackSystemName, MET.ManagedEntityTypeSystemName, PropertySystemName, 
	ISNULL(ME.Path, ME.Name) as Entity, C.OldValue, C.NewValue, C.ChangeDateTime
FROM vManagedEntityPropertyChange AS C INNER JOIN
	vManagedEntity AS ME ON ME.ManagedEntityRowId = C.ManagedEntityRowId INNER JOIN
	vManagedEntityTypeProperty AS METP ON METP.PropertyGuid = C.PropertyGuid INNER JOIN
	vManagedEntityType AS MET ON MET.ManagedEntityTypeRowId = ME.ManagedEntityTypeRowId INNER JOIN
	vManagementPack AS MP ON MP.ManagementPackRowId = MET.ManagementPackRowId INNER JOIN
	vManagementPackVersion AS MPV ON MPV.ManagementPackRowId = MP.ManagementPackRowId LEFT OUTER JOIN
	vDiscoveryManagementPackVersion AS DMP ON DMP.ManagementPackVersionRowId = MPV.ManagementPackVersionRowId AND 
	CAST(DefinitionXml.query('data(/Discovery/DiscoveryTypes/DiscoveryClass/@TypeID)') AS nvarchar(MAX)) 
	LIKE '%' + MET.ManagedEntityTypeSystemName + '%' LEFT OUTER JOIN
	vManagedEntityType AS MET1 ON MET1.ManagedEntityTypeRowId = DMP.TargetManagedEntityTypeRowId LEFT OUTER JOIN
	vDiscovery AS D ON D.DiscoveryRowId = DMP.DiscoveryRowId
WHERE ChangeDateTime > DATEADD(hh, - 24, getutcdate()) AND
	C.OldValue IS NOT NULL AND MP.ManagementPackSystemName <> 'Microsoft.Windows.Library'