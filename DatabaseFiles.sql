/*
Check database files
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT a.FILEID, 
[FILE_SIZE_MB]=convert(decimal(12,2),round(a.size/128.000,2)), 
[SPACE_USED_MB]=convert(decimal(12,2),round(fileproperty(a.name,'SpaceUsed')/128.000,2)), 
[FREE_SPACE_MB]=convert(decimal(12,2),round((a.size-fileproperty(a.name,'SpaceUsed'))/128.000,2)) , 
[GROWTH_MB]=convert(decimal(12,2),round(a.growth/128.000,2)), 
NAME=left(a.NAME,15), 
FILENAME=left(a.FILENAME,60) 
from dbo.sysfiles a