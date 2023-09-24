
Insert Into tblAppSettings(PropertyName,PropertyValue) Values('CurrentRateSetupID',0);

GO


Create table tblRateSetup(
RateSetupID nvarchar(50) primary key,
BuyerID nvarchar(50) foreign key references tblBuyer(BuyerID),
OrderID nvarchar(50) foreign key references tblOrder(OrderID),
StyleID nvarchar(50) foreign key references tblStyles(StyleID),
SizeID nvarchar(50) foreign key references tblSize(SizeID),
ColorID nvarchar(50) foreign key references tblColor(ColorID),
ComponentID nvarchar(50) foreign key references tblComponents(ComponentID),
Rate numeric(18,5),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO
-- exec spGetRateSetupList
alter proc spGetRateSetupList
as
begin
	Select R.RateSetupID,R.BuyerID,B.BuyerName,R.OrderID,O.OrderNumber,R.StyleID,S.Style,
	R.SizeID,SZ.Size,R.ColorID,C.ColorName,R.ComponentID,CP.ComponentName,R.Rate,R.EntryBy,R.EntryDate
	from tblRateSetup R
	left outer join tblBuyer B ON R.BuyerID = B.BuyerID
	left outer join tblOrder O ON R.OrderID = O.OrderID
	left outer join tblStyles S ON R.StyleID = S.StyleID
	left outer join tblSize SZ ON R.SizeID = SZ.SizeID
	left outer join tblColor C ON R.ColorID = C.ColorID
	left outer join tblComponents CP ON R.ComponentID = CP.ComponentID
	order by R.BuyerID,R.OrderID,R.StyleID,R.SizeID,R.ColorID,R.ComponentID
end

GO

Create proc spUpdateRateSetup
@RateSetupID nvarchar(50),
@BuyerID nvarchar(50),
@OrderID nvarchar(50),
@StyleID nvarchar(50),
@SizeID nvarchar(50),
@ColorID nvarchar(50),
@ComponentID nvarchar(50),
@Rate numeric(18,5),
@EntryBy nvarchar(50)
as
begin
	Update tblRateSetup Set BuyerID=@BuyerID,OrderID=@OrderID,StyleID=@StyleID,SizeID=@SizeID,
	ColorID=@ColorID,ComponentID=@ComponentID,Rate=@Rate
	Where RateSetupID=@RateSetupID
end

GO

Create proc spInsertRateSetup
@BuyerID nvarchar(50),
@OrderID nvarchar(50),
@StyleID nvarchar(50),
@SizeID nvarchar(50),
@ColorID nvarchar(50),
@ComponentID nvarchar(50),
@Rate numeric(18,5),
@EntryBy nvarchar(50)
as
begin
	Declare @RateSetupID nvarchar(50)
	Declare @CurrentRateSetupID numeric(18,0)
	Declare @RateSetupIDPrefix as nvarchar(5)

	set @RateSetupIDPrefix='RATE-'

begin tran
	
	select @CurrentRateSetupID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentRateSetupID'
	
	set @CurrentRateSetupID=isnull(@CurrentRateSetupID,0)+1
	Select @RateSetupID=dbo.generateID(@RateSetupIDPrefix,@CurrentRateSetupID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblRateSetup(RateSetupID,BuyerID,OrderID,StyleID,SizeID,ColorID,ComponentID,Rate,EntryBy)
	Values(@RateSetupID,@BuyerID,@OrderID,@StyleID,@SizeID,@ColorID,@ComponentID,@Rate,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentRateSetupID where PropertyName='CurrentRateSetupID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end
