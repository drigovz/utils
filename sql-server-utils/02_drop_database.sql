USE master
GO

IF EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'Stubydb'
)
DROP DATABASE Stubydb
GO