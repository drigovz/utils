-- declare variable 
DECLARE @Existingdate DATETIME

-- set value to variable 
SET @Existingdate=GETUTCDATE()
SELECT @Existingdate
GO