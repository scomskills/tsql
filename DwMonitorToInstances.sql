/*Monitor to Instances
Which instances does this monitor run on?
Replace @MonitorName variable with target monitor name.
jonathan@scomskills.com
8/8/2014*/
USE OperationsManagerDW
DECLARE @MonitorName AS NVARCHAR(MAX)
SET @MonitorName = 'Logical Disk Free Space'
SELECT vmon.MonitorDefaultName AS 'Monitor', vmet.ManagedEntityTypeDefaultName AS 'Monitor Target', vme.Path, vme.DisplayName AS 'Instance Name'
FROM vmon AS vmon INNER JOIN
    vmonManagementPackVersion AS vmmpv ON vmon.MonitorRowId = vmmpv.MonitorRowId INNER JOIN
    vTypedManagedEntity AS vtme ON vmmpv.TargetManagedEntityTypeRowId = vtme.ManagedEntityTypeRowId INNER JOIN
    vManagedEntity AS vme ON vtme.ManagedEntityRowId = vme.ManagedEntityRowId INNER JOIN
    vManagedEntityType AS vmet ON vtme.ManagedEntityTypeRowId = vmet.ManagedEntityTypeRowId
WHERE vmon.MonitorDefaultName = @MonitorName