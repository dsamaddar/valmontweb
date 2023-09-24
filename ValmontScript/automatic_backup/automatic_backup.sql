
alter PROCEDURE spAutoBackupDataBases
       @databaseName sysname = null
AS
begin
SET NOCOUNT ON;
    DECLARE @DBs TABLE (
      ID int IDENTITY PRIMARY KEY,
      DBNAME nvarchar(500)
    )

INSERT INTO @DBs (DBNAME)
SELECT Name FROM master.sys.databases WHERE state=0 AND name=@DatabaseName OR @DatabaseName IS NULL ORDER BY Name

-- Declare variables
DECLARE @BackupName varchar(100)
DECLARE @BackupFile varchar(100)
DECLARE @DBNAME varchar(300)
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @dateTime NVARCHAR(20)
DECLARE @backupLocation nvarchar(200) SET @backupLocation = 'D:\DBBackup\'

-- Database Names have to be in [dbname] format since some have - or _ in their name
SET @DBNAME = @databaseName;

-- Set the current date and time n yyyyhhmmss format
SET @dateTime = convert(nvarchar,getdate(),112);

-- Create backup filename in pathfilename.extension format for full,diff and log backups
SET @BackupFile = @backupLocation+REPLACE(REPLACE(@DBNAME, '[',''),']','')+ '_'+ @dateTime+ '.BAK'

-- Provide the backup a name for storing in the media
SET @BackupName = REPLACE(REPLACE(@DBNAME,'[',''),']','') +' full backup for '+ @dateTime

-- Generate the dynamic SQL command to be executed
SET @sqlCommand = 'BACKUP DATABASE ' +@DBNAME+  ' TO DISK = '''+@BackupFile+ ''' WITH INIT, NAME= ''' +@BackupName+''', NOSKIP, NOFORMAT'

-- Execute the generated SQL command
EXEC(@sqlCommand);
END

