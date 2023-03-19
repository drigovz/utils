
-- skip and take - paginations
SELECT * FROM [TableName]
ORDER BY Id
OFFSET 10 ROWS          -- skip 10 rows
FETCH NEXT 10 ROWS ONLY -- take 10 rows only 