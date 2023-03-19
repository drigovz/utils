USE AdventureWorks2019
GO

-- select all person that name init with ovi
SELECT * FROM Person.Person
WHERE FirstName LIKE 'ovi%'
GO

-- select all person that name finish with to
SELECT * FROM Person.Person
WHERE FirstName LIKE '%to'
GO

-- select all person that have ber on his name
SELECT * FROM Person.Person
WHERE FirstName LIKE '%ber%'
GO