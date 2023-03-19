USE AdventureWorks2019
GO

-- select with conditions 
SELECT * FROM Person.Person
WHERE MiddleName = 'M'
GO

-- bigger than 
SELECT * FROM Person.Person
WHERE EmailPromotion > 1
GO

-- lass than 
SELECT * FROM Person.Person
WHERE EmailPromotion < 1
GO

-- bigger than or equal
SELECT * FROM Person.Person
WHERE EmailPromotion >= 2 
GO

-- lass than or equal
SELECT * FROM Person.Person
WHERE EmailPromotion <= 1 
GO

-- different
SELECT * FROM Person.Person
WHERE EmailPromotion <> 0 
GO

-- and 
SELECT * FROM Person.Person
WHERE EmailPromotion <> 0 AND Title = 'Ms.'
GO

-- or 
SELECT *
FROM Person.Person
WHERE EmailPromotion <> 1
    AND FirstName = 'Janice' OR FirstName = 'Wanida'
GO