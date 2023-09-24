
sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1;  
RECONFIGURE; 
GO
sp_configure 'xp_cmdshell',1
RECONFIGURE;

exec master..xp_cmdshell 'dir C:\Access.mdb'

exec master..xp_cmdshell '\\192.168.100.150\ZKAccess3.5\Access.mdb'

EXECUTE MASTER.dbo.xp_enum_oledb_providers

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','\\192.168.100.150\ZKAccess3.5\Access.mdb', 'SELECT * FROM CHECKINOUT')

SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0','C:\Access.mdb', 'SELECT * FROM CHECKINOUT')

SELECT * From OpenRowset('Microsoft.Jet.OLEDB.4.0',';Data Source=\\192.168.100.150\ZKAccess3.5\Access.mdb;',
'SELECT * from CHECKINOUT') as b 

SELECT * From OpenRowset('Microsoft.Jet.OLEDB.4.0',';Database=C:\Access.mdb;',
'SELECT * from CHECKINOUT') as b 


EXEC master.dbo.sp_addlinkedserver
@server = N'AttendanceDB',
@srvproduct=N'Microsoft.ACE.OLEDB.12.0',
@provider=N'Microsoft.ACE.OLEDB.12.0',
@datasrc=N'C:\\Access.mdb'

EXEC master.dbo.sp_addlinkedserver
@server = N'AttendanceDB',
@srvproduct=N'Microsoft.ACE.OLEDB.12.0',
@provider=N'Microsoft.ACE.OLEDB.12.0',
@datasrc=N'\\192.168.100.150\ZKAccess3.5\Access.mdb'


USE [master] 
GO 
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 
GO 
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 
GO 

