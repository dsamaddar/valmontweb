
Create proc spInsertUnitType
@UnitType nvarchar(200),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @UnitTypeID nvarchar(50)
	Declare @CurrentUnitTypeID numeric(18,0)
	Declare @UnitTypeIDPrefix as nvarchar(6)

	set @UnitTypeIDPrefix='U-TYP-'

begin tran
	
	select @CurrentUnitTypeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentUnitTypeID'
	
	set @CurrentUnitTypeID=isnull(@CurrentUnitTypeID,0)+1
	Select @UnitTypeID=dbo.generateID(@UnitTypeIDPrefix,@CurrentUnitTypeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblUnitType(UnitTypeID,UnitType,IsActive,EntryBy)
	Values(@UnitTypeID,@UnitType,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentUnitTypeID where PropertyName='CurrentUnitTypeID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc [dbo].[spUpdateUnitType]
@UnitTypeID nvarchar(50),
@UnitType nvarchar(200),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	
begin tran
	
	Update tblUnitType Set UnitType=@UnitType,IsActive=@IsActive,EntryBy=@EntryBy
	Where UnitTypeID=@UnitTypeID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spGetUnitTypeList
as
begin
	Select Distinct UnitTypeID,UnitType from tblUnitType Where IsActive=1 Order by UnitType 
end

GO

Create proc spShowDetailsUnitTypeList
as
begin
	Select Distinct UnitTypeID,UnitType,
	IsActive=Case IsActive When 1 Then 'Active' Else 'InActive' End,
	EntryBy,Convert(nvarchar,EntryDate,106) as 'EntryDate'
	from tblUnitType Order by UnitType
end