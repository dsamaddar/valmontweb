
alter proc spGetSizeList
as
begin
	Select SizeID,Size,IsActive,EntryBy from tblSize Where IsActive=1 order by Size
end

GO

Create proc spUpdateSize
@SizeID nvarchar(50),
@Size nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblSize Set Size=@Size,IsActive=@IsActive, EntryBy=@EntryBy
	Where SizeID=@SizeID
end

GO


