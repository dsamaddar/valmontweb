
-- drop table tblProductionUnit
Create table tblProductionUnit(
ProductionUnitID nvarchar(50) primary key,
ProductionUnit nvarchar(50) unique(ProductionUnit),
StyleID nvarchar(50) foreign key references tblStyles(StyleID),
ProcessID nvarchar(50) foreign key references tblProcess(ProcessID),
SizeID nvarchar(50) foreign key references tblSize(SizeID),
RegularRate numeric(5,2),
OvertimeRate numeric(5,2),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spInsertProductionUnit
@ProductionUnit nvarchar(50),
@StyleID nvarchar(50),
@ProcessID nvarchar(50),
@SizeID nvarchar(50),
@RegularRate numeric(5,2),
@OvertimeRate numeric(5,2),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @ProductionUnitID nvarchar(50)
	Declare @CurrentProductionUnitID numeric(18,0)
	Declare @ProductionUnitIDPrefix as nvarchar(6)

	set @ProductionUnitIDPrefix='PRODU-'

begin tran
	
	select @CurrentProductionUnitID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentProductionUnitID'
	
	set @CurrentProductionUnitID=isnull(@CurrentProductionUnitID,0)+1
	Select @ProductionUnitID=dbo.generateID(@ProductionUnitIDPrefix,@CurrentProductionUnitID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblProductionUnit(ProductionUnitID,ProductionUnit,StyleID,ProcessID,SizeID,RegularRate,OvertimeRate,IsActive,EntryBy) 
	Values(@ProductionUnitID,@ProductionUnit,@StyleID,@ProcessID,@SizeID,@RegularRate,@OvertimeRate,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentProductionUnitID where PropertyName='CurrentProductionUnitID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateProductionUnit
@ProductionUnitID nvarchar(50),
@ProductionUnit nvarchar(50),
@StyleID nvarchar(50),
@ProcessID nvarchar(50),
@SizeID nvarchar(50),
@RegularRate numeric(5,2),
@OvertimeRate numeric(5,2),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin

begin tran

	Update tblProductionUnit Set ProductionUnit=@ProductionUnit,StyleID=@StyleID,ProcessID=@ProcessID,SizeID=@SizeID,
	RegularRate=@RegularRate,OvertimeRate=@OvertimeRate,IsActive=@IsActive,EntryBy=@EntryBy
	Where ProductionUnitID=@ProductionUnitID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spGetProductionUnitDetails
as
begin
	Select ProductionUnitID,ProductionUnit,PU.StyleID,ST.Style,PU.ProcessID,P.Process,PU.SizeID,SZ.Size,RegularRate,
	OvertimeRate,
	Case PU.IsActive When 1 Then 'YES' Else 'NO' End as 'IsActive',PU.EntryBy
	from tblProductionUnit PU Left Join tblStyles ST ON PU.StyleID = ST.StyleID
	Left Join tblProcess P ON PU.ProcessID = P.ProcessID
	Left Join tblSize SZ On PU.SizeID = SZ.SizeID
end

-- exec spGetProductionUnitDetails