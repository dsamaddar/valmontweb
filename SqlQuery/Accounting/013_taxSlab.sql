

Create table tblTaxSlab(
TaxSlabID int identity(1,1) primary key,
FromAmount numeric(18,2),
ToAmount numeric(18,2),
TaxPercentage numeric(5,2)
);

GO

Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(0,200000,0)
Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(200001,500000,1)
Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(500001,1500000,2.5)
Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(1500001,2500000,3.5)
Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(2500001,30000000,4)
Insert into tblTaxSlab(FromAmount,ToAmount,TaxPercentage)Values(30000001,999999999999,5)

GO

Select * from tblTaxSlab

GO
Create function fnGetTaxPercentage(@Amount as numeric(18,2))
returns numeric(5,2)
as
begin
	Declare @TaxPercentage as numeric(5,2)
	Select @TaxPercentage = TaxPercentage from tblTaxSlab Where @Amount between FromAmount And ToAmount
	
	return @TaxPercentage
end

Go

Select dbo.fnGetTaxPercentage(5000055)

GO

Create table tblTaxPayable(
TaxPayableID nvarchar(50) primary key,
ReferenceID nvarchar(50),
ReferenceType nvarchar(50),
TaxAmount numeric(18,2),
OnAmount numeric(18,2),
TaxPercentage numeric(5,2),
IsPaid bit default 0,
PaidAmount numeric(18,2),
LastPaymentDate datetime,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentTaxPayableID',0)

GO


alter proc spInsertTaxPayable
@ReferenceID nvarchar(50),
@ReferenceType nvarchar(50),
@TaxAmount numeric(18,2),
@OnAmount numeric(18,2),
@TaxPercentage numeric(5,2),
@EntryBy nvarchar(50)
as
begin
	Declare @TaxPayableID nvarchar(50)
	Declare @CurrentTaxPayableID numeric(18,0)
	Declare @TaxPayableIDPrefix as nvarchar(7)

	set @TaxPayableIDPrefix='INV-PH-'
	
begin tran
	
	select @CurrentTaxPayableID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentTaxPayableID'
	
	set @CurrentTaxPayableID=isnull(@CurrentTaxPayableID,0)+1
	Select @TaxPayableID=dbo.generateID(@TaxPayableIDPrefix,@CurrentTaxPayableID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblTaxPayable(TaxPayableID,ReferenceID,ReferenceType,TaxAmount,OnAmount,TaxPercentage,EntryBy)
	Values(@TaxPayableID,@ReferenceID,@ReferenceType,@TaxAmount,@OnAmount,@TaxPercentage,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentTaxPayableID where PropertyName='CurrentTaxPayableID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create table tblTaxPaymentHistory(
TaxPmntHistoryID nvarchar(50) primary key,
TaxPayableID nvarchar(50) foreign key references tblTaxPayable(TaxPayableID),
PaymentAmount numeric(18,2),
PaymentDate datetime,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO