USE AdventureWorks2019
GO

-- ascendent
SELECT TOP 20 * FROM Person.Person
ORDER BY ModifiedDate ASC 
GO

-- descending
SELECT TOP 20 * FROM Person.Person
ORDER BY ModifiedDate DESC 
GO

-- ordening with many coluns
SELECT TOP 20 * FROM Person.Person
ORDER BY FirstName ASC, LastName  DESC 
GO