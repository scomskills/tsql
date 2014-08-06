/*
Check DW trend past 4 weeks
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/

/*
==============================================
Temp report parameters - for manual execution
==============================================
*/
DECLARE @MGID AS INT = 1,
@OffsetDays AS INT = 28


/*
======================================
Main report parameters
======================================
*/

DECLARE @DSID AS VARCHAR(max),
@DSID_ORDER AS INT

/*
=======================================
Create temporary table to hold all data
=======================================
*/

DECLARE @TuningReport TABLE (
DSID_ORDER INT,
DSID varchar(max),
Count bigint,
AggDate DateTime,
MonitorName varchar(max),
RuleName varchar(max),
MP varchar(max),
AlertName varchar(max),
EventId bigint,
PerfObject varchar(max),
PerfCounter varchar(max),
RepeatCount bigint)

/*
==================================
Number of Events Collected Per Day
==================================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Number of Events Collected Per Day'
SELECT @DSID_ORDER = 9
/*Perform the insert*/
INSERT INTO @TuningReport (AggDate, Count, DSID, DSID_ORDER)

SELECT CONVERT(VARCHAR(10), Event.vEvent.DateTime, 101) AS 'Date', COUNT(*) AS Count, @DSID, @DSID_ORDER
FROM  Event.vEvent INNER JOIN
Event.vEventRule ON Event.vEvent.EventOriginId = Event.vEventRule.EventOriginId INNER JOIN
vManagedEntity ON Event.vEventRule.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (Event.vEvent.DateTime BETWEEN getdate()-@OffsetDays AND dateadd(day,-1,getdate())) AND (vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY CONVERT(VARCHAR(10), Event.vEvent.DateTime, 101)
ORDER BY Date DESC


/*
==========================
Top 40 Performance Samples
==========================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Top 40 Performance Samples'
SELECT @DSID_ORDER = 5
/*Perform the insert*/
INSERT INTO @TuningReport (Count, PerfObject, PerfCounter, RuleName, MP, DSID, DSID_ORDER)

SELECT TOP (40) SUM(Perf.vPerfDaily.SampleCount) AS 'Count', vPerformanceRule.ObjectName AS 'Object', vPerformanceRule.CounterName AS 'Counter',
vRule.RuleDefaultName AS 'RuleName', vManagementPack.ManagementPackDefaultName AS 'MP', @DSID, @DSID_ORDER
FROM  Perf.vPerfDaily INNER JOIN
vPerformanceRuleInstance INNER JOIN
vPerformanceRule ON vPerformanceRuleInstance.RuleRowId = vPerformanceRule.RuleRowId INNER JOIN
vRule ON vPerformanceRule.RuleRowId = vRule.RuleRowId ON
Perf.vPerfDaily.PerformanceRuleInstanceRowId = vPerformanceRuleInstance.PerformanceRuleInstanceRowId INNER JOIN
vManagementPack ON vRule.ManagementPackRowId = vManagementPack.ManagementPackRowId INNER JOIN
vManagedEntity ON Perf.vPerfDaily.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (vManagementGroup.ManagementGroupRowId = @MGID) AND (Perf.vPerfDaily.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate()))
GROUP BY vPerformanceRule.ObjectName, vPerformanceRule.CounterName, vRule.RuleDefaultName, vManagementPack.ManagementPackDefaultName
ORDER BY Count DESC


/*
=====================================
Number of Performance Samples Per Day
=====================================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Number of Performance Samples Per Day'
SELECT @DSID_ORDER = 10
/*Perform the insert*/
INSERT INTO @TuningReport (AggDate, Count, DSID, DSID_ORDER)

SELECT Perf.vPerfDaily.DateTime AS 'Date', SUM(Perf.vPerfDaily.SampleCount) AS 'Count', @DSID, @DSID_ORDER
FROM  vManagedEntity INNER JOIN
Perf.vPerfDaily ON vManagedEntity.ManagedEntityRowId = Perf.vPerfDaily.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (vManagementGroup.ManagementGroupRowId = @MGID) AND (Perf.vPerfDaily.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate()))
group by Perf.vPerfDaily.DateTime
ORDER BY 'Date' DESC


/*
======================================
Number of State Change Events Per Day
======================================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Number of State Change Events Per Day'
SELECT @DSID_ORDER = 6
/*Perform the insert*/
INSERT INTO @TuningReport (AggDate, Count, DSID, DSID_ORDER)

SELECT State.vStateDaily.DateTime AS Date, COUNT(*) AS Count, @DSID, @DSID_ORDER
FROM  State.vStateDaily INNER JOIN
vManagedEntityMonitor ON State.vStateDaily.ManagedEntityMonitorRowId = vManagedEntityMonitor.ManagedEntityMonitorRowId INNER JOIN
vMonitor ON vManagedEntityMonitor.MonitorRowId = vMonitor.MonitorRowId INNER JOIN
vMonitorManagementPackVersion ON vManagedEntityMonitor.MonitorRowId = vMonitorManagementPackVersion.MonitorRowId INNER JOIN
vManagedEntity ON vManagedEntityMonitor.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (State.vStateDaily.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND getdate()) AND (vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY State.vStateDaily.DateTime
ORDER BY Date DESC

/*
============================================
Number of Unit Monitor State Changes Per Day
============================================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Number of Unit Monitor State Changes Per Day'
SELECT @DSID_ORDER = 7
/*Perform the insert*/
INSERT INTO @TuningReport (AggDate, Count, DSID, DSID_ORDER)

SELECT State.vStateDaily.DateTime AS Date, COUNT(*) AS Count, @DSID, @DSID_ORDER
FROM  State.vStateDaily INNER JOIN
vManagedEntityMonitor ON State.vStateDaily.ManagedEntityMonitorRowId = vManagedEntityMonitor.ManagedEntityMonitorRowId INNER JOIN
vMonitor ON vManagedEntityMonitor.MonitorRowId = vMonitor.MonitorRowId INNER JOIN
vMonitorManagementPackVersion ON vManagedEntityMonitor.MonitorRowId = vMonitorManagementPackVersion.MonitorRowId INNER JOIN
vManagedEntity ON vManagedEntityMonitor.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (vMonitorManagementPackVersion.UnitMonitorInd = 1) AND (State.vStateDaily.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND getdate()) AND (vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY State.vStateDaily.DateTime
ORDER BY Date DESC

/*
================================================================
Number of Dependency and Aggregate Monitor State Changes Per Day
================================================================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Number of Dependency and Aggregate Monitor State Changes Per Day'
SELECT @DSID_ORDER = 8
/*Perform the insert*/
INSERT INTO @TuningReport (AggDate, Count, DSID, DSID_ORDER)

SELECT State.vStateDaily.DateTime AS Date, COUNT(*) AS Count, @DSID, @DSID_ORDER
FROM  State.vStateDaily INNER JOIN
vManagedEntityMonitor ON State.vStateDaily.ManagedEntityMonitorRowId = vManagedEntityMonitor.ManagedEntityMonitorRowId INNER JOIN
vMonitor ON vManagedEntityMonitor.MonitorRowId = vMonitor.MonitorRowId INNER JOIN
vMonitorManagementPackVersion ON vManagedEntityMonitor.MonitorRowId = vMonitorManagementPackVersion.MonitorRowId INNER JOIN
vManagedEntity ON vManagedEntityMonitor.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId INNER JOIN
vManagementGroup ON vManagedEntity.ManagementGroupRowId = vManagementGroup.ManagementGroupRowId
WHERE (vMonitorManagementPackVersion.UnitMonitorInd = 0) AND (State.vStateDaily.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND getdate()) AND (vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY State.vStateDaily.DateTime
ORDER BY Date DESC

/*
===============================
Top 40 monitor generated alerts
===============================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Top 40 Monitor Generated Alerts'
SELECT @DSID_ORDER = 1
/*Perform the insert*/
INSERT INTO @TuningReport (Count, AlertName, MonitorName, MP, DSID, DSID_ORDER)

SELECT TOP (40) SUM(1) AS Count, Alert.vAlert.AlertName AS 'Alert', vMonitor.MonitorDefaultName AS 'Monitor',
vManagementPack.ManagementPackDefaultName AS 'MP', @DSID, @DSID_ORDER
FROM  vManagementGroup INNER JOIN
vManagedEntity ON vManagementGroup.ManagementGroupRowId = vManagedEntity.ManagementGroupRowId INNER JOIN
Alert.vAlert INNER JOIN
vManagementPack INNER JOIN
vMonitor ON vManagementPack.ManagementPackRowId = vMonitor.ManagementPackRowId ON Alert.vAlert.WorkflowRowId = vMonitor.MonitorRowId ON
vManagedEntity.ManagedEntityRowId = Alert.vAlert.ManagedEntityRowId
WHERE (Alert.vAlert.MonitorAlertInd = 1) AND (Alert.vAlert.RaisedDateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate())) AND
(vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY Alert.vAlert.AlertName, vMonitor.MonitorDefaultName, vManagementPack.ManagementPackDefaultName
ORDER BY Count DESC

/*
============================
Top 40 rule generated alerts
============================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Top 40 Rule Generated Alerts'
SELECT @DSID_ORDER = 2
/*Perform the insert*/
INSERT INTO @TuningReport (Count, AlertName, RuleName, MP, DSID, DSID_ORDER)

SELECT TOP (40) SUM(1) AS Count, Alert.vAlert.AlertName AS 'Alert', vRule.RuleDefaultName AS 'Rule', vManagementPack.ManagementPackDefaultName AS 'MP', @DSID, @DSID_ORDER
FROM  vRule INNER JOIN
Alert.vAlert INNER JOIN
vManagementGroup INNER JOIN
vManagedEntity ON vManagementGroup.ManagementGroupRowId = vManagedEntity.ManagementGroupRowId ON
Alert.vAlert.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId ON vRule.RuleRowId = Alert.vAlert.WorkflowRowId INNER JOIN
vManagementPack ON vRule.ManagementPackRowId = vManagementPack.ManagementPackRowId
WHERE (Alert.vAlert.MonitorAlertInd = 0) AND (Alert.vAlert.RaisedDateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate())) AND
(vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY Alert.vAlert.AlertName, vManagementPack.ManagementPackDefaultName, vRule.RuleDefaultName
ORDER BY Count DESC

/*
==============================
Top 40 Active Repeating Alerts
==============================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Top 40 Active Repeating Alerts'
SELECT @DSID_ORDER = 3
/*Perform the insert*/
INSERT INTO @TuningReport (Count, RepeatCount, AlertName, RuleName, MP, DSID, DSID_ORDER)

SELECT TOP (40) SUM(1) AS 'Count', SUM(RepeatCount) AS 'Repeat', Alert.vAlert.AlertName AS 'Alert', vRule.RuleDefaultName AS 'Rule', vManagementPack.ManagementPackDefaultName AS 'MP', @DSID, @DSID_ORDER
FROM  vRule INNER JOIN
Alert.vAlert INNER JOIN
vManagementGroup INNER JOIN
vManagedEntity ON vManagementGroup.ManagementGroupRowId = vManagedEntity.ManagementGroupRowId ON
Alert.vAlert.ManagedEntityRowId = vManagedEntity.ManagedEntityRowId ON vRule.RuleRowId = Alert.vAlert.WorkflowRowId INNER JOIN
vManagementPack ON vRule.ManagementPackRowId = vManagementPack.ManagementPackRowId
WHERE (Alert.vAlert.MonitorAlertInd = 0) AND (Alert.vAlert.RepeatCount <> 0) AND (Alert.vAlert.DWLastModifiedDateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate())) AND
(vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY Alert.vAlert.AlertName, vManagementPack.ManagementPackDefaultName, vRule.RuleDefaultName
ORDER BY Repeat DESC

/*
=======================
Top 40 Events Collected
=======================
*/

/*Assign a dataset Id*/
SELECT @DSID = 'Top 40 Events Collected'
SELECT @DSID_ORDER = 4
/*Perform the insert*/
INSERT INTO @TuningReport (Count, EventId, RuleName, MP, DSID, DSID_ORDER)

SELECT TOP (40) COUNT(*) AS 'Count', Event.vEvent.EventDisplayNumber AS 'Event', vRule.RuleDefaultName AS 'Rule',
vManagementPack.ManagementPackDefaultName AS 'MP', @DSID, @DSID_ORDER
FROM  vManagementGroup INNER JOIN
vManagedEntity ON vManagementGroup.ManagementGroupRowId = vManagedEntity.ManagementGroupRowId INNER JOIN
Event.vEventRule INNER JOIN
vRule ON Event.vEventRule.RuleRowId = vRule.RuleRowId INNER JOIN
Event.vEvent ON Event.vEventRule.EventOriginId = Event.vEvent.EventOriginId INNER JOIN
vManagementPack ON vRule.ManagementPackRowId = vManagementPack.ManagementPackRowId ON
vManagedEntity.ManagedEntityRowId = Event.vEventRule.ManagedEntityRowId
WHERE (Event.vEvent.DateTime BETWEEN dateadd(day,-1,getdate()-@OffsetDays) AND dateadd(day,-1,getdate())) AND (vManagementGroup.ManagementGroupRowId = @MGID)
GROUP BY Event.vEvent.EventDisplayNumber, vRule.RuleDefaultName, vManagementPack.ManagementPackDefaultName,
vManagementGroup.ManagementGroupRowId
ORDER BY 'Count' DESC



/*
===============
Select all data
===============
*/

SELECT *
FROM @TuningReport
ORDER BY DSID_ORDER, DSID, AggDate DESC