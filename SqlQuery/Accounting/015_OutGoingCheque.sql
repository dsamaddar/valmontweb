
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentOutgoingCheque',0)

GO

-- drop table tblOutgoingCheque
CREATE TABLE tblOutgoingCheque(
OutChequeID nvarchar(50) primary key,
ChequeName nvarchar(200),
ChequeAmount numeric(18, 2),
BankID nvarchar(50),
ChequeDate datetime,
ChqLeafID nvarchar(50) foreign key references tblLoadChqLeaf(ChqLeafID),
PrintDate datetime ,
PrintBy nvarchar(50) ,
isPosted bit default 0,
HonouredDate datetime,
PostedBy nvarchar(50),
PostedDate datetime,
Reference nvarchar(50),
ReferenceType nvarchar(50)
);

GO

-- Select * from tblOutgoingCheque


alter proc spInsertOutgoingCheque
@ChequeName nvarchar(200),
@ChequeAmount numeric(18, 2),
@BankID nvarchar(50),
@ChequeDate datetime,
@ChqLeafID nvarchar(50),
@Reference nvarchar(50),
@ReferenceType nvarchar(50)
as
begin
	Declare @OutChequeID nvarchar(50)
	Declare @CurrentOutChequeID numeric(18,0)
	Declare @OutChequeIDPrefix as nvarchar(5)

	set @OutChequeIDPrefix='OCHQ-'
	
begin tran
	
	select @CurrentOutChequeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentOutgoingCheque'
	
	set @CurrentOutChequeID=isnull(@CurrentOutChequeID,0)+1
	Select @OutChequeID=dbo.generateID(@OutChequeIDPrefix,@CurrentOutChequeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblOutgoingCheque(OutChequeID,ChequeName,ChequeAmount,BankID,ChequeDate,ChqLeafID,Reference,ReferenceType)
	Values(@OutChequeID,@ChequeName,@ChequeAmount,@BankID,@ChequeDate,@ChqLeafID,@Reference,@ReferenceType)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentOutChequeID where PropertyName='CurrentOutgoingCheque'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end


