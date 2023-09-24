
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentBillServiceID',0)

GO

-- drop table tblBillServices
Create table tblBillServices(
BillServiceID nvarchar(50) primary key,
ServiceName nvarchar(200) unique(ServiceName),
LedgerID nvarchar(50) foreign key references tblChartOfAccounts(LedgerID),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate(),
);

GO

alter proc spShowBillServices
as
begin
	Select distinct BS.BillServiceID ,BS.ServiceName,isnull(BS.LedgerID,'N\A') as 'LedgerID',
	(Select LedgerName from tblChartOfAccounts COA Where COA.LedgerID=BS.LedgerID) as 'Ledger',
	Case When IsActive=1 Then 'Yes' Else 'No' End as 'Active',
	EntryBy 
	from tblBillServices BS
end

-- exec spShowBillServices

GO

Create proc spUpdateBillServices
@BillServiceID nvarchar(50),
@ServiceName nvarchar(200),
@LedgerID nvarchar(50),
@IsActive bit
as
begin
	Update tblBillServices Set ServiceName=@ServiceName,LedgerID=@LedgerID,IsActive=@IsActive
	Where BillServiceID=@BillServiceID
end

GO


alter proc spInsertBillServices
@ServiceName nvarchar(200),
@LedgerID nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin

	Declare @BillServiceID nvarchar(50)
	Declare @CurrentBillServiceID numeric(18,0)
	Declare @BillServiceIDPrefix as nvarchar(10)

	set @BillServiceIDPrefix='BILL-SERV-'
begin tran

	if @LedgerID = 'N\A'
	begin
		Set @LedgerID = null
	end
	
	select @CurrentBillServiceID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBillServiceID'
	
	set @CurrentBillServiceID=isnull(@CurrentBillServiceID,0)+1
	Select @BillServiceID=dbo.generateID(@BillServiceIDPrefix,@CurrentBillServiceID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblBillServices(BillServiceID,ServiceName,LedgerID,IsActive,EntryBy)
	Values(@BillServiceID,@ServiceName,@LedgerID,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentBillServiceID where PropertyName='CurrentBillServiceID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

