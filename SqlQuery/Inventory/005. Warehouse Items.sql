

Create proc spInsertMultipleWareHItems
@InvoiceID nvarchar(50),
@WarehouseItemList nvarchar(4000),
@EntryBy nvarchar(50)
as
begin

	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @WarehouseID as nvarchar(50)
	Declare @ItemID as nvarchar(50)
	Declare @ItemBalance as int

begin tran

	set @RestData=@WarehouseItemList
	while @RestData<>''
	begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @WarehouseID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @ItemID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @ItemBalance=convert(int,substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		exec spInsertWarehouseItems @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Invoice',@InvoiceID,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		exec spInsertBalTransferHistory @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Invoice',@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @WarehouseID=''
		Set @ItemID = ''
		Set @ItemBalance = 0
						
	end

	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

ALTER proc [dbo].[spInsertWarehouseItems]
@InvoiceID nvarchar(50),
@WarehouseID nvarchar(50),
@ItemID nvarchar(50),
@ItemBalance int,
@TransferType nvarchar(50),
@TransferedRef nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @WarehouseItemID nvarchar(50)
	Declare @CurrentWarehouseItemID numeric(18,0)
	Declare @WarehouseItemIDPrefix as nvarchar(7)

	set @WarehouseItemIDPrefix='WH-ITM-'
begin tran

	select @CurrentWarehouseItemID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentWarehouseItemID'
	
	set @CurrentWarehouseItemID=isnull(@CurrentWarehouseItemID,0)+1
	Select @WarehouseItemID=dbo.generateID(@WarehouseItemIDPrefix,@CurrentWarehouseItemID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblWarehouseItems(WarehouseItemID,InvoiceID,WarehouseID,ItemID,ItemBalance,TransferType,TransferedRef,EntryBy)
	Values(@WarehouseItemID,@InvoiceID,@WarehouseID,@ItemID,@ItemBalance,@TransferType,@TransferedRef,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	exec spInsertBalTransferHistory @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Procurement',@EntryBy
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=convert(nvarchar,@CurrentWarehouseItemID) where PropertyName='CurrentWarehouseItemID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end


GO

Create proc spGetWarehouseItemBalance
@WarehouseID nvarchar(50) 
as
begin
	Select WI.ItemID,I.ItemName as 'ItemName',I.ItemCode,U.UnitType,
	Sum(ItemBalance-AdjustedBalance) as 'Balance'
	from  tblWarehouseItems WI Left Join tblInventoryItems I On WI.ItemID=I.ItemID
	Left Join tblUnitType U On I.UnitTypeID=U.UnitTypeID
	Where WarehouseID=@WarehouseID
	group by WI.ItemID,I.ItemName,I.ItemCode,U.UnitType
end

GO

ALTER proc [dbo].[spWarehouseItemBalanceByItem]
@ItemID nvarchar(50)
as
begin
	Select WI.WarehouseID,W.WarehouseName,WI.ItemID,Sum( (WI.ItemBalance-WI.AdjustedBalance) ) as 'Balance'
	From tblWarehouseItems WI Left Join tblWarehouse W On WI.WarehouseID=W.WarehouseID
	Where WI.IsAdjusted=0 And WI.ItemID=@ItemID
	Group by WI.ItemID, WI.WarehouseID,W.WarehouseName
end