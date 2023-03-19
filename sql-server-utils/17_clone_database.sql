exemple de criação de um clone do banco de dados 
USE [master];
GO

-- the original database (use 'SET @DB = NULL' to disable backup)
DECLARE @OriginalDatabaseName varchar(200)
DECLARE @OriginalDatabaseLogicalName varchar(200)
DECLARE @OriginalDatabaseLogicalNameForLog varchar(200)
DECLARE @query varchar(2000)
DECLARE @DataFile varchar(2000)
DECLARE @LogFile varchar(2000)
DECLARE @BackupFile varchar(2000)
DECLARE @CloneDatabaseName varchar(200)
DECLARE @CloneDatabaseFolder varchar(2000)

SET @OriginalDatabaseName = '[Exemple]'                 -- Name of the source database
SET @OriginalDatabaseLogicalName = 'Exemple'            -- Logical name of the DB ( check DB properties / Files tab )
SET @OriginalDatabaseLogicalNameForLog = 'Exemple_log'  -- Logical name of the DB ( check DB properties / Files tab )
SET @BackupFile = 'D:\dev\replication\exemple.dat'      -- FileName of the backup file
SET @CloneDatabaseName = 'Exemple_Clone'                -- Name of the target database
SET @CloneDatabaseFolder = 'D:\dev\replication\'

SET @DataFile = @CloneDatabaseFolder + @CloneDatabaseName + '.mdf';
SET @LogFile = @CloneDatabaseFolder + @CloneDatabaseName + '.ldf';

-- Backup the @SourceDatabase to @BackupFile location
IF @OriginalDatabaseName IS NOT NULL
BEGIN
SET @query = 'BACKUP DATABASE ' + @OriginalDatabaseName + ' TO DISK = ' + QUOTENAME(@BackupFile,'''')
PRINT 'Executing query : ' + @query;
EXEC (@query)
END
PRINT 'OK!';

-- Drop @CloneDatabaseName if exists
IF EXISTS(SELECT * FROM sysdatabases WHERE name = @CloneDatabaseName)
BEGIN
SET @query = 'DROP DATABASE ' + @CloneDatabaseName
PRINT 'Executing query : ' + @query;
EXEC (@query)
END
PRINT 'OK!'

-- Restore database from @BackupFile into @DataFile and @LogFile
SET @query = 'RESTORE DATABASE ' + @CloneDatabaseName + ' FROM DISK = ' + QUOTENAME(@BackupFile,'''') 
SET @query = @query + ' WITH MOVE ' + QUOTENAME(@OriginalDatabaseLogicalName,'''') + ' TO ' + QUOTENAME(@DataFile ,'''')
SET @query = @query + ' , MOVE ' + QUOTENAME(@OriginalDatabaseLogicalNameForLog,'''') + ' TO ' + QUOTENAME(@LogFile,'''')
PRINT 'Executing query : ' + @query
EXEC (@query)
PRINT 'OK!'