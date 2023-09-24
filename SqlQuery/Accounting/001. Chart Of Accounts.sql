
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentLedgerTypeID',0)

GO

Create table tblLedgerType(
LedgerTypeID nvarchar(50) primary key,
LedgerType nvarchar(200) unique(LedgerType),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

Create proc spGetLedgerTypeList
as
begin
	Select Distinct LedgerType,LedgerTypeID from tblLedgerType order by LedgerType 
end

GO

Create proc spInsertLedgerType
@LedgerType nvarchar(200),
@EntryBy nvarchar(50)
as
begin
	Declare @LedgerTypeID nvarchar(50)
	Declare @CurrentLedgerTypeID numeric(18,0)
	Declare @LedgerTypeIDPrefix as nvarchar(4)

	set @LedgerTypeIDPrefix='LTYP-'

begin tran
	
	select @CurrentLedgerTypeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentLedgerTypeID'
	
	set @CurrentLedgerTypeID=isnull(@CurrentLedgerTypeID,0)+1
	Select @LedgerTypeID=dbo.generateID(@LedgerTypeIDPrefix,@CurrentLedgerTypeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblLedgerType(LedgerTypeID,LedgerType,EntryBy)
	Values(@LedgerTypeID,@LedgerType,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentLedgerTypeID where PropertyName='CurrentLedgerTypeID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentLedgerID',0)

GO

-- drop table tblChartOfAccounts
Create table tblChartOfAccounts(
LedgerID nvarchar(50) primary key,
LedgerTypeID nvarchar(50) foreign key references tblLedgerType(LedgerTypeID),
LedgerName nvarchar(200),
ParentLedgerID nvarchar(50) foreign key references tblChartOfAccounts(LedgerID),
LedgerCode nvarchar(50)  unique(LedgerCode),
IsBankAccount bit default 0,
BalanceType nvarchar(50),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

Create proc spGetLedgerHeadList
as
begin
	Select Distinct LedgerID,LedgerName+' ( '+LedgerCode+' )' as 'LedgerName' from tblChartOfAccounts 
	order by LedgerName 
end

GO

Create proc spInsertLedger
@LedgerTypeID nvarchar(50),
@LedgerName nvarchar(200),
@ParentLedgerID nvarchar(50),
@LedgerCode nvarchar(50),
@IsBankAccount bit,
@BalanceType nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @LedgerID nvarchar(50)
	Declare @CurrentLedgerID numeric(18,0)
	Declare @LedgerIDPrefix as nvarchar(2)

	set @LedgerIDPrefix='L-'
	
	if @ParentLedgerID = 'N\A'
		Set @ParentLedgerID = null

begin tran
	
	select @CurrentLedgerID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentLedgerID'
	
	set @CurrentLedgerID=isnull(@CurrentLedgerID,0)+1
	Select @LedgerID=dbo.generateID(@LedgerIDPrefix,@CurrentLedgerID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblChartOfAccounts(LedgerID,LedgerTypeID,LedgerName,ParentLedgerID,LedgerCode,IsBankAccount,BalanceType,EntryBy)
	Values(@LedgerID,@LedgerTypeID,@LedgerName,@ParentLedgerID,@LedgerCode,@IsBankAccount,@BalanceType,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentLedgerID where PropertyName='CurrentLedgerID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

