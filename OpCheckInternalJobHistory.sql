/*
Check OP internal jog history
Jonathan Almquist (jonathan@scomskills.com)
Updated 02-23-2014
*/
SELECT TimeStarted, TimeFinished, StatusCode, Command
FROM  InternalJobHistory
ORDER BY TimeStarted DESC