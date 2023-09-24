
GO

Insert Into tblAppSettings(PropertyName,PropertyValue)Values('CurrentColorID',0)

GO

Create table tblColor(
ColorID nvarchar(50) primary key,
ColorName nvarchar(50) unique(ColorName),
IsActive bit default 1,
EntryBy nvarchar(50) default 'System',
EntryDate datetime default getdate()
);

GO

alter proc spGetColors
as
begin
	Select ColorID,ColorName,
	CASE IsActive WHEN 1 THEN 'YES' ELSE 'NO' END as 'IsActive',
	EntryBy,EntryDate 
	from tblColor
	order by ColorName
end

GO

GO


Create proc spInsertColor
@ColorName nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @ColorID nvarchar(50)
	Declare @CurrentColorID numeric(18,0)
	Declare @ColorIDPrefix as nvarchar(2)

	set @ColorIDPrefix='C-'

begin tran
	
	select @CurrentColorID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentColorID'
	
	set @CurrentColorID=isnull(@CurrentColorID,0)+1
	Select @ColorID=dbo.generateID(@ColorIDPrefix,@CurrentColorID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblColor(ColorID,ColorName,IsActive,EntryBy)
	Values(@ColorID,@ColorName,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentColorID where PropertyName='CurrentColorID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUpdateColor
@ColorID nvarchar(50),
@ColorName nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblColor Set ColorName=@ColorName,IsActive=@IsActive,EntryBy=@EntryBy
	Where ColorID = @ColorID
end