USE [master]
GO

DECLARE @databaseName AS VARCHAR(max) = 'database_name';

DECLARE @query AS VARCHAR(max);
SET @query = '
ALTER DATABASE ' + @databaseName + '
SET OFFLINE WITH ROLLBACK IMMEDIATE

IF EXISTS (
   SELECT [name]
   FROM sys.databases
   WHERE [name] =  ' + 'N'''+ @databaseName + '''' + '
)
DROP DATABASE ' + @databaseName + '
';

EXEC (@query);