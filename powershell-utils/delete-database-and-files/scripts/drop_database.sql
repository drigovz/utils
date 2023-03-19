USE [master]
GO

DECLARE @dbName AS VARCHAR(100) = $(db);

DECLARE @query AS VARCHAR(max) = '
ALTER DATABASE ' + @dbName + '
SET OFFLINE WITH ROLLBACK IMMEDIATE

IF EXISTS (
   SELECT [name]
   FROM sys.databases
   WHERE [name] = N''' + @dbName + '''
)
DROP DATABASE [' + @dbName + ']
';

EXEC (@query);