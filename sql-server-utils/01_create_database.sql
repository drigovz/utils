USE master
GO

IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'Studydb'
)
CREATE DATABASE Studydb
GO