

CREATE TABLE tblAppSettings(
PropertyName nvarchar(50) primary key,
PropertyValue nvarchar(500)
)

GO

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentSectionID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentDesignationID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentEmployeeID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentBlockID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentProcessID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentStyleID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentSizeID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentProductionUnitID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentUploadFileID',0)


GO

Create function generateID(@Prefix nvarchar(50),@sl int, @Len int)
returns nvarchar(50)
as
begin
	Declare @SLen as int
	declare @GID as nvarchar(50)

	set @SLen = @Len - len(@sl)
	set @GID=''

	while @SLen>0
	begin
		set @GID=@GID+'0'
		set @SLen=@SLen-1
	end
	
	set @GID = @Prefix + @GID + convert(nvarchar,@sl)
	
	return @GID
end

GO

Create FUNCTION Split(@Delimiter varchar(5), @List varchar(8000) ) 
RETURNS @TableOfValues table 
(  [Value] varchar(50)   ) 
AS 
BEGIN

DECLARE @LenString int 

WHILE len( @List ) > 0 
 BEGIN 
 
    SELECT @LenString = 
       (CASE charindex( @Delimiter, @List ) 
           WHEN 0 THEN len( @List ) 
           ELSE ( charindex( @Delimiter, @List ) -1 )
        END
       ) 
                        
    INSERT INTO @TableOfValues 
       SELECT substring( @List, 1, @LenString )
        
    SELECT @List = 
       (CASE ( len( @List ) - @LenString ) 
           WHEN 0 THEN '' 
           ELSE right( @List, len( @List ) - @LenString - 1 ) 
        END
       ) 
 END
  
RETURN 

END 