USE AdventureWorks2019
GO

-- get all registers
SELECT * FROM Person.Person
GO

SELECT FirstName, LastName, PersonType
FROM Person.Person
GO

-- get total of registers 
SELECT COUNT(BusinessEntityID) AS Total
FROM Person.Person
GO

-- concat data
SELECT CONCAT(FirstName, ' ', LastName) AS Name
FROM Person.Person
GO

-- select only unique values, without duplications 
SELECT DISTINCT FirstName 
FROM Person.Person
GO

-- select the 20 first registers
SELECT TOP 20 * FROM Person.Person
GO





















