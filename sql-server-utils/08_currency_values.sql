USE AdventureWorks2019
GO

-- get money on USA format 
SELECT TOP 100
    FORMAT(UnitPrice, 'C', 'en-us') AS 'Currency USA Format'
FROM Sales.SalesOrderDetail
GO

-- get money on Brazil/Real format 
SELECT TOP 100
    FORMAT(UnitPrice, 'C', 'pt-br') AS 'Currency Brazil Format'
FROM Sales.SalesOrderDetail
GO 