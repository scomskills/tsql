/*
Check OP management packs
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT FriendlyName, Name, Version, Sealed, TimeCreated
FROM ManagementPackView
ORDER BY FriendlyName
