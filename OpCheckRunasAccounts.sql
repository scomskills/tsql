/*
Check OP Run-As Account
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT BME.DisplayName, CMSS.UserName, CMSS.Domain, CMSS.Type
FROM SecureStorageSecureReference AS SSSR INNER JOIN
	CredentialManagerSecureStorage AS CMSS ON CMSS.securestorageelementID = SSSR.securestorageelementID INNER JOIN
	BaseManagedEntity AS BME ON BME.BaseManagedEntityId = SSSR.HealthServiceId INNER JOIN
	MT_HealthService AS HS ON HS.BaseManagedEntityId = BME.BaseManagedEntityId
WHERE HS.IsManagementServer = 1 and CMSS.Type = 1