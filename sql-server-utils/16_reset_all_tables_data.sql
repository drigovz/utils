

-- desativa a integridade referencial
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

EXEC sp_MSForEachTable '
IF OBJECTPROPERTY(object_id(''?''), ''TableHasForeignRef'') = 1
DELETE FROM ?
else
TRUNCATE TABLE ?
'
GO

-- Reinicia o contador de chave primária de todas as tabelas
EXEC sp_MSForEachTable '
IF OBJECTPROPERTY(object_id(''?''), ''TableHasIdentity'') = 1
DBCC CHECKIDENT (''?'', RESEED, 0)
'
GO

-- reativa a integridade refencial
EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO