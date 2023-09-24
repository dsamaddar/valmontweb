GO

Insert Into tblAppSettings(PropertyName,PropertyValue)Values('CurrentStyleID',0)

GO

-- drop table tblStyles
Create table tblStyles(
StyleID nvarchar(50) primary key,
BuyerID nvarchar(50) foreign key references tblBuyer(BuyerID),
Style nvarchar(50) unique(Style),
Code nvarchar(50) unique(Code),
StyleDescription nvarchar(200),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spInsertStyle
@BuyerID nvarchar(50),
@Style nvarchar(50),
@Code nvarchar(50),
@StyleDescription nvarchar(200),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @StyleID nvarchar(50)
	Declare @CurrentStyleID numeric(18,0)
	Declare @StyleIDPrefix as nvarchar(4)

	set @StyleIDPrefix='STL-'

begin tran
	
	select @CurrentStyleID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentStyleID'
	
	set @CurrentStyleID=isnull(@CurrentStyleID,0)+1
	Select @StyleID=dbo.generateID(@StyleIDPrefix,@CurrentStyleID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblStyles(StyleID,BuyerID,Style,Code,StyleDescription,IsActive,EntryBy) 
	Values(@StyleID,@BuyerID,@Style,@Code,@StyleDescription,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentStyleID where PropertyName='CurrentStyleID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUpdateStyle
@StyleID nvarchar(50),
@BuyerID nvarchar(50),
@Style nvarchar(50),
@Code nvarchar(50),
@StyleDescription nvarchar(200),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblStyles Set BuyerID=@BuyerID,Style=@Style,Code=@Code,StyleDescription=@StyleDescription,IsActive=@IsActive,
	EntryBy=@EntryBy,EntryDate=GETDATE()
	Where StyleID=@StyleID
end

GO

/*
exec spInsertStyle 'EPISCOSE (H15 005)','EPISCOSE',1,'dsamaddar'
exec spInsertStyle 'EPIXEL','EPIXEL',1,'dsamaddar'
exec spInsertStyle '5618-4763(HDF-501)','HDF-501',1,'dsamaddar'
exec spInsertStyle '5618-4767(HDF-503)','HDF-503',1,'dsamaddar'
exec spInsertStyle 'MI1350DR','MI1350DR',1,'dsamaddar'
exec spInsertStyle 'MI1349DR','MI1349DR',1,'dsamaddar'
exec spInsertStyle 'FM15W 19MG','19MG',1,'dsamaddar'
exec spInsertStyle 'NIL -02(42158)','42158',1,'dsamaddar'
exec spInsertStyle 'NIL-01(42156)','42156',1,'dsamaddar'
exec spInsertStyle 'MI370 SS','MI370',1,'dsamaddar'
exec spInsertStyle 'MI368 SS','MI368',1,'dsamaddar'
*/

GO
-- drop proc spGetStyleList
alter proc spGetStyleInfo
as
begin
	Select StyleID,B.BuyerID,B.BuyerName as 'Buyer',Style,Code,StyleDescription,
	CASE IsActive WHEN 1 THEN 'YES' ELSE 'NO' END as 'IsActive',
	S.EntryBy,Convert(nvarchar,S.EntryDate,106) as 'EntryDate'
	from tblStyles S INNER JOIN tblBuyer B ON S.BuyerID = B.BuyerID
	order by Style
end

-- exec spGetStyleInfo

GO

Create proc spGetStyleInfoByBuyer
@BuyerID nvarchar(50)
as
begin
	Select StyleID,B.BuyerID,B.BuyerName as 'Buyer',Style,Code,StyleDescription,
	CASE IsActive WHEN 1 THEN 'YES' ELSE 'NO' END as 'IsActive',
	S.EntryBy,Convert(nvarchar,S.EntryDate,106) as 'EntryDate'
	from tblStyles S INNER JOIN tblBuyer B ON S.BuyerID = B.BuyerID
	Where S.BuyerID = @BuyerID
	order by Style
end







