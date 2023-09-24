GO

Insert Into tblAppSettings(PropertyName,PropertyValue)Values('CurrentBuyerID',0)

GO

Create table tblBuyer(
BuyerID nvarchar(50) primary key,
BuyerName nvarchar(100) unique(BuyerName),
Country nvarchar(50),
BuyerAddress nvarchar(500),
ContactPerson nvarchar(50),
ContactNo nvarchar(50),
EmailAddress nvarchar(50),
Fax nvarchar(50),
MerchandizerID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
EntryBy nvarchar(50) default 'System',
EntryDate datetime default getdate()
);

GO
-- drop proc spGetBuyerInfo
alter proc spGetBuyerInfo
as
begin
	Select BuyerID,BuyerName,Country,BuyerAddress,ContactPerson,ContactNo,EmailAddress,Fax,
	MerchandizerID,EI.EmployeeName as 'Merchandizer',B.EntryBy,Convert(nvarchar,B.EntryDate,106) as 'EntryDate'
	from tblBuyer B INNER JOIN tblEmployeeInfo EI ON B.MerchandizerID = EI.EmployeeID
	Order By BuyerName
end

GO

Create proc spInsertBuyer
@BuyerName nvarchar(100),
@Country nvarchar(50),
@BuyerAddress nvarchar(500),
@ContactPerson nvarchar(50),
@ContactNo nvarchar(50),
@EmailAddress nvarchar(50),
@Fax nvarchar(50),
@MerchandizerID nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @BuyerID nvarchar(50)
	Declare @CurrentBuyerID numeric(18,0)
	Declare @BuyerIDPrefix as nvarchar(2)

	set @BuyerIDPrefix='B-'

begin tran
	
	select @CurrentBuyerID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBuyerID'
	
	set @CurrentBuyerID=isnull(@CurrentBuyerID,0)+1
	Select @BuyerID=dbo.generateID(@BuyerIDPrefix,@CurrentBuyerID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblBuyer(BuyerID,BuyerName,Country,BuyerAddress,ContactPerson,ContactNo,EmailAddress,Fax,MerchandizerID,EntryBy)
	Values(@BuyerID,@BuyerName,@Country,@BuyerAddress,@ContactPerson,@ContactNo,@EmailAddress,@Fax,@MerchandizerID,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentBuyerID where PropertyName='CurrentBuyerID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUpdateBuyer
@BuyerID nvarchar(50),
@BuyerName nvarchar(100),
@Country nvarchar(50),
@BuyerAddress nvarchar(500),
@ContactPerson nvarchar(50),
@ContactNo nvarchar(50),
@EmailAddress nvarchar(50),
@Fax nvarchar(50),
@MerchandizerID nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Update tblBuyer Set BuyerName=@BuyerName,Country=@Country,BuyerAddress=@BuyerAddress,ContactPerson=@ContactPerson,
	ContactNo=@ContactNo,EmailAddress=@EmailAddress,Fax=@Fax,MerchandizerID=@MerchandizerID,EntryBy=@EntryBy,EntryDate=GETDATE()
	Where BuyerID=@BuyerID
end