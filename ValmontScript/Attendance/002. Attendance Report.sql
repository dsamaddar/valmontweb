 
--select * from tblEmployeeInfo where EmpCode='10208'
-- select dbo.fnGetAttStatus('EMP-00000811','05/05/2022')

alter function fnGetAttStatus(@EmployeeID nvarchar(50), @AttDate DATE)
returns nvarchar(20)
as
begin

	Declare @AttStatus as nvarchar(20) Set @AttStatus= ''
	Declare @LateIn as int Set @LateIn = 0
	Declare @EarlyOut as int Set @EarlyOut = 0

	Declare @JoiningDate as date;
	Select @JoiningDate = JoiningDate from tblEmployeeInfo where EmployeeID = @EmployeeID;

	If @JoiningDate > @AttDate
	begin
		return 'UnEmployed'
	end

	if exists(select * from tblUserAttendance Where EmployeeID = @EmployeeID and Convert(nvarchar,LogTime,106)=Convert(nvarchar,@AttDate,106) And AuthStatus='A')
	begin

		if exists (select min(DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime)) from tblUserAttendance U Where EmployeeID=@EmployeeID
					And Convert(nvarchar,LogTime,106)=Convert(nvarchar,@AttDate,106)
					And U.AuthStatus='A'
					group by DATEPART(DAY,U.LogTime)
					having min(DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime)) > 0
				  )
				  begin
						Set @AttStatus = @AttStatus + 'Late'
				  end

		if exists(
					select DATEDIFF(MINUTE,max(U.LogTime),ISNULL(MAX(U.IdealLogOutTime),Convert(datetime, convert(nvarchar,MAX(U.LogTime),101) + ' 04:00:00 PM')))
					from tblUserAttendance U Where EmployeeID=@EmployeeID
					And Convert(nvarchar,LogTime,106)=Convert(nvarchar,@AttDate,106)
					And U.AuthStatus='A'
					group by DATEPART(DAY,U.LogTime)
					having DATEDIFF(MINUTE,max(U.LogTime),ISNULL(MAX(U.IdealLogOutTime),Convert(datetime, convert(nvarchar,MAX(U.LogTime),101) + ' 04:00:00 PM'))) > 0
		)
				begin
					if @AttStatus = ''
					begin
						Set @AttStatus = @AttStatus + 'Early'
					end
					else
					begin
						Set @AttStatus = @AttStatus + ',Early'
					end
						
				end
		if @AttStatus = ''
		begin
			Set @AttStatus = 'Regular'
		end
		--added on 24th Feb
		if exists(
			Select * from tblHolidays Where convert(nvarchar,HolidayDate,103)=convert(nvarchar,@AttDate,103)
		)
		begin
			Set @AttStatus = 'Holiday';
		end
		if exists(
			Select * from tblNoWorkDay Where EmployeeID=@EmployeeID AND convert(nvarchar,NoWorkDay,103)=convert(nvarchar,@AttDate,103)
		)
		begin
			Set @AttStatus = 'NoWorkDay';
		end
	end
	else
	begin
		
		if exists(
			select * from tblLeaveDetails Where EmployeeID = @EmployeeID and convert(nvarchar,LeaveDate,103) =convert(nvarchar,@AttDate,103) 
		)
		begin
			Set @AttStatus = 'on Leave'
		end
		else if exists(
			Select * from tblHolidays Where convert(nvarchar,HolidayDate,103)=convert(nvarchar,@AttDate,103)
		)
		begin
			Set @AttStatus = 'Holiday';
		end
		else if exists(
			Select * from tblNoWorkDay Where EmployeeID=@EmployeeID AND convert(nvarchar,NoWorkDay,103)=convert(nvarchar,@AttDate,103)
		)
		begin
			Set @AttStatus = 'NoWorkDay';
		end
		else
			Set @AttStatus = 'Absent';
	end

	-- Check for shifting duty
	declare @max_dt datetime
	if exists(select * from tblSection where SectionID in (select SectionID from tblEmployeeInfo where EmployeeID=@EmployeeID) and ShiftID is not null)
	begin
		If @AttStatus = 'Early' or @AttStatus = 'Late'
		begin
			select @max_dt = max(LogTime) from tblUserAttendance where EmployeeID = @EmployeeID and AttSystem = 'A' and LogTime between @AttDate and DATEADD(HOUR,12,convert(datetime,@AttDate))

			if DATEDIFF(HOUR,@AttDate,@max_dt) < 6
				Set @AttStatus = 'Absent';
		end
	end

	-- Check for shifting duty


	return ISNULL(@AttStatus,'-')
end

GO

alter function fnGetAbsentInfo(
@EmployeeID nvarchar(50),@DepartmentID nvarchar(50),@BranchID nvarchar(50),@DesignationID nvarchar(50),
@DateFrom date,@DateTo date,@AttStatus nvarchar(50)
)
returns @AttTbl table(
	IndividualEmp nvarchar(200),
	ID nvarchar(50),
	Employee nvarchar(200),
	Designation nvarchar(50),
	Department nvarchar(50),
	Branch nvarchar(50),
	TimeIn datetime,
	TimeOuts datetime,
	Remarks nvarchar(50)
)
as
begin

	Declare @EmpID as nvarchar(50) Set @EmpID = ''
	Declare @EmployeeIDParam as nvarchar(50) Set @EmployeeIDParam = ''
	Declare @DepartmentIDParam as nvarchar(50) Set @DepartmentIDParam = ''
	Declare @AttStatusParam as nvarchar(50) Set @AttStatusParam = ''
	Declare @DateFromParam as datetime
	Declare @DateToParam as datetime
	Declare @BranchIDParam as nvarchar(50) set @BranchIDParam = ''
	Declare @DesignationIDParam as nvarchar(50) set @DesignationIDParam = ''
	Declare @IndividualEmp as nvarchar(50) Set @IndividualEmp = ''

		if @DepartmentID = 'ALL'
		Set @DepartmentIDParam = '%'
	else
		Set @DepartmentIDParam = '%' + @DepartmentID + '%'

	if @DesignationID = 'ALL'
		Set @DesignationIDParam = '%'
	else
		Set @DesignationIDParam = '%' + @DesignationID + '%'

	if @EmployeeID = 'ALL'
	begin
		Set @EmployeeIDParam = '%'
		Set @IndividualEmp = 'ALL'
	end
	else
	begin
		Set @EmployeeIDParam = '%' + @EmployeeID + '%'
		Select @IndividualEmp =EmployeeName from tblEmployeeInfo Where EmployeeID = @EmployeeID
	end

	if @BranchID= 'ALL'
		Set @BranchIDParam = '%'
	else
		Set @BranchIDParam = '%' + @BranchID + '%'

	Set @DateFromParam = Convert(datetime,Convert(nvarchar,@DateFrom,101) + ' 12:01:01 AM')
	Set @DateToParam = Convert(datetime, Convert(nvarchar,@DateTo,101) + ' 11:59:59 PM')

	declare @emptbl table(
	EmployeeID nvarchar(50),
	IsTaken bit default 0
	)

	--print 'A'
	
	Insert into @emptbl(EmployeeID)
	Select EmployeeID
	from vwEmpInfo V
	where V.isActive = 1 and V.IncludedInPayroll = 1 
	And V.SectionID like @DepartmentIDParam
	And V.EmployeeID like @EmployeeIDParam
	--And V.ULCBranchID like @BranchIDParam
	And V.DesignationID like @DesignationIDParam

	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0
	Declare @TempDate as datetime

	select @NCount = Count(*) from @emptbl

	While @Count <= @NCount
	begin
		Select top 1 @EmpID=EmployeeID from @emptbl Where IsTaken=0
		Set @TempDate = @DateFromParam
		--print 'B'
		While @TempDate <= @DateToParam
		begin
			
			if dbo.fnGetAttStatus(@EmpID,@TempDate) = 'Absent'
			begin
				Insert into @AttTbl(IndividualEmp,ID,Employee,Designation,Department,Branch,TimeIn,TimeOuts,Remarks)
				select @IndividualEmp,V.CardNo,V.EmployeeName,V.Designation,V.Section,'Factory',@TempDate,@TempDate,'Absent'
				from vwEmpInfo V Where EmployeeID = @EmpID
			end

			Set @TempDate = DATEADD(DAY,1,@TempDate)
		end

		Update @emptbl Set IsTaken = 1 Where EmployeeID = @EmpID
		Set @EmpID = ''
		Set @Count += 1
	end

	return;
end


GO

alter proc spReportDailyAtt
@EmployeeID nvarchar(50),
@DepartmentID nvarchar(50),
@BranchID nvarchar(50),
@DesignationID nvarchar(50),
@DateFrom date,
@DateTo date,
@AttStatus nvarchar(50)
as
begin

	Declare @EmployeeIDParam as nvarchar(50) Set @EmployeeIDParam = ''
	Declare @DepartmentIDParam as nvarchar(50) Set @DepartmentIDParam = ''
	Declare @AttStatusParam as nvarchar(50) Set @AttStatusParam = ''
	Declare @DateFromParam as datetime
	Declare @DateToParam as datetime
	Declare @BranchIDParam as nvarchar(50) set @BranchIDParam = ''
	Declare @DesignationIDParam as nvarchar(50) set @DesignationIDParam = ''
	Declare @IndividualEmp as nvarchar(50) Set @IndividualEmp = ''

	Set @DateFromParam = Convert(datetime,Convert(nvarchar,@DateFrom,101) + ' 12:01:01 AM')
	Set @DateToParam = Convert(datetime, Convert(nvarchar,@DateTo,101) + ' 11:59:59 PM')

	if @DepartmentID = 'ALL'
		Set @DepartmentIDParam = '%'
	else
		Set @DepartmentIDParam = '%' + @DepartmentID + '%'

	if @DesignationID = 'ALL'
		Set @DesignationIDParam = '%'
	else
		Set @DesignationIDParam = '%' + @DesignationID + '%'

	if @EmployeeID = 'ALL'
	begin
		Set @EmployeeIDParam = '%'
		Set @IndividualEmp = 'ALL'
	end
	else
	begin
		Set @EmployeeIDParam = '%' + @EmployeeID + '%'
		Select @IndividualEmp =EmployeeName from tblEmployeeInfo Where EmployeeID = @EmployeeID
	end

	if @AttStatus = 'ALL'
		Set @AttStatusParam = '%'
	else
		Set @AttStatusParam = '%' + @AttStatus + '%'

	if @BranchID= 'ALL'
		Set @BranchIDParam = '%'
	else
		Set @BranchIDParam = '%' + @BranchID + '%'

	select @IndividualEmp as 'IndividualEmp',V.CardNo as 'ID', V.EmployeeName as 'Employee',V.Designation as 'Designation',V.Section as 'Department',
	MIN(U.LogTime) as 'TimeIn', MAX(U.LogTime) as 'TimeOut',dbo.fnGetAttStatus(V.EmployeeID,Convert(nvarchar,U.LogTime,101)) as 'Remarks'
	from vwEmpInfo V inner JOIN tblUserAttendance U 
	ON V.EmployeeID = U.EmployeeID
	And U.LogTime between @DateFromParam and @DateToParam
	where V.isActive = 1 and V.IncludedInPayroll = 1 
	And V.SectionID like @DepartmentIDParam
	And V.EmployeeID like @EmployeeIDParam
	--And V.ULCBranchID like @BranchIDParam
	And V.DesignationID like @DesignationIDParam
	And dbo.fnGetAttStatus(V.EmployeeID,Convert(nvarchar,U.LogTime,101)) like @AttStatusParam
	group by V.CardNo, V.EmployeeName,V.EmployeeID,V.Designation,V.Section,Convert(nvarchar,U.LogTime,101)
	--order by V.EmpCode,Designation,Department
	UNION ALL
	select @IndividualEmp as 'IndividualEmp',V.CardNo as 'ID', V.EmployeeName as 'Employee',V.Designation as 'Designation',V.Section as 'Department',
	LD.LeaveDate as 'TimeIn',LD.LeaveDate as 'TimeOut','on Leave' as 'Remarks'
	from vwEmpInfo V inner JOIN tblLeaveDetails LD ON V.EmployeeID=LD.EmployeeID And LD.LeaveDate between @DateFromParam and @DateToParam
	where V.isActive = 1 and V.IncludedInPayroll = 1 
	And V.SectionID like @DepartmentIDParam
	And V.EmployeeID like @EmployeeIDParam
	--And V.ULCBranchID like @BranchIDParam
	And V.DesignationID like @DesignationIDParam
	And dbo.fnGetAttStatus(V.EmployeeID,Convert(nvarchar,LD.LeaveDate,101)) like @AttStatusParam
	--UNION ALL
	--Select * from dbo.fnGetAbsentInfo(@EmployeeID,@DepartmentID,@BranchID,@DesignationID,@DateFrom,@DateTo,@AttStatus)
	--order by V.EmpCode,Designation,Department,TimeIn
end