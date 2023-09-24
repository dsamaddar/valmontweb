
GO

Insert Into tblAppSettings(PropertyName,PropertyValue)Values('CurrentOrderID',0)

GO

Create table tblOrder(
OrderID nvarchar(50) primary key,
BuyerID nvarchar(50) foreign key references tblBuyer(BuyerID),
StyleID nvarchar(50) foreign key references tblStyles(StyleID),
OrderQuantity int,
OrderDate date,
DeliveryDate date,
OrderDetails nvarchar(500),
EntryBy nvarchar(50) default 'System',
EntryDate datetime default getdate()
);

GO

alter proc spGetOrderInfo
as
begin
	Select OrderID,O.BuyerID,B.BuyerName as 'Buyer',O.StyleID,S.Style,OrderQuantity,
	Convert(nvarchar,OrderDate,106) as 'OrderDate',Convert(nvarchar,DeliveryDate,106) as 'DeliveryDate',
	OrderDetails,O.EntryBy,Convert(nvarchar,O.EntryDate,106) as 'EntryDate'
	From tblOrder O INNER JOIN tblBuyer B ON O.BuyerID=B.BuyerID
	INNER JOIN tblStyles S ON O.StyleID=S.StyleID
end

-- exec spGetOrderInfo

GO

Create proc spInsertOrder
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@OrderQuantity int,
@OrderDate date,
@DeliveryDate date,
@OrderDetails nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	Declare @OrderID nvarchar(50)
	Declare @CurrentOrderID numeric(18,0)
	Declare @OrderIDPrefix as nvarchar(2)

	set @OrderIDPrefix='O-'

begin tran
	
	select @CurrentOrderID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentOrderID'
	
	set @CurrentOrderID=isnull(@CurrentOrderID,0)+1
	Select @OrderID=dbo.generateID(@OrderIDPrefix,@CurrentOrderID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblOrder(OrderID,BuyerID,StyleID,OrderQuantity,OrderDate,DeliveryDate,OrderDetails,EntryBy)
	Values(@OrderID,@BuyerID,@StyleID,@OrderQuantity,@OrderDate,@DeliveryDate,@OrderDetails,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentOrderID where PropertyName='CurrentOrderID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateOrder
@OrderID nvarchar(50),
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@OrderQuantity int,
@OrderDate date,
@DeliveryDate date,
@OrderDetails nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	update tblOrder Set BuyerID=@BuyerID,StyleID=@StyleID,OrderQuantity=@OrderQuantity,OrderDate=@OrderDate,
	DeliveryDate=@DeliveryDate,OrderDetails=@OrderDetails,EntryBy=@EntryBy,EntryDate=GETDATE()
	Where OrderID=@OrderID
end