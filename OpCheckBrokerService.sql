/*
Check broker service
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT is_broker_enabled FROM sys.databases WHERE name = 'OperationsManager';