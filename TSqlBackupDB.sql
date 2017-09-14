/** new **/
use master;
go
 
 
DECLARE UserDatabases_CTE_Cursor Cursor
FOR
 
-- Selecting user database names.
select name as DatabaseName
from sys.sysdatabases
where ([dbid] > 4) and ([name] not like '$')
AND [name] in (

'China-CF_LG_RES'
)

OPEN UserDatabases_CTE_Cursor
DECLARE @dbName varchar(100);
DECLARE @backupPath varchar(100);
DECLARE @backupQuery varchar(500);
 
-- make sure that the below path exists
set @backupPath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup\'
 
Fetch NEXT FROM UserDatabases_CTE_Cursor INTO @dbName
While (@@FETCH_STATUS <> -1)
 
BEGIN
-- Backup SQL statement
set @backupQuery =  'backup database ' + @dbName + ' to disk = ''' + @backupPath + @dbName + '_[' + REPLACE( convert(varchar, getdate(), 109), ':', '-') + '.bak'''
select replace(@backupQuery,'-','')
-- Print SQL statement
print @backupQuery
 
-- Execute backup script
EXEC (@backupQuery)
 
-- Get next database
Fetch NEXT FROM UserDatabases_CTE_Cursor INTO @dbName
END
 
CLOSE UserDatabases_CTE_Cursor
DEALLOCATE UserDatabases_CTE_Cursor
GO
