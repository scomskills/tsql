/*Get recursive group membership.
Update GroupDisplayName with desired group.
Update other variables based on requirement.
http://blog.scomskills.com/get-recursive-group-membership
*/
USE OperationsManagerDW
DECLARE @GroupDisplayName as varchar(max) = 'All Operations Manager Objects Group',
	@LevelCount as int = 1,
	@StartLevel as int = 1,
	@ObjectListDate as datetime = getutcdate(),
	@ObjectList as xml
SET @ObjectList = '<Data><Objects><Object Use="Containment">' + convert(varchar,(
		SELECT ManagedEntityRowId 
		FROM vManagedEntity 
		WHERE displayName = @GroupDisplayName)) + '</Object></Objects></Data>'
CREATE TABLE #ObjectList (ManagedEntityRowId int)
INSERT INTO #ObjectList (ManagedEntityRowId)
EXEC [Microsoft_SystemCenter_DataWarehouse_Report_Library_ReportObjectListParse]
	@ObjectList = @ObjectList,
	@StartDate = @ObjectListDate,
	@EndDate = @ObjectListDate,
	@ContainmentLevelCount = @LevelCount,
	@ContainmentStartLevel = @StartLevel
SELECT ISNULL(vme.Path,vme.DisplayName) AS DisplayName, ManagedEntityDefaultName
FROM vManagedEntity as vme inner join
    #ObjectList on #ObjectList.ManagedEntityRowId = vme.ManagedEntityRowId
DROP TABLE #ObjectList
