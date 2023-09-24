


Create proc spGetDetailsInvLstToApprove
@ApproverID nvarchar(50)
as
begin
	Select I.InvoiceID,I.InvoiceNo,I.SupplierID,
	(Select SupplierName from tblSupplier S Where S.SupplierID=I.SupplierID) as 'SupplierName',
	Convert(nvarchar,I.InvoiceDate,106) as 'InvoiceDate',I.InvoiceCost,SubmittedBy,Convert(nvarchar,SubmissionDate,106) as 'SubmissionDate'
	from tblInvoices I Where IsSubmitted=1 And IsApproved=0 And IsRejected=0
	And (I.ApproverID=@ApproverID or I.ApproverID is null )
end

GO

Create proc spInsertMultipleWareHItems
@InvoiceID nvarchar(50),
@WarehouseItemList nvarchar(4000),
@EntryBy nvarchar(50)
as
begin

	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @WarehouseID as nvarchar(50)
	Declare @ItemID as nvarchar(50)
	Declare @ItemBalance as int

begin tran

	set @RestData=@WarehouseItemList
	while @RestData<>''
	begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @WarehouseID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @ItemID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @ItemBalance=convert(int,substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		exec spInsertWarehouseItems @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Invoice',@InvoiceID,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		exec spInsertBalTransferHistory @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Invoice',@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @WarehouseID=''
		Set @ItemID = ''
		Set @ItemBalance = 0
						
	end

	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spInsertWarehouseItems
@InvoiceID nvarchar(50),
@WarehouseID nvarchar(50),
@ItemID nvarchar(50),
@ItemBalance int,
@TransferType nvarchar(50),
@TransferedRef nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @WarehouseItemID nvarchar(50)
	Declare @CurrentWarehouseItemID numeric(18,0)
	Declare @WarehouseItemIDPrefix as nvarchar(7)

	set @WarehouseItemIDPrefix='WH-ITM-'
begin tran

	select @CurrentWarehouseItemID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentWarehouseItemID'
	
	set @CurrentWarehouseItemID=isnull(@CurrentWarehouseItemID,0)+1
	Select @WarehouseItemID=dbo.generateID(@WarehouseItemIDPrefix,@CurrentWarehouseItemID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblWarehouseItems(WarehouseItemID,InvoiceID,WarehouseID,ItemID,ItemBalance,TransferType,TransferedRef,EntryBy)
	Values(@WarehouseItemID,@InvoiceID,@WarehouseID,@ItemID,@ItemBalance,@TransferType,@TransferedRef,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	exec spInsertBalTransferHistory @InvoiceID,@WarehouseID,@ItemID,@ItemBalance,'Procurement',@EntryBy
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=convert(nvarchar,@CurrentWarehouseItemID) where PropertyName='CurrentWarehouseItemID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spInsertBalTransferHistory
@SourceRef nvarchar(50),
@DestinationRef nvarchar(50),
@ItemID nvarchar(50),
@TransferedBalance int,
@TransferType nvarchar(50),
@TransferedBy nvarchar(50)
as
begin
	Declare @BalTransferID nvarchar(50)
	Declare @CurrentBalTransferID numeric(18,0)
	Declare @BalTransferIDPrefix as nvarchar(8)

	set @BalTransferIDPrefix='BAL-TRF-'
begin tran

	select @CurrentBalTransferID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBalTransferID'
	
	set @CurrentBalTransferID=isnull(@CurrentBalTransferID,0)+1
	Select @BalTransferID=dbo.generateID(@BalTransferIDPrefix,@CurrentBalTransferID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblBalanceTransferHistory(BalTransferID,SourceRef,DestinationRef,ItemID,TransferedBalance,TransferType,TransferedBy)
	Values(@BalTransferID,@SourceRef,@DestinationRef,@ItemID,@TransferedBalance,@TransferType,@TransferedBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=convert(nvarchar,@CurrentBalTransferID) where PropertyName='CurrentBalTransferID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create function fnGetWareHItemBalByItemID(@WarehouseID nvarchar(50),@ItemID nvarchar(50))
returns int
as
begin
	Declare @AvailableBalance int
	Set @AvailableBalance = 0

	Select @AvailableBalance = isnull( Sum(ItemBalance-AdjustedBalance),0)
	from  tblWarehouseItems WI Where WarehouseID=@WarehouseID And ItemID=@ItemID
	group by ItemID 

	Set @AvailableBalance = isnull(@AvailableBalance,0)

	return @AvailableBalance
end

GO

Create function fnGetItemBalanceByItem(@ItemID nvarchar(50))
returns int
as
begin
	Declare @Balance as int
	Set @Balance = 0

	Select @Balance = isnull(sum(ItemBalance-AdjustedBalance),0) from tblWarehouseItems  
	Where ItemID=@ItemID And IsAdjusted=0

	return @Balance
end

GO

Create proc spGetLowBalanceItemList
as
begin
	Select ItemID,( ItemName + ' ( ' +isnull((Select UnitType from tblUnitType U Where U.UnitTypeID=I.UnitTypeID),'N\A')  + ' ) ' ) as 'ItemName',
	LowBalanceReport,dbo.fnGetItemBalanceByItem(I.ItemID) as 'Balance'
	From tblInventoryItems I Where I.IsActive=1 And dbo.fnGetItemBalanceByItem(I.ItemID) <= LowBalanceReport
end

GO

Create view vwProcurement
as
SELECT        I.InvoiceID, I.InvoiceNo, CONVERT(nvarchar, I.InvoiceDate, 106) AS InvoiceDate, I.InvoiceCost, I.SupplierID, S.SupplierName, II.ItemID, InI.ItemName, U.UnitType AS Unit, II.Quantity, II.UnitPrice, II.EntryBy AS PreparedBy, 
CASE I.IsApproved WHEN 1 THEN 'YES' ELSE 'NO' END AS IsApproved, I.ApprovedBy, CONVERT(nvarchar, I.ApprovalDate, 106) AS ApprovalDate
FROM            dbo.tblInvoices AS I LEFT OUTER JOIN
dbo.tblInvoiceItems AS II ON I.InvoiceID = II.InvoiceID LEFT OUTER JOIN
dbo.tblSupplier AS S ON I.SupplierID = S.SupplierID LEFT OUTER JOIN
dbo.tblInventoryItems AS InI ON II.ItemID = InI.ItemID LEFT OUTER JOIN
dbo.tblUnitType AS U ON InI.UnitTypeID = U.UnitTypeID

GO

Create view vwReqAdjHistory
as
SELECT        WAH.RequisitionID, WI.WarehouseID,
(SELECT        WarehouseName
FROM            dbo.tblWarehouse AS W
WHERE        (WarehouseID = WI.WarehouseID)) AS WarehouseName, WAH.WarehouseAdjID
FROM            dbo.tblWarehouseItems AS WI LEFT OUTER JOIN
dbo.tblWarehouseAdjHistory AS WAH ON WI.WarehouseItemID = WAH.WarehouseItemID

GO

alter proc spGetWarehouseItemBalance
@WarehouseID nvarchar(50) 
as
begin
	Select WI.ItemID,I.ItemName as 'ItemName',I.ItemCode,U.UnitType,
	Sum(ItemBalance-AdjustedBalance) as 'Balance'
	from  tblWarehouseItems WI Left Join tblInventoryItems I On WI.ItemID=I.ItemID
	Left Join tblUnitType U On I.UnitTypeID=U.UnitTypeID
	Where WarehouseID=@WarehouseID
	group by WI.ItemID,I.ItemName,I.ItemCode,U.UnitType
	order by I.ItemName
end

GO

Create proc spGetProcurementInfoByItem
@ItemID nvarchar(50)
as
begin
	Select InvoiceID,InvoiceNo,InvoiceDate,SupplierName,Quantity,UnitPrice,PreparedBy,ApprovedBy from vwProcurement
	Where ItemID=@ItemID
end

GO

-- exec spGetWarehouseItemBalance 'WH-00000003'

Alter view vwRequisition
as
select R.RequisitionID,R.EmployeeID,R.ItemID,I.ItemName+ '(' + U.UnitType + ')' as 'ItemName',
R.Quantity,R.Remarks,R.EntryPoint,ISNULL(R.SupervisorID, 'N\A') AS SuperVisorID,E.EmployeeName as 'Supervisor',
IsApproved, CASE R.IsApproved WHEN 1 THEN 'Approved' ELSE 'Pending/Rejected' END AS ApprovalStatus,
'' as 'DepartmentID','' as 'Department','' as 'BranchID','Head Office' as 'BranchName',
CASE R.IsDelivered WHEN 1 THEN 'Delivered' ELSE 'Not Delivered Yet' END AS IsDelivered, 
ISNULL(R.DeliveredBy, 'N\A') AS DeliveredBy, ISNULL(CONVERT(nvarchar, R.DeliveryDate, 106), 'N\A') AS DeliveryDate, 
ISNULL(CONVERT(nvarchar, R.ApprovalDate, 106), 'N\A') AS ApprovalDate, R.IsDeptApproved, R.IsRejected, R.ApprovedQuantity, ApproverRemarks, Status, 
CONVERT(nvarchar, R.EntryDate, 106) AS RequisitionDate
from tblRequisition R INNER JOIN tblInventoryItems I ON R.ItemID=I.ItemID
LEFT OUTER JOIN tblUnitType U ON I.UnitTypeID = U.UnitTypeID
LEFT OUTER JOIN tblEmployeeInfo E ON R.SupervisorID=E.EmployeeID

-- select * from vwRequisition
GO
-- select * from vwRequisitionReport
alter view vwRequisitionReport
as
SELECT R.RequisitionID, R.EmployeeID, EI.EmployeeName, R.ItemID, InI.ItemName, InI.ItemCode, U.UnitType, R.Quantity, R.Remarks, 
ISNULL(D.SectionID, N'N\A') AS DepartmentID, 
ISNULL(D.Section, N'N\A') AS DepartmentName,
R.BranchID,'Head Office' as 'BranchName',
CASE R.IsApproved WHEN 1 THEN 'YES' ELSE 'NO' END AS IsApproved, R.ApprovedBy, CONVERT(nvarchar, R.ApprovalDate, 106) AS ApprovalDate, R.ApprovedQuantity, 
CASE R.IsDelivered WHEN 1 THEN 'YES' ELSE 'NO' END AS IsDelivered, R.DeliveredBy, 
CONVERT(nvarchar, R.DeliveryDate, 106) AS DeliveryDate,R.ApproverRemarks,
Status, CONVERT(nvarchar, R.EntryDate, 106) AS RequisitionDate
FROM  dbo.tblRequisition AS R LEFT OUTER JOIN
dbo.tblEmployeeInfo AS EI ON R.EmployeeID = EI.EmployeeID LEFT OUTER JOIN
dbo.tblSection AS D ON EI.SectionID = D.SectionID LEFT OUTER JOIN
dbo.tblInventoryItems AS InI ON R.ItemID = InI.ItemID LEFT OUTER JOIN
dbo.tblUnitType AS U ON InI.UnitTypeID = U.UnitTypeID

GO


--Create view vwRequisition
--as
--SELECT        RequisitionID, EmployeeID, ItemID,
--(SELECT        ItemName + ' ( ' +
--(SELECT        UnitType
--FROM            dbo.tblUnitType AS UNT
--WHERE        (UnitTypeID = I.UnitTypeID)) + ' )' AS Expr1
--FROM            dbo.tblInventoryItems AS I
--WHERE        (ItemID = R.ItemID)) AS ItemName, Quantity, Remarks, EntryPoint, ISNULL(SupervisorID, 'N\A') AS SuperVisorID, ISNULL
--((SELECT        UserName
--FROM            dbo.tblUsers AS U
--WHERE        (UniqueUserID = R.SupervisorID)), 'N\A') AS Supervisor, ISNULL(DepartmentID, 'N\A') AS DepartmentID, ISNULL
--((SELECT        DeptName
--FROM            dbo.tblDepartment AS D
--WHERE        (DepartmentID = R.DepartmentID)), 'N\A') AS Department, ISNULL(BranchID, 'N\A') AS BranchID, ISNULL
--((SELECT        ULCBranchName
--FROM            dbo.tblULCBranch AS B
--WHERE        (ULCBranchID = R.BranchID)), 'N\A') AS BranchName, IsApproved, CASE R.IsApproved WHEN 1 THEN 'Approved' ELSE 'Pending/Rejected' END AS ApprovalStatus, 
--CASE R.IsDelivered WHEN 1 THEN 'Delivered' ELSE 'Not Delivered Yet' END AS IsDelivered, ISNULL(DeliveredBy, 'N\A') AS DeliveredBy, ISNULL(CONVERT(nvarchar, DeliveryDate, 106), 'N\A') AS DeliveryDate, 
--ISNULL(CONVERT(nvarchar, ApprovalDate, 106), 'N\A') AS ApprovalDate, IsDeptApproved, IsRejected, ApprovedQuantity, ApproverRemarks, Status, CONVERT(nvarchar, EntryDate, 106) AS RequisitionDate
--FROM            dbo.tblRequisition AS R;

ALTER proc [dbo].[spUpdateInventoryItems]
@ItemID nvarchar(50),
@BuyerID nvarchar(50),
@StyleID nvarchar(50),
@ColorID nvarchar(50),
@ParentItemID nvarchar(50),
@ItemName nvarchar(200),
@ItemCode nvarchar(200),
@UnitTypeID nvarchar(50),
@LowBalanceReport int,
@MaxAllowableRequisition int,
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	
begin tran

	if @BuyerID = 'N\A'
		Set @BuyerID = NULL

	if @StyleID = 'N\A'
		Set @StyleID = NULL;

	if @ColorID = 'N\A'
		Set @ColorID = NULL;

	if @ParentItemID = 'N\A'
		Set @ParentItemID = NULL;

	Update tblInventoryItems Set BuyerID=@BuyerID,StyleID=@StyleID,ColorID=@ColorID,ParentItemID=@ParentItemID,
	ItemName=@ItemName,ItemCode=@ItemCode,UnitTypeID=@UnitTypeID,
	LowBalanceReport=@LowBalanceReport,MaxAllowableRequisition=@MaxAllowableRequisition,IsActive=@IsActive,
	EntryBy=@EntryBy
	Where ItemID=@ItemID
	
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spInsertOnDemandRequisition
@EmployeeID nvarchar(50),
@ItemID nvarchar(50),
@Quantity int,
@Remarks nvarchar(500),
@EntryPoint nvarchar(50),
@SupervisorID nvarchar(50),
@DepartmentID nvarchar(50),
@BranchID nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @RequisitionID nvarchar(50)
	Declare @CurrentRequisitionID numeric(18,0)
	Declare @RequisitionIDPrefix as nvarchar(4)

	set @RequisitionIDPrefix='REQ-'

begin tran

	If @SupervisorID='N\A'
	begin
		Set @SupervisorID = null
	end

	if @DepartmentID='N\A'
	begin
		Set @DepartmentID = null
	end

	if @BranchID = 'N\A'
	begin
		Set @BranchID = null
	end

	select @CurrentRequisitionID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentRequisitionID'
	
	set @CurrentRequisitionID=isnull(@CurrentRequisitionID,0)+1
	Select @RequisitionID=dbo.generateID(@RequisitionIDPrefix,@CurrentRequisitionID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblRequisition(RequisitionID,EmployeeID,ItemID,Quantity,Remarks,EntryPoint,SupervisorID,DepartmentID,BranchID,
	IsDeptApproved,DeptApprovedBy,DeptApprovalDate,IsOnDemandRequisition,OnDemandRequisitionFor,Status,MailStatus,EntryBy)
	Values(@RequisitionID,@EmployeeID,@ItemID,@Quantity,@Remarks,@EntryPoint,@SupervisorID,@DepartmentID,@BranchID,
	1,@EntryBy,getdate(),1,@EmployeeID,'','Waiting',@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	/*
	if @SupervisorID = 'N\A' or @SupervisorID is null
	begin
		Update tblRequisition Set IsDeptApproved=1,DeptApprovedBy=@EntryBy,DeptApprovalDate=getdate()
		Where RequisitionID=@RequisitionID
	end
	*/
	Update tblRequisition Set IsDeptApproved=1,DeptApprovedBy=@EntryBy,DeptApprovalDate=getdate()
	Where RequisitionID=@RequisitionID
	
	update tblAppSettings set PropertyValue=@CurrentRequisitionID where PropertyName='CurrentRequisitionID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spInsertMultipleOnDemandReq
@RequisitionItemList nvarchar(4000),
@EntryBy nvarchar(50)
as
begin
	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @SupervisorID as nvarchar(50)
	Declare @DepartmentID as nvarchar(50)
	Declare @BranchID as nvarchar(50)

	Declare @ItemID as nvarchar(50)
	Declare @Quantity as int
	Declare @Remarks as nvarchar(500)
	Declare @EmployeeID as nvarchar(50)

	Declare @EntryPoint nvarchar(50)
	Declare @CurrentEntryPoint numeric(18,0)
	Declare @EntryPointPrefix as nvarchar(4)

	set @EntryPointPrefix='ENT-'
begin tran

	select @CurrentEntryPoint = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentRequisitionEntryPoint'
	
	print convert(nvarchar,@CurrentEntryPoint)
	set @CurrentEntryPoint=isnull(@CurrentEntryPoint,0)+1
	Select @EntryPoint=dbo.generateID(@EntryPointPrefix,@CurrentEntryPoint,8)	

	Print @EntryPoint
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	set @RestData=@RequisitionItemList
	while @RestData<>''
	begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @ItemID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @Quantity=convert(int,substring(@RestPortion,1,@Index-1))
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @Remarks=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	

		set @Index=CHARINDEX('~',@RestPortion)		
		set @EmployeeID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))

		Select @SupervisorID=CurrentSupervisor,@DepartmentID=SectionID,@BranchID=NULL from tblEmployeeInfo
		Where EmployeeID=@EmployeeID
		
		exec spInsertOnDemandRequisition @EmployeeID,@ItemID,@Quantity,@Remarks,@EntryPoint,@SupervisorID,@DepartmentID,@BranchID,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		Set @ItemID=''
		Set @Quantity=''
		Set @Remarks=''
		Set @EmployeeID = ''
		Set @SupervisorID = ''
		Set @DepartmentID = ''
		Set @BranchID = ''
	end

	update tblAppSettings set PropertyValue=@CurrentEntryPoint where PropertyName='CurrentRequisitionEntryPoint'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spGetItemBalanceByItem
@ItemID nvarchar(50)
as
begin
	Select isnull(sum(ItemBalance-AdjustedBalance),0) as 'Balance' from tblWarehouseItems  
	Where ItemID=@ItemID And IsAdjusted=0
end

GO

Create proc spInsertWarehouseAdjHistory
@RequisitionID nvarchar(50),
@WarehouseItemID nvarchar(50),
@AdjustedBalance int
as
begin
	Declare @WarehouseAdjID nvarchar(50)
	Declare @CurrentWarehouseAdjID numeric(18,0)
	Declare @WarehouseAdjIDPrefix as nvarchar(7)

	set @WarehouseAdjIDPrefix='WH-ADJ-'
begin tran

	select @CurrentWarehouseAdjID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentWarehouseAdjID'
	
	set @CurrentWarehouseAdjID=isnull(@CurrentWarehouseAdjID,0)+1
	Select @WarehouseAdjID=dbo.generateID(@WarehouseAdjIDPrefix,@CurrentWarehouseAdjID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
	Insert Into tblWarehouseAdjHistory(WarehouseAdjID,RequisitionID,WarehouseItemID,AdjustedBalance)
	Values(@WarehouseAdjID,@RequisitionID,@WarehouseItemID,@AdjustedBalance)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=convert(nvarchar,@CurrentWarehouseAdjID) where PropertyName='CurrentWarehouseAdjID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spGetReqHistoryByUserID
@EmployeeID nvarchar(50)
as
begin
	Select RequisitionID,EmployeeID,ItemID,ItemName,Remarks,EntryPoint,SuperVisorID,Supervisor,DepartmentID,
	Department,BranchID,BranchName,IsApproved,ApprovalDate,
	IsDelivered,DeliveredBy,DeliveryDate,ApprovedQuantity,ApproverRemarks,RequisitionDate
	From vwRequisition Where EmployeeID=@EmployeeID
	Order by Convert(datetime,RequisitionDate) desc
end

GO

ALTER proc spShowRequisitionReport
@DateFrom datetime,
@DateTo datetime,
@ULCBranchID nvarchar(50),
@DepartmentID nvarchar(50),
@EmployeeID nvarchar(50),
@Status nvarchar(50),
@ItemID nvarchar(50)
as
begin

	Declare @ULCBranchIDParam as nvarchar(50)
	Declare @DepartmentIDParam as nvarchar(50)
	Declare @EmployeeIDParam as nvarchar(50)
	Declare @StatusParam as nvarchar(50)
	Declare @ItemIDParam as nvarchar(50)

	If @ULCBranchID = 'N\A'
		Set @ULCBranchIDParam = '%'
	Else
		Set @ULCBranchIDParam = '%'+ @ULCBranchID +'%'

	If @DepartmentID = 'N\A'
		Set @DepartmentIDParam = '%'
	Else
		Set @DepartmentIDParam = '%'+ @DepartmentID +'%'

	If @EmployeeID = 'N\A'
		Set @EmployeeIDParam = '%'
	Else
		Set @EmployeeIDParam = '%'+ @EmployeeID +'%'
	
	If @Status = 'N\A'
		Set @StatusParam = '%'
	Else
		Set @StatusParam = '%'+ @Status +'%'

	If @ItemID = 'N\A'
		Set @ItemIDParam = '%'
	Else
		Set @ItemIDParam = '%'+ @ItemID +'%'

	Select RequisitionID,EmployeeID,EmployeeName,ItemID,ItemName as 'ItemName',UnitType,ItemCode,Quantity,Remarks,DepartmentID,DepartmentName,
	BranchID,BranchName,RequisitionDate,IsApproved,ApprovedBy,ApprovalDate,ApprovedQuantity,
	IsDelivered,DeliveredBy,DeliveryDate,Status,ApproverRemarks
	from vwRequisitionReport
	Where 
	(BranchID like @ULCBranchIDParam or BranchID is null) 
	And (DepartmentID like @DepartmentIDParam or DepartmentID is NULL)
	And EmployeeID like @EmployeeIDParam And Status like @StatusParam
	And ItemID like @ItemIDParam And Convert(datetime,RequisitionDate) between @DateFrom And @DateTo
end 