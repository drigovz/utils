USE AdventureWorks2019
GO

SELECT * FROM Sales.SalesOrderDetail
WHERE UnitPrice BETWEEN 10.00 AND 100.00
GO

-- list prices that are not between 10 and 100
SELECT * FROM Sales.SalesOrderDetail
WHERE UnitPrice NOT BETWEEN 10.00 AND 100.00
GO

-- dates between 1990 and 1999
SELECT * FROM HumanResources.Employee
WHERE BirthDate BETWEEN '1990-01-01' AND '1999-01-01'
GO