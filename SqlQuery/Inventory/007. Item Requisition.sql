GO

Create proc spAcceptRequisition
@RequisitionID nvarchar(50),
@WarehouseID nvarchar(50),
@ItemID nvarchar(50),
@ApprovedQuantity int,
@ApproverRemarks nvarchar(500),
@EntryBy nvarchar(50)
as
begin

	Declare @AvailableBalance int
	Set @AvailableBalance = 0

	Declare @WarehItemtbl table(
	WarehouseItemID nvarchar(50),
	ItmBalRemaining int,
	IsTaken bit default 0
	);

	Declare @QuantityApproved as int
	Declare @WarehouseItemID nvarchar(50)
	Declare @ItmBalRemaining int
	Declare @ItemBalAfterAdjustment as int 
	Set @ItemBalAfterAdjustment = 0

	Declare @EmployeeID as nvarchar(50)
	Declare @ReqQuantity as int
	Declare @Remarks as nvarchar(500)
	Declare @EntryPoint as nvarchar(50)
	Declare @SupervisorID as nvarchar(50)
	Declare @DepartmentID as nvarchar(50)
	Declare @BranchID as nvarchar(50)
	Declare @RequestedBy as nvarchar(50)
	Declare @BalanceDiff as int
	Set @BalanceDiff = 0

begin tran

	Set @WarehouseItemID = ''
	Set @ItmBalRemaining = 0
	Set @QuantityApproved = @ApprovedQuantity

	-- If Approved Quantity < Requested Quantity Then Iniate Another Requisition
	Select @EmployeeID=EmployeeID,@ReqQuantity=Quantity,@Remarks=Remarks,@EntryPoint=EntryPoint,@SupervisorID=SupervisorID,
	@DepartmentID=DepartmentID,@BranchID=BranchID,@RequestedBy=EntryBy From tblRequisition Where @RequisitionID=RequisitionID

	If @QuantityApproved < @ReqQuantity 
	begin
		Set @BalanceDiff = @ReqQuantity-@QuantityApproved
		exec spInsertUserRequisition @EmployeeID,@ItemID,@BalanceDiff,@Remarks,@EntryPoint,@SupervisorID,@DepartmentID,@BranchID,@RequestedBy 
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

	Insert Into @WarehItemtbl(WarehouseItemID,ItmBalRemaining)
	Select WarehouseItemID,(ItemBalance-AdjustedBalance) from tblWarehouseItems 
	Where WarehouseID=@WarehouseID And ItemID=@ItemID And IsAdjusted=0
	Order By (2) desc
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Select @AvailableBalance = dbo.fnGetWareHItemBalByItemID(@WarehouseID,@ItemID)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	If @AvailableBalance >= @ApprovedQuantity
	begin
		While @ApprovedQuantity > 0 
		begin
			Select top 1 @WarehouseItemID=WarehouseItemID, @ItmBalRemaining=ItmBalRemaining 
			From @WarehItemtbl Where IsTaken=0
			
			If @ApprovedQuantity < @ItmBalRemaining
			begin
				-- Insert Adjustment History
				exec spInsertWarehouseAdjHistory @RequisitionID,@WarehouseItemID,@ApprovedQuantity
				IF (@@ERROR <> 0) GOTO ERR_HANDLER

				-- Update Warehouse
				Update tblWarehouseItems Set AdjustedBalance= isnull(AdjustedBalance,0)+ @ApprovedQuantity
				Where WarehouseItemID=@WarehouseItemID
				IF (@@ERROR <> 0) GOTO ERR_HANDLER

				Set @ApprovedQuantity = 0
			end
			else
			begin
				-- Insert Adjustment History
				exec spInsertWarehouseAdjHistory @RequisitionID,@WarehouseItemID,@ItmBalRemaining
				IF (@@ERROR <> 0) GOTO ERR_HANDLER

				-- Update Warehouse
				Update tblWarehouseItems Set AdjustedBalance= isnull(AdjustedBalance,0)+ @ItmBalRemaining
				Where WarehouseItemID=@WarehouseItemID
				IF (@@ERROR <> 0) GOTO ERR_HANDLER

				Set @ApprovedQuantity = @ApprovedQuantity - @ItmBalRemaining
			end

			-- Chq. For Balance Adjusted..
			Select @ItemBalAfterAdjustment = (ItemBalance-AdjustedBalance) from tblWarehouseItems Where WarehouseItemID=@WarehouseItemID
			IF (@@ERROR <> 0) GOTO ERR_HANDLER

			if @ItemBalAfterAdjustment = 0
			begin
				Update tblWarehouseItems Set IsAdjusted=1, AdjustmentDate=getdate()
				Where WarehouseItemID=@WarehouseItemID
				IF (@@ERROR <> 0) GOTO ERR_HANDLER
			end
			
			Update @WarehItemtbl Set IsTaken=1
			Where WarehouseItemID=@WarehouseItemID
			IF (@@ERROR <> 0) GOTO ERR_HANDLER

			Set @WarehouseItemID = ''
			Set @ItmBalRemaining = 0
			Set @ItemBalAfterAdjustment = 0
		end
	end

	-- Update Requisition
	If @ApprovedQuantity=0
	begin
		Update tblRequisition Set IsApproved=1,ApprovedBy=@EntryBy,ApprovalDate=getdate(),
		Status='Approved',ApproverRemarks=@ApproverRemarks,ApprovedQuantity=@QuantityApproved
		Where RequisitionID=@RequisitionID
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end
	
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end



GO

Create proc spGetReqRemDepartmentList
as
begin
	Select Distinct DepartmentID,DeptName from tblDepartment Where IsActive=1
	And DepartmentID In ( Select DepartmentID from tblEmployeeInfo Where EmployeeID in 
	(Select EmployeeID from tblRequisition Where IsApproved=0 And IsRejected=0 And IsDeptApproved=1) )
	Order by DeptName
end

GO

Create proc spAdvAcceptRequisition
@RequisitionIDList nvarchar(4000),
@WarehouseID nvarchar(50),
@ApproverRemarks nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @RequisitionID as nvarchar(50)
	Declare @ItemID as nvarchar(50)
	Declare @ApprovedQuantity as int
	
	Set @RequisitionID = ''
	Set @ItemID = ''
	Set @ApprovedQuantity = 0

begin tran

	set @RestData=@RequisitionIDList
	while @RestData<>''
	begin
		set @Index=CHARINDEX('|',@RestData)
		set @CurrentData=substring(@RestData,1,@Index-1)
		set @RestData=substring(@RestData,@Index+1,len(@RestData))		
		
		set @RestPortion=@CurrentData
		
		set @Index=CHARINDEX('~',@RestPortion)		
		set @RequisitionID=substring(@RestPortion,1,@Index-1)
		set @RestPortion=substring(@RestPortion,@Index+1,len(@RestPortion))	
		
		Select @ItemID=ItemID,@ApprovedQuantity=Quantity from tblRequisition Where RequisitionID=@RequisitionID
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		exec spAcceptRequisition @RequisitionID,@WarehouseID,@ItemID,@ApprovedQuantity,@ApproverRemarks,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @ItemID=''
		Set @ApprovedQuantity=0
		Set @RequisitionID=''
						
	end
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spDeliverRequisition
@RequisitionIDList nvarchar(4000),
@DeliveredBy nvarchar(50)
as
begin
	Declare @ReqItmTbl table(
	RequisitionID nvarchar(50)
	);

	Declare @DeliveryEntryPoint as nvarchar(50)

begin tran
	
	Set @DeliveryEntryPoint = convert(nvarchar,getdate(),102)+'.'+convert(nvarchar,getdate(),114)

	Insert into @ReqItmTbl(RequisitionID)
	Select * from dbo.Split(',',@RequisitionIDList)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Update tblRequisition Set IsDelivered=1,DeliveredBy=@DeliveredBy,DeliveryDate=getdate(),
	Status='Delivered',DeliveryEntryPoint = @DeliveryEntryPoint
	Where RequisitionID in (Select Distinct RequisitionID from @ReqItmTbl)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end


GO

Create proc spGetRequisitionStatus
as
begin
	Select Distinct Status from tblRequisition order by Status
end

GO

Create proc spInsertMultipleRequisition
@EmployeeID nvarchar(50),
@RequisitionItemList nvarchar(4000),
@EntryBy nvarchar(50)
as
begin
	Declare @Index as int
	Declare @CurrentData as nvarchar(4000)
	Declare @RestData as nvarchar(4000)
	Declare @RestPortion as nvarchar(4000)

	Declare @SupervisorID as nvarchar(50)
	Declare @SectionID as nvarchar(50)
	Declare @BranchID as nvarchar(50)

	Declare @ItemID as nvarchar(50)
	Declare @Quantity as int
	Declare @Remarks as nvarchar(500)

	Declare @EntryPoint nvarchar(50)
	Declare @CurrentEntryPoint numeric(18,0)
	Declare @EntryPointPrefix as nvarchar(4)

	set @EntryPointPrefix='ENT-'

	Select @SupervisorID=CurrentSupervisor,@SectionID=SectionID,@BranchID=NULL from tblEmployeeInfo
	Where EmployeeID=@EmployeeID

	
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
		
		exec spInsertUserRequisition @EmployeeID,@ItemID,@Quantity,@Remarks,@EntryPoint,@SupervisorID,@SectionID,@BranchID,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
		
		Set @ItemID=''
		Set @Quantity=''
		Set @Remarks=''
						
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

Create proc spInsertUserRequisition
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

	Insert Into tblRequisition(RequisitionID,EmployeeID,ItemID,Quantity,Remarks,EntryPoint,SupervisorID,DepartmentID,BranchID,Status,MailStatus,EntryBy)
	Values(@RequisitionID,@EmployeeID,@ItemID,@Quantity,@Remarks,@EntryPoint,@SupervisorID,@DepartmentID,@BranchID,'','Waiting',@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	/*
	if @SupervisorID = 'N\A' or @SupervisorID is null
	begin
		Update tblRequisition Set IsDeptApproved=1,DeptApprovedBy=@EntryBy,DeptApprovalDate=getdate(),Status='DeptApproved'
		Where RequisitionID=@RequisitionID
	end
	*/
	Update tblRequisition Set IsDeptApproved=1,DeptApprovedBy=@EntryBy,DeptApprovalDate=getdate(),Status='DeptApproved'
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

Create proc spRejectRequisition
@RequisitionID nvarchar(50),
@ApproverRemarks nvarchar(500),
@EntryBy nvarchar(50)
as
begin

begin tran
	
	Update tblRequisition Set IsRejected=1,RejectedBy=@EntryBy,RejectionDate=getdate(),Status='Rejected',
	ApproverRemarks=@ApproverRemarks
	Where RequisitionID=@RequisitionID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

-- exec spSearchItemRequisition '1/1/1900','1/1/2099','WH-00000003','N\A','N\A','N\A','N\A'

alter proc spSearchItemRequisition
@DateFrom datetime,
@DateTo datetime,
@WarehouseID nvarchar(50),
@BranchID nvarchar(50),
@DepartmentID nvarchar(50),
@EmployeeID nvarchar(50),
@ItemID nvarchar(50)
as
begin
	
	Declare @BranchIDParam as nvarchar(50)
	Declare @DepartmentIDParam as nvarchar(50)
	Declare @EmployeeIDParam as nvarchar(50)
	Declare @ItemIDParam as nvarchar(50)
	
	If @BranchID = 'N\A'
		Set @BranchIDParam = '%'
	Else
		Set @BranchIDParam = '%'+ @BranchID +'%'

	If @DepartmentID = 'N\A'
		Set @DepartmentIDParam = '%'
	else
		Set @DepartmentIDParam = '%' + @DepartmentID + '%'

	if @EmployeeID = 'N\A'
		Set @EmployeeIDParam = '%'
	Else
		Set @EmployeeIDParam = '%'+ @EmployeeID +'%'

	If @ItemID = 'N\A'
		Set @ItemIDParam = '%'
	Else
		Set @ItemIDParam = '%'+ @ItemID +'%'
	

	Select R.RequisitionID,EmployeeID,(Select EmployeeName from tblEmployeeInfo E Where E.EmployeeID=R.EmployeeID) as 'EmployeeName',
	R.ItemID,R.ItemName,Convert(nvarchar,R.RequisitionDate,106) as 'RequisitionDate',
	R.Quantity,dbo.fnGetWareHItemBalByItemID(@WarehouseID,R.ItemID) as 'Balance',R.Remarks,isnull(R.BranchID,'N\A') as 'BranchID',
	isnull((Select ULCBranchName from tblULCBranch B Where B.ULCBranchID=R.BranchID),'N\A') as 'BranchName'
	from vwRequisition R
	Where @DepartmentID like @DepartmentIDParam
	And (R.RequisitionDate between @DateFrom And @DateTo)
	--And ( R.BranchID like @BranchIDParam)
	--And ( R.DepartmentID like @DepartmentIDParam)
	And R.EmployeeID like @EmployeeIDParam
	And R.ItemID like @ItemIDParam
	And IsDeptApproved=1 And IsApproved=0 And IsRejected=0
	Order by EmployeeID,RequisitionDate desc 
end

select * from vwRequisition

GO


Create proc spShowRequisitionReport
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
	Where BranchID like @ULCBranchIDParam And DepartmentID like @DepartmentIDParam
	And EmployeeID like @EmployeeIDParam And Status like @StatusParam
	And ItemID like @ItemIDParam And Convert(datetime,RequisitionDate) between @DateFrom And @DateTo
end 

