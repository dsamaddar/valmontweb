-- exec spMaintainShiftDuty 'EMP-00003113','12-15-2019','12-20-2019','Evening'

alter proc spMaintainShiftDuty
@EmployeeID nvarchar(50),
@StartDate date,
@EndDate date,
@ShiftType nvarchar(50)
as
begin
	
	Declare @EndDateParam as datetime
	

	if @ShiftType = 'Evening'
	begin
		Set @EndDateParam = convert(datetime,convert(nvarchar,@EndDate,101) + ' 08:30:59 AM');

		update tblUserAttendance 
		Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM')
		,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM')
		where EmployeeID IN (@EmployeeID)
		And LogTime between @StartDate and @EndDateParam;
	end
	else if @ShiftType = 'Morning'
	begin
		Set @EndDateParam = convert(datetime,convert(nvarchar,@EndDate,101) + ' 08:30:59 PM');

		update tblUserAttendance 
		Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
		,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM')
		where EmployeeID IN (@EmployeeID)
		And LogTime between @StartDate and @EndDateParam;
	end
end


select * from tblEmployeeInfo where EmployeeID='EMP-00003113';

select * from tblSection;