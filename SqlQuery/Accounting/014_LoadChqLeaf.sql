
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentChqLeafID',0)

GO

CREATE TABLE tblLoadChqLeaf(
ChqLeafID nvarchar(50) primary key,
ChqNo nvarchar(50) ,
ReceivedDate datetime ,
IsChqVoid bit default 0,
ChqVoidRemarks nvarchar(500) ,
ChqVoidBy nvarchar(50) ,
BankID nvarchar(50) foreign key references tblBank(BankID),
BankAccountID nvarchar(50) foreign key references tblBankAccount(BankAccountID),
IsPrinted bit default 0,
PrintedAmount numeric(18, 2) ,
PrintDate datetime ,
PrintBy nvarchar(50) ,
Reference nvarchar(50) ,
ReferenceType nvarchar(50) ,
ChequeEntryPoint nvarchar(50) ,
EntryBy nvarchar(50) ,
EntryDate datetime default getdate()
);
GO

alter proc spGetAvailableChqsByBankID
@BankID nvarchar(50),
@BankAccountID nvarchar(50)
as
begin
	Select ChqLeafID,ChqNo from tblLoadChqLeaf LC Where BankID=@BankID And BankAccountID=@BankAccountID
	and IsChqVoid=0 And IsPrinted=0 
	And not exists (Select distinct ChqLeafID  from tblOutgoingCheque OC Where OC.ChqLeafID=LC.ChqLeafID)
end
-- exec spGetAvailableChqsByBankID 'Bank-00000008','BAC00000003'

GO

alter proc spGetAvailableChqsByAccID
@BankAccountID nvarchar(50)
as
begin
	Select LC.ChqLeafID,LC.ChqNo from tblLoadChqLeaf LC Where LC.BankAccountID=@BankAccountID
	and LC.IsChqVoid=0 And LC.IsPrinted=0 
	And not exists (Select distinct ChqLeafID  from tblOutgoingCheque OC Where OC.ChqLeafID=LC.ChqLeafID)
end
-- exec spGetAvailableChqsByAccID 'BAC00000003' 

GO

Create proc spGetAvailableChqEntryPoint
as
begin
	Select Distinct ChequeEntryPoint from tblLoadChqLeaf
	Where IsChqVoid=0 And IsPrinted=0
end

GO

-- drop proc spUpdateLastIDForAppSettings
Create proc spUpdateLastIDForAppSettings
@PropertyName nvarchar(50),
@PropertyValue numeric(18,0)
as
begin
	Update tblAppSetting set PropertyValue=@PropertyValue where PropertyName=@PropertyName
end

GO

alter proc spGetAvailableChqsByChqEntryPoint
@ChequeEntryPoint nvarchar(50)
as
begin
	Select LC.ChqLeafID,LC.ChqNo, Convert(nvarchar,LC.ReceivedDate,106) as ReceivedDate,
	(Select BankName from tblBank where BankID=LC.BankID) as BankName,
	(Select AccountNo from tblBankAccount Where BankAccountID= LC.BankAccountID) as 'AccountNo'
	from tblLoadChqLeaf LC Where LC.ChequeEntryPoint=@ChequeEntryPoint and LC.IsChqVoid=0 And LC.IsPrinted=0
end

