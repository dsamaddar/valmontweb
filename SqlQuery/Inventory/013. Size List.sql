
-- drop table tblSize
Create table tblSize(
SizeID nvarchar(50) primary key,
Size nvarchar(50) unique(Size),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO


Create proc spInsertSize
@Size nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @SizeID nvarchar(50)
	Declare @CurrentSizeID numeric(18,0)
	Declare @SizeIDPrefix as nvarchar(3)

	set @SizeIDPrefix='SZ-'

begin tran
	
	select @CurrentSizeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentSizeID'
	
	set @CurrentSizeID=isnull(@CurrentSizeID,0)+1
	Select @SizeID=dbo.generateID(@SizeIDPrefix,@CurrentSizeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblSize(SizeID,Size,IsActive,EntryBy) Values(@SizeID,@Size,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentSizeID where PropertyName='CurrentSizeID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

exec spInsertSize 'XS',1,'dsamaddar'
exec spInsertSize 'S',1,'dsamaddar'
exec spInsertSize 'M',1,'dsamaddar'
exec spInsertSize 'L',1,'dsamaddar'
exec spInsertSize 'XL',1,'dsamaddar'
exec spInsertSize 'XXL',1,'dsamaddar'
exec spInsertSize '3XL',1,'dsamaddar'
exec spInsertSize '128',1,'dsamaddar'
exec spInsertSize '140',1,'dsamaddar'
exec spInsertSize '152',1,'dsamaddar'
exec spInsertSize '164',1,'dsamaddar'
exec spInsertSize '176',1,'dsamaddar'
exec spInsertSize '92',1,'dsamaddar'
exec spInsertSize '98',1,'dsamaddar'
exec spInsertSize '104',1,'dsamaddar'
exec spInsertSize '110',1,'dsamaddar'
exec spInsertSize '116',1,'dsamaddar'
exec spInsertSize '122',1,'dsamaddar'
exec spInsertSize '1',1,'dsamaddar'
exec spInsertSize '2',1,'dsamaddar'
exec spInsertSize '3',1,'dsamaddar'
exec spInsertSize '4',1,'dsamaddar'
exec spInsertSize '5',1,'dsamaddar'
exec spInsertSize '6',1,'dsamaddar'
exec spInsertSize '62(3M)',1,'dsamaddar'
exec spInsertSize '68(6M)',1,'dsamaddar'
exec spInsertSize '74(9M)',1,'dsamaddar'
exec spInsertSize '80(12M)',1,'dsamaddar'
exec spInsertSize '86(18M)',1,'dsamaddar'
exec spInsertSize '36',1,'dsamaddar'
exec spInsertSize '38',1,'dsamaddar'
exec spInsertSize '40',1,'dsamaddar'
exec spInsertSize '42',1,'dsamaddar'
exec spInsertSize '44',1,'dsamaddar'
exec spInsertSize '46',1,'dsamaddar'

GO


Create proc spGetSizeList
as
begin
	Select SizeID,Size from tblSize Where IsActive=1 order by Size
end