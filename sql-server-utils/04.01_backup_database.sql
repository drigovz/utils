USE [master]

BACKUP DATABASE [Exemple]  
TO DISK = 'D:\dev\replication\database.bak'  
    WITH FORMAT,  
    MEDIANAME = 'scriptBackup',  
    NAME = 'Full Backup of [Exemple]';  
GO 
