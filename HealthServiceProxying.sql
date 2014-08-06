/*
Health Service Proxying
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT BME.Path, HS.ProxyingEnabled, HS.IsGateway, HS.IsManagementServer
FROM  MT_HealthService AS HS INNER JOIN
	BaseManagedEntity AS BME ON HS.BaseManagedEntityId = BME.BaseManagedEntityId
WHERE (HS.ProxyingEnabled <> 1 OR HS.ProxyingEnabled IS NULL)