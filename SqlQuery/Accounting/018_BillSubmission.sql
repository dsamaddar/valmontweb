
Select * from tblSupplier 
Select * from tblProjects 
select * from tblUsers 

Select * from tblBillInfo
Select * from tblBillServices 

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentBillInfoID',0)

GO

Create table tblBillInfo(
BillInfoID nvarchar(50) primary key,
SupplierID nvarchar(50) foreign key references tblSupplier(SupplierID),
BillNo nvarchar(200),
BillDate datetime,
ProjectID nvarchar(50) foreign key references tblProjects(ProjectID),
PaymentMode nvarchar(100),
RequestedBy nvarchar(50) foreign key references tblUsers(UniqueUserID),
Approver nvarchar(50) foreign key references tblUsers(UniqueUserID),
IsApproved bit default 0,
ApprovedDate datetime,
BillAmount numeric(18,2),
Attachment nvarchar(200),
Remarks nvarchar(200),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentBillDetailsID',0)

-- drop table tblBillDetails
Create table tblBillDetails(
BillDetailsID nvarchar(50) primary key,
BillInfoID nvarchar(50) foreign key references tblBillInfo(BillInfoID),
BillServiceID nvarchar(50) foreign key references tblBillServices(BillServiceID),
Cost numeric(18,2),
Remarks nvarchar(500)
);

GO

SElect * from tblBillDetails

GO

Create proc spGetBillDetailsByID
@BillInfoID nvarchar(50)
as
begin
	Select B.BillServiceID,(Select ServiceName from tblBillServices BS Where BS.BillServiceID=B.BillServiceID) as 'ServiceName',
	B.Cost,B.Remarks from tblBillDetails B Where B.BillInfoID=@BillInfoID
end

GO

alter proc spInsertMultipleBillDetails
@BillDetailsList nvarchar(4000),
@BillInfoID nvarchar(50)
as
begin

	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)
	
	Declare @BillServiceID as nvarchar(50)
	Declare @Cost as numeric(18,2)
	Declare @Remarks as nvarchar(500)

begin tran

	set @RestData=@BillDetailsList
	while @RestData<>''
	begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @BillServiceID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @Cost= convert(float,substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @Remarks=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))
		
		exec spInsertBillDetails @BillInfoID,@BillServiceID,@Cost,@Remarks
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		Set @BillServiceID=''
		Set @Cost = 0
		Set @Remarks=''
						
	end
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spInsertBillDetails
@BillInfoID nvarchar(50),
@BillServiceID nvarchar(50),
@Cost numeric(18,2),
@Remarks nvarchar(500)
as
begin

	Declare @BillDetailsID nvarchar(50)
	Declare @CurrentBillDetailsID numeric(18,0)
	Declare @BillDetailsIDPrefix as nvarchar(7)
	
	Set @BillDetailsIDPrefix = 'BILL-D-'

begin tran

	select @CurrentBillDetailsID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBillDetailsID'
	
	set @CurrentBillDetailsID=isnull(@CurrentBillDetailsID,0)+1
	Select @BillDetailsID=dbo.generateID(@BillDetailsIDPrefix,@CurrentBillDetailsID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblBillDetails(BillDetailsID,BillInfoID,BillServiceID,Cost,Remarks)
	Values(@BillDetailsID,@BillInfoID,@BillServiceID,@Cost,@Remarks)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentBillDetailsID where PropertyName='CurrentBillDetailsID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spShowBillInfo
@IsApproved bit
as
begin
	Select B.BillInfoID,B.SupplierID,
	(Select SupplierName from tblSupplier S Where S.SupplierID=B.SupplierID) as 'Supplier',	
	B.BillNo,Convert(nvarchar,B.BillDate,106) as 'BillDate',isnull(B.ProjectID,'N\A') as 'ProjectID',
	(Select ProjectName from tblProjects P Where P.ProjectID=B.ProjectID) as 'Project',
	B.PaymentMode,isnull(B.RequestedBy,'N\A') as 'RequestedByID',
	(Select UserName from tblUsers U Where U.UniqueUserID=B.RequestedBy) as 'RequestedBy',
	isnull(B.Approver,'N\A') as 'ApproverID',
	isnull((Select UserName from tblUsers U Where U.UniqueUserID=B.Approver),'N\A') as 'Approver',
	Case B.IsApproved When 1 Then 'YES' Else 'NO' End as 'IsApproved',
	isnull(Convert(nvarchar,B.ApprovedDate,106),'N\A') as 'ApprovedDate',
	B.BillAmount,B.Attachment,B.Remarks,B.EntryBy,Convert(nvarchar,B.EntryDate,106) as 'EntryDate'
	from tblBillInfo B
	Where IsApproved=@IsApproved
end

-- exec spShowBillInfo 0

GO

alter proc spInsertBillInfo
@SupplierID nvarchar(50),
@BillNo nvarchar(200),
@BillDate datetime,
@ProjectID nvarchar(50),
@PaymentMode nvarchar(100),
@RequestedBy nvarchar(50),
@Approver nvarchar(50),
@BillAmount numeric(18,2),
@Attachment nvarchar(200),
@Remarks nvarchar(200),
@BillDetailsList nvarchar(4000),
@EntryBy nvarchar(50)
as
begin

	Declare @BillInfoID nvarchar(50)
	Declare @CurrentBillInfoID numeric(18,0)
	Declare @BillInfoIDPrefix as nvarchar(5)
	Declare @IsApproved as bit 

	set @BillInfoIDPrefix='BILL-'

	if @Approver='N\A'
	begin
		Set @Approver = null
		Set @IsApproved = 1
	end
	else
	begin
			Set @IsApproved = 0
	end

	if @RequestedBy = 'N\A'
		Set @RequestedBy = null
	
begin tran

	select @CurrentBillInfoID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBillInfoID'
	
	set @CurrentBillInfoID=isnull(@CurrentBillInfoID,0)+1
	Select @BillInfoID=dbo.generateID(@BillInfoIDPrefix,@CurrentBillInfoID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblBillInfo(BillInfoID,SupplierID,BillNo,BillDate,ProjectID,PaymentMode,RequestedBy,Approver,BillAmount,Attachment,Remarks,EntryBy)
	Values(@BillInfoID,@SupplierID,@BillNo,@BillDate,@ProjectID,@PaymentMode,@RequestedBy,@Approver,@BillAmount,@Attachment,@Remarks,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	exec spInsertMultipleBillDetails @BillDetailsList,@BillInfoID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	update tblAppSettings set PropertyValue=@CurrentBillInfoID where PropertyName='CurrentBillInfoID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateBillInfo
@BillInfoID nvarchar(50),
@SupplierID nvarchar(50),
@BillNo nvarchar(200),
@BillDate datetime,
@ProjectID nvarchar(50),
@PaymentMode nvarchar(100),
@RequestedBy nvarchar(50),
@Approver nvarchar(50),
@BillAmount numeric(18,2),
@Attachment nvarchar(200),
@BillDetailsList nvarchar(4000),
@Remarks nvarchar(200)
as
begin
	
	Declare @IsApproved as bit 

	if @Approver='N\A'
		begin
			Set @Approver = null
			Set @IsApproved = 1
		end
	else
		begin
				Set @IsApproved = 0
		end

	if @RequestedBy = 'N\A'
		Set @RequestedBy = null

begin tran

	Update tblBillInfo Set SupplierID=@SupplierID,BillNo=@BillNo,BillDate=@BillDate,ProjectID=@ProjectID,PaymentMode=@PaymentMode,
	RequestedBy=@RequestedBy,Approver=@Approver,BillAmount=@BillAmount,Attachment=@Attachment,Remarks=@Remarks
	Where BillInfoID=@BillInfoID And IsApproved=0
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	Delete from tblBillDetails Where BillInfoID=@BillInfoID 
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	exec spInsertMultipleBillDetails @BillDetailsList,@BillInfoID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end