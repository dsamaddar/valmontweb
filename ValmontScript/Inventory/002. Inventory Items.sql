GO
-- drop table tblInventoryItems
CREATE TABLE tblInventoryItems(
ItemID nvarchar(50) primary key,
BuyerID nvarchar(50) foreign key references tblBuyer(BuyerID),
StyleID nvarchar(50) foreign key references tblStyles(StyleID),
ColorID nvarchar(50) foreign key references tblColor(ColorID),
ParentItemID nvarchar(50) foreign key references tblInventoryItems(ItemID),
ItemName nvarchar(200) unique(ItemName),
ItemCode nvarchar(200) NULL,
UnitTypeID nvarchar(50) NULL,
LowBalanceReport int NULL,
MaxAllowableRequisition int NULL,
IsActive bit NULL,
EntryBy nvarchar(50) NULL,
EntryDate datetime NULL
);

GO



GO

Create proc spGetItemList
as
begin
	Select Distinct I.ItemID,( ItemName + ' ( ' +isnull((Select UnitType from tblUnitType U Where U.UnitTypeID=I.UnitTypeID),'N\A')  + ' ) ' ) as 'ItemName'
	from tblInventoryItems I Where IsActive=1
	Order by ItemName
end


GO

alter proc spGetItemListDetails
as
begin
	Select ItemID,ISNULL(BuyerID,'N\A') as 'BuyerID',ISNULL(StyleID,'N\A') as 'StyleID',
	ISNULL(ColorID,'N\A') as 'ColorID',ISNULL(ParentItemID,'N\A') as 'ParentItemID',ItemName,ItemCode,UnitTypeID,
	(Select UnitType from tblUnitType U Where U.UnitTypeID=I.UnitTypeID) as 'UnitType',
	LowBalanceReport,MaxAllowableRequisition,
	IsActive=Case IsActive When 1 Then 'Active' Else 'InActive' End,
	EntryBy,Convert(nvarchar,EntryDate,106) as 'EntryDate' From tblInventoryItems I
	order by ItemCode
end

GO

alter proc spInsertInventoryItems
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@ColorID nvarchar(50),
@ParentItemID nvarchar(50),
@ItemName nvarchar(200),
@ItemCode nvarchar(200),
@UnitTypeID nvarchar(50),
@LowBalanceReport int,
@MaxAllowableRequisition int,
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @ItemID nvarchar(50)
	Declare @CurrentItemID numeric(18,0)
	Declare @ItemIDPrefix as nvarchar(4)

	set @ItemIDPrefix='ITM-'

begin tran

	if @BuyerID = 'N\A'
		Set @BuyerID = NULL

	if @StyleID = 'N\A'
		Set @StyleID = NULL;

	if @ColorID = 'N\A'
		Set @ColorID = NULL;

	if @ParentItemID = 'N\A'
		Set @ParentItemID = NULL;

	select @CurrentItemID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentItemID'
	
	set @CurrentItemID=isnull(@CurrentItemID,0)+1
	Select @ItemID=dbo.generateID(@ItemIDPrefix,@CurrentItemID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblInventoryItems(ItemID,BuyerID,StyleID,ColorID,ParentItemID,ItemName,ItemCode,UnitTypeID,LowBalanceReport,MaxAllowableRequisition,IsActive,EntryBy)
	Values(@ItemID,@BuyerID,@StyleID,@ColorID,@ParentItemID,@ItemName,@ItemCode,@UnitTypeID,@LowBalanceReport,@MaxAllowableRequisition,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentItemID where PropertyName='CurrentItemID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateInventoryItems
@ItemID nvarchar(50),
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@ColorID nvarchar(50),
@ParentItemID nvarchar(50),
@ItemName nvarchar(200),
@ItemCode nvarchar(200),
@UnitTypeID nvarchar(50),
@LowBalanceReport int,
@MaxAllowableRequisition int,
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	
begin tran

	Update tblInventoryItems Set BuyerID=@BuyerID,StyleID=@StyleID,ColorID=@ColorID,ParentItemID=@ParentItemID,
	ItemName=@ItemName,ItemCode=@ItemCode,UnitTypeID=@UnitTypeID,
	LowBalanceReport=@LowBalanceReport,MaxAllowableRequisition=@MaxAllowableRequisition,IsActive=@IsActive,
	EntryBy=@EntryBy
	Where ItemID=@ItemID
	
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

-- exec spGenerateItemName 'N\A','N\A','N\A','ITM-00000073'
-- exec spGenerateItemName 'B-00000001','N\A','N\A','ITM-00000073'

alter proc spGenerateItemName
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@ColorID nvarchar(50),
@ParentItemID nvarchar(50)
as
begin

	Declare @Buyer as nvarchar(50) Set @Buyer = ''
	Declare @Color as nvarchar(50) Set @Color= ''
	Declare @ItemName as nvarchar(200) Set @ItemName = ''
	Declare @Style as nvarchar(200) Set @Style = ''
	Declare @NewItemName as nvarchar(200) Set @ItemName = ''

	if @BuyerID <> 'N\A'
		Select @Buyer = BuyerName from tblBuyer Where BuyerID=@BuyerID
	else
		Set @Buyer = ''

	If @ParentItemID <> 'N\A'
		Select @ItemName=ItemName from tblInventoryItems Where ItemID=@ParentItemID
	else
		Set @ItemName = '';

	if @StyleID <> 'N\A'
		Select @Style=Code from tblStyles Where StyleID=@StyleID
	else
		Set @Style = '';

	if @ColorID <> 'N\A'
		Select @Color=ColorName from tblColor Where ColorID=@ColorID
	else
		Set @Color = ''

	Set @NewItemName = @ItemName + '-' + @Buyer + '-' + @Style + '-' + @Color

	Select @NewItemName as 'ItemName'
	
end