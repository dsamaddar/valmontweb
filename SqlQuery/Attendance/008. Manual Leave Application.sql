
GO

alter proc spGetLeaveDetails
@EmployeeID nvarchar(50)
as
begin
	If @EmployeeID = 'N\A'
		Set @EmployeeID = '%'
	else
		Set @EmployeeID = '%'+ @EmployeeID +'%'

	Select LD.LeaveDetailID,E.EmployeeName,E.EmpCode,Convert(nvarchar,LD.LeaveDate,106) as 'LeaveDate'
	from tblLeaveDetails LD INNER JOIN tblEmployeeInfo E ON LD.EmployeeID = E.EmployeeID
	Where LD.EmployeeID like @EmployeeID
end

GO

Create proc spInsertLeaveDetails
@EmployeeID nvarchar(50),
@LeaveStartDate date,
@LeaveEndDate date
as
begin

	Declare @InterimDate as date
	Set @InterimDate = @LeaveStartDate

	Declare @LeaveDetailID as nvarchar(50)
	Declare @CurrentLeaveDetailID numeric(18,0)
	Declare @LeaveDetailIDPrefix as nvarchar(3)
	
	set @LeaveDetailIDPrefix='LD-'

begin tran
	While @InterimDate <= @LeaveEndDate
	begin
		select @CurrentLeaveDetailID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentLeaveDetailID'
		set @CurrentLeaveDetailID=isnull(@CurrentLeaveDetailID,0)+1
		Select @LeaveDetailID=dbo.generateID(@LeaveDetailIDPrefix,@CurrentLeaveDetailID,8)		

		INSERT INTO tblLeaveDetails(LeaveDetailID,LeaveBalanceID,LeaveRequestID,EmployeeID,LeaveDate)
		VALUES(@LeaveDetailID,NULL,NULL,@EmployeeID,@InterimDate)
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @InterimDate = DATEADD(DAY,1,@InterimDate)

		update tblAppSettings set PropertyValue=@CurrentLeaveDetailID where PropertyName='CurrentLeaveDetailID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spDeleteLeaveDetails
@LeaveDetailID nvarchar(50)
as
begin
	delete from tblLeaveDetails Where LeaveDetailID = @LeaveDetailID
end