
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentVoucherID',0)
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentVoucherNo',1000000)

GO

alter proc spGetCurrentVoucherNo
as
begin
	Declare @CurrentVoucherNo as numeric(18,0) Set @CurrentVoucherNo = 0
	select @CurrentVoucherNo = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentVoucherNo'
	set @CurrentVoucherNo=isnull(@CurrentVoucherNo,0)+1

	Select @CurrentVoucherNo as 'CurrentVoucherNo'
end

GO
-- drop table tblVoucher
Create table tblVoucher(
VoucherID nvarchar(50) primary key,
VoucherNo nvarchar(50) unique(VoucherNo),
EventName nvarchar(100),
TransactionDate date,
SystemDate date,
Narration nvarchar(500),
IsPosted bit default 1,
IsApproved bit default 0,
ApprovedBy nvarchar(50),
ApprovalDate datetime,
ApproverRemarks nvarchar(500),
IsRejected bit default 0,
RejectedBy nvarchar(50),
RejectionDate datetime,
RejectionRemarks nvarchar(500),
VoucherStatus nvarchar(50),
EntryBy nvarchar(50),
EntryDate datetime default getdate(),
);

GO

Create proc spGetPendingTransactions
as
begin
	Select VoucherID,VoucherNo,TransactionDate,Narration from tblVoucher 
	Where IsPosted = 1 And IsApproved = 0 And IsRejected = 0
end

GO

Create proc spAuthorizeTransaction
@VoucherID nvarchar(50),
@VoucherStatus char(1),
@Narration nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	If @VoucherStatus = 'R'
	begin
		Update tblVoucher Set VoucherStatus=@VoucherStatus,IsRejected=1,RejectedBy=@EntryBy,
		RejectionDate=GETDATE(),RejectionRemarks=@Narration
		Where VoucherID = @VoucherID
	end
	else
	begin
		Update tblVoucher Set VoucherStatus=@VoucherStatus,IsApproved=1,ApprovedBy=@EntryBy,
		ApprovalDate=GETDATE(),ApproverRemarks=@Narration
		Where VoucherID = @VoucherID
	end
end

GO
--exec spInsertVoucher '1000001','Manual Voucher','3/24/2018','3/24/2018','abc','L-00000118~D~500,000.00~0.00~.~|L-00000037~C~0.00~500,000.00~.~|','sunil'

alter proc spInsertVoucher
@VoucherNo nvarchar(50),
@EventName nvarchar(100),
@TransactionDate datetime,
@SystemDate datetime,
@Narration nvarchar(500),
@VoucherDetails nvarchar(MAX),
@EntryBy nvarchar(50)
as
begin
	Declare @VoucherID nvarchar(50)
	Declare @CurrentVoucherID numeric(18,0)
	Declare @VoucherIDPrefix as nvarchar(2)

	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @LedgerID as nvarchar(50) Set @LedgerID = ''
	Declare @TransactionType as nvarchar(50) Set @TransactionType = ''
	Declare @Debit as numeric(18,2) Set @Debit = 0
	Declare @Credit as numeric(18,2) Set @Credit = 0
	Declare @Reference as nvarchar(50) Set @Reference = ''
	Declare @ReferenceType as nvarchar(50) Set @ReferenceType = ''
	Declare @EntryNo as int Set @EntryNo = 1

	set @VoucherIDPrefix='V-'

begin tran
	
	select @CurrentVoucherID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentVoucherID'
	
	set @CurrentVoucherID=isnull(@CurrentVoucherID,0)+1
	Select @VoucherID=dbo.generateID(@VoucherIDPrefix,@CurrentVoucherID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblVoucher(VoucherID,VoucherNo,EventName,TransactionDate,SystemDate,Narration,VoucherStatus,EntryBy)
	Values(@VoucherID,@VoucherNo,@EventName,@TransactionDate,GETDATE(),@Narration,'U',@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	

	Set @RestData=@VoucherDetails
	While @RestData<>''
	Begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		Print 'A'
		set @Index=CHARINDEX('~',@RestPortion)		
		set @LedgerID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		Print @LedgerID
		set @Index=CHARINDEX('~',@RestPortion)		
		set @TransactionType=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))
		print @TransactionType
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @Debit=convert(numeric(18,2),substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		set @Index=CHARINDEX('~',@RestPortion)		
		set @Credit=convert(numeric(18,2),substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		set @Index=CHARINDEX('~',@RestPortion)		
		set @Reference=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))

		set @Index=CHARINDEX('~',@RestPortion)		
		set @ReferenceType=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		--Print @ItemID+'-'+convert(nvarchar,@Quantity)+'-' + convert(nvarchar,@UnitPrice)
		exec spInsertVoucherDetails @VoucherID,@EntryNo,@LedgerID,@TransactionType,@Debit,@Credit,@Reference,@ReferenceType
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		Set @Debit = 0
		Set @Credit = 0
		Set @LedgerID = ''
		Set @TransactionType = ''
		Set @Reference = ''
		Set @ReferenceType = ''
		Set @EntryNo = @EntryNo + 1

	end
	
	update tblAppSettings set PropertyValue=@CurrentVoucherID where PropertyName='CurrentVoucherID'
	update tblAppSettings set PropertyValue=Convert(nvarchar,@VoucherNo) where PropertyName='CurrentVoucherNo'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentVoucherDetailsID',0)

GO
-- drop table tblVoucherDetails
Create table tblVoucherDetails(
VoucherDetailsID nvarchar(50) primary key,
VoucherID nvarchar(50) foreign key references tblVoucher(VoucherID),
EntryNo int,
LedgerID nvarchar(50) foreign key references tblChartOfAccounts(LedgerID),
TransactionType char(1),
Debit numeric(18,2),
Credit numeric(18,2),
Reference nvarchar(50),
ReferenceType nvarchar(50),
);

GO

Create proc spGetTransactionDetails
@VoucherID nvarchar(50)
as
begin
	Select EntryNo,C.LedgerName + ' ('+ C.LedgerCode+')' as 'LedgerName',VD.TransactionType,VD.Debit,VD.Credit,VD.Reference
	from tblVoucherDetails VD INNER JOIN tblChartOfAccounts C ON VD.LedgerID = C.LedgerID
	Where VoucherID = @VoucherID
end

GO

alter proc spInsertVoucherDetails
@VoucherID nvarchar(50),
@EntryNo int,
@LedgerID nvarchar(50),
@TransactionType char(1),
@Debit numeric(18,0),
@Credit numeric(18,0),
@Reference nvarchar(50),
@ReferenceType nvarchar(50)
as
begin
	Declare @VoucherDetailsID nvarchar(50)
	Declare @CurrentVoucherDetailsID numeric(18,0)
	Declare @VoucherDetailsIDPrefix as nvarchar(3)

	set @VoucherDetailsIDPrefix='VD-'

begin tran
	
	select @CurrentVoucherDetailsID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentVoucherDetailsID'
	
	set @CurrentVoucherDetailsID=isnull(@CurrentVoucherDetailsID,0)+1
	Select @VoucherDetailsID=dbo.generateID(@VoucherDetailsIDPrefix,@CurrentVoucherDetailsID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblVoucherDetails(VoucherDetailsID,VoucherID,EntryNo,LedgerID,TransactionType,Debit,Credit,Reference,ReferenceType)
	Values(@VoucherDetailsID,@VoucherID,@EntryNo,@LedgerID,@TransactionType,@Debit,@Credit,@Reference,@ReferenceType)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentVoucherDetailsID where PropertyName='CurrentVoucherDetailsID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end