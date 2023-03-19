USE AdventureWorks2019
GO

-- select only ID 1, 2 and 10
SELECT * FROM Person.Person
WHERE BusinessEntityID IN(1, 2, 10)
GO

-- select all values except ID 1, 2 and 10
SELECT * FROM Person.Person
WHERE BusinessEntityID NOT IN(1, 2, 10)
GO