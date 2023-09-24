
-- drop function fnCountLateIn
Create function fnCountLateIn(@EmployeeID nvarchar(50),@Year int,@Month int)
returns int
as
begin

	Declare @EICount as int Set @EICount = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	if @Month = 0
		set @MonthParam = '%'
	else
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'
		

	Declare @LateInTbl as table(
	LateInCount int
	);

	Insert into @LateInTbl
	select min(DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime))
	from tblUserAttendance U Where EmployeeID=@EmployeeID
	And DATEPART(YEAR,LogTime)=@Year and Convert(nvarchar,DATEPART(MONTH,LogTime)) like @MonthParam
	group by DATEPART(DAY,U.LogTime)
	having min(DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime)) > 0

	Select @EICount=Count(*) from @LateInTbl
	
	return ISNULL(@EICount,0);
end

--select dbo.fnCountLateIn('EMP-00000098',2017,2)

GO

Create function fnCountEarlyOut(@EmployeeID nvarchar(50),@Year int,@Month int)
returns int
as
begin

	Declare @EOCount as int Set @EOCount = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	if @Month = 0
		set @MonthParam = '%'
	else
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	Declare @EarlyOutTbl as table(
	LateInCount int
	);

	Insert into @EarlyOutTbl
	select DATEDIFF(MINUTE,max(U.LogTime),ISNULL(MAX(U.IdealLogOutTime),Convert(datetime, convert(nvarchar,MAX(U.LogTime),101) + ' 04:00:00 PM')))
	from tblUserAttendance U Where EmployeeID=@EmployeeID
	And DATEPART(YEAR,LogTime)=@Year and Convert(nvarchar,DATEPART(MONTH,LogTime)) like @MonthParam
	group by DATEPART(DAY,U.LogTime)
	having DATEDIFF(MINUTE,max(U.LogTime),ISNULL(MAX(U.IdealLogOutTime),Convert(datetime, convert(nvarchar,MAX(U.LogTime),101) + ' 04:00:00 PM'))) > 0

	Select @EOCount=Count(*) from @EarlyOutTbl
	
	return ISNULL(@EOCount,0);
end

-- select dbo.fnCountEarlyOut('EMP-00000098',2017,0)

GO

alter function fnCountHolidays(@year int, @month int)
returns int
as
begin
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalHoliday = Count(*)  from tblHolidays Where DATEPART(YEAR,HolidayDate)=@year
	and Convert(nvarchar,DATEPART(MONTH,HolidayDate)) like @MonthParam
	--and DATENAME(WEEKDAY,HolidayDate) <> 'Friday' {changed on: 20220819}

	return @TotalHoliday
end

-- select dbo.fnCountHolidays(2022,8)
GO

alter function fnCountHolidaysdtRange(@StartDate date, @EndDate date)
returns int
as
begin
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	
	select @TotalHoliday = Count(*)  from tblHolidays Where HolidayDate between @StartDate and @EndDate
	--and DATENAME(WEEKDAY,HolidayDate) <> 'Friday'{changed on: 20220819}

	return @TotalHoliday
end
-- select dbo.fnCountHolidaysdtRange('2022-08-01','2022-08-31')
GO

-- select dbo.fnCountNoWorkdays('EMP-00001770',2022,8)

alter function fnCountNoWorkdays(@EmployeeID nvarchar(50),@year int, @month int)
returns int
as
begin
	Declare @TotalNoWorkDay as int Set @TotalNoWorkDay = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalNoWorkDay = Count(*)  from tblNoWorkDay Where DATEPART(YEAR,NoWorkDay)=@year
	and Convert(nvarchar,DATEPART(MONTH,NoWorkDay)) like @MonthParam
	--and DATENAME(WEEKDAY,NoWorkDay) <> 'Friday' {changed on: 20220819}
	And EmployeeID = @EmployeeID

	return isnull(@TotalNoWorkDay,0)
end

GO

Create function fnCountNoWorkdaysdtRange(@EmployeeID nvarchar(50),@StartDate date, @EndDate date)
returns int
as
begin
	Declare @TotalNoWorkDay as int Set @TotalNoWorkDay = 0
	
	select @TotalNoWorkDay = Count(*)  from tblNoWorkDay 
	Where 
	NoWorkDay between @StartDate and @EndDate
	and DATENAME(WEEKDAY,NoWorkDay) <> 'Friday'
	And EmployeeID = @EmployeeID

	return isnull(@TotalNoWorkDay,0)
end

GO
--select dbo.fnCountWeekEnd(2021,6)

alter function fnCountWeekEnd(@year int, @month int)
returns int
as
begin
	Declare @TotalWeekEnd as int Set @TotalWeekEnd = 0
	Declare @StartOfMonth as date
	Declare @EndofMonth as date
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'


	SELECT @StartOfMonth = Convert(date,convert(nvarchar,@month)+'/01/'+convert(nvarchar,@year))--DATEADD(MM,DATEDIFF(MM,0,'01/'),0);
    SELECT @EndofMonth   = DATEADD(MM,DATEDIFF(MM,0,DATEADD(MM,1,@StartOfMonth)),-1)

	While @StartOfMonth <= @EndofMonth
	begin
		if DATENAME(WEEKDAY,@StartOfMonth)='Friday' and @StartOfMonth <= '2022-08-16'
			Set @TotalWeekEnd += 1;
		else if DATENAME(WEEKDAY,@StartOfMonth)='Wednesday' and @StartOfMonth > '2022-08-16'
			Set @TotalWeekEnd += 1;
		
		Set @StartOfMonth = DATEADD(DAY,1,@StartOfMonth)
	end

	return @TotalWeekEnd
end

GO

Create function fnCountCompensatoryLeave(@year int, @month int)
returns int
as
begin
	Declare @Total as int Set @Total = 0
	Declare @StartOfMonth as date
	Declare @EndofMonth as date
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'


	SELECT @StartOfMonth = Convert(date,convert(nvarchar,@month)+'/01/'+convert(nvarchar,@year))--DATEADD(MM,DATEDIFF(MM,0,'01/'),0);
    SELECT @EndofMonth   = DATEADD(MM,DATEDIFF(MM,0,DATEADD(MM,1,@StartOfMonth)),-1)

	select @Total = count(*) from tblCompensatoryLeave where CompensatoryDate between @StartOfMonth and @EndofMonth

	return @Total
end

-- select dbo.fnCountCompensatoryLeave(2021,2)

GO

alter function fnCountWeekEnddtRange(@StartDate date, @EndDate date)
returns int
as
begin
	Declare @TotalWeekEnd as int Set @TotalWeekEnd = 0

	While @StartDate <= @EndDate
	begin
		if DATENAME(WEEKDAY,@StartDate)='Friday' and @StartDate <= '2022-08-16'
			Set @TotalWeekEnd += 1;
		else if DATENAME(WEEKDAY,@StartDate)='Wednesday' and @StartDate > '2022-08-16'
			Set @TotalWeekEnd += 1;
		
		Set @StartDate = DATEADD(DAY,1,@StartDate)
	end

	return @TotalWeekEnd
end


GO

-- select * from tblEmployeeInfo where EmpCode like '%13208%'
-- select dbo.fnCountAbsent('EMP-00004302',2022,4)
alter function fnCountAbsent(@EmployeeID nvarchar(50),@year int, @month int)
returns int
as
begin
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @TotalWorkingDay as int Set @TotalWorkingDay = 0
	Declare @TotalWeekEnd as int Set @TotalWeekEnd = 0
	Declare @TotalOnLeave as int Set @TotalOnLeave = 0
	Declare @TotalNoWorkDay as int Set @TotalNoWorkDay = 0
	Declare @TotalCompensatoryLeave as int Set @TotalCompensatoryLeave = 0;
	Declare @TotalLeaveExpAbsent as int Set @TotalLeaveExpAbsent = 0;
	Declare @TotalUnEmployedDays as int Set @TotalUnEmployedDays = 0;
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	Declare @TotalPresent as int Set @TotalPresent = 0


	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%';
	Set @TotalOnLeave = dbo.fnCountOnLeave(@EmployeeID,@year,@month)
	Set @TotalNoWorkDay = dbo.fnCountNoWorkdays(@EmployeeID,@year,@month)

	select @TotalHoliday = dbo.fnCountHolidays(@year,@month)
	select @TotalWorkingDay = dbo.fnCountWorkingDay(@year,@month)
	Select @TotalWeekEnd = dbo.fnCountWeekEnd(@year,@month)
	Select @TotalCompensatoryLeave = dbo.fnCountCompensatoryLeave(@year,@month);
	Set @TotalUnEmployedDays = dbo.fnCountUnEmployed(@EmployeeID,@year,@month);

	select @TotalPresent=count(*) from (
	Select distinct convert(nvarchar,U.LogTime,106) as 'm' from tblUserAttendance U 
	Where U.EmployeeID = @EmployeeID And YEAR(U.LogTime) = @year And MONTH(U.LogTime)= @month
	And DATENAME(WEEKDAY,convert(nvarchar,U.LogTime,106)) <> 'Friday' and U.LogTime <= '2022-08-16'
	And U.AuthStatus='A'
	UNION ALL
	Select distinct convert(nvarchar,U.LogTime,106) as 'm' from tblUserAttendance U 
	Where U.EmployeeID = @EmployeeID And YEAR(U.LogTime) = @year And MONTH(U.LogTime)= @month
	And DATENAME(WEEKDAY,convert(nvarchar,U.LogTime,106)) <> 'Wednesday' and U.LogTime > '2022-08-16'
	And U.AuthStatus='A'
	) as V;

	--Set @TotalAbsent = @TotalWorkingDay - @TotalHoliday - @TotalPresent - @TotalOnLeave - @TotalNoWorkDay - @TotalUnEmployedDays - @TotalWeekEnd
	Set @TotalAbsent = @TotalWorkingDay - @TotalPresent - @TotalOnLeave - @TotalNoWorkDay - @TotalUnEmployedDays - @TotalWeekEnd

	if @TotalAbsent < = 0
		Set @TotalAbsent = 0;

	-- counting leave exceptions
	select @TotalAbsent += CASE WHEN dbo.fnGetAttStatus(@EmployeeID,ExceptionDate) = 'Absent' THEN 1 ELSE 0
	END  from tblExceptions where YEAR(ExceptionDate) = @year and MONTH(ExceptionDate) = @month;

	return @TotalAbsent;
end

GO

-- select * from tblEmployeeInfo where EmpCode='10216'
-- select dbo.fnCountAbsentdtRange('EMP-00000826','4/26/2022','5/31/2022')

alter function fnCountAbsentdtRange(@EmployeeID nvarchar(50),@StartDate date, @EndDate date)
returns int
as
begin
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @TotalWorkingDay as int Set @TotalWorkingDay = 0
	Declare @TotalWeekEnd as int Set @TotalWeekEnd = 0
	Declare @TotalOnLeave as int Set @TotalOnLeave = 0
	Declare @TotalNoWorkDay as int Set @TotalNoWorkDay = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	Declare @TotalPresent as int Set @TotalPresent = 0

	Set @TotalOnLeave = dbo.fnCountOnLeavedtRange(@EmployeeID,@StartDate,@EndDate)
	Set @TotalNoWorkDay = dbo.fnCountNoWorkdaysdtRange(@EmployeeID,@StartDate,@EndDate)

	select @TotalHoliday = dbo.fnCountHolidaysdtRange(@StartDate,@EndDate)
	select @TotalWorkingDay =DATEDIFF(DAY,@startDate,@EndDate); -- dbo.fnCountWorkingDaydtRange(@StartDate,@EndDate)
	Select @TotalWeekEnd = dbo.fnCountWeekEnddtRange(@StartDate,@EndDate)

	select @TotalPresent=count(*) from (
	Select distinct convert(nvarchar,U.LogTime,106) as 'm' from tblUserAttendance U 
	Where U.EmployeeID = @EmployeeID 
	And U.LogTime between @StartDate and @EndDate
	And DATENAME(WEEKDAY,convert(nvarchar,U.LogTime,106)) <> 'Friday' and U.LogTime <= '2022-08-16'
	And U.AuthStatus='A'
	UNION ALL
	Select distinct convert(nvarchar,U.LogTime,106) as 'm' from tblUserAttendance U 
	Where U.EmployeeID = @EmployeeID 
	And U.LogTime between @StartDate and @EndDate
	And DATENAME(WEEKDAY,convert(nvarchar,U.LogTime,106)) <> 'Wednesday' and U.LogTime > '2022-08-16'
	And U.AuthStatus='A'
	) as V;

	Set @TotalAbsent = @TotalWorkingDay - @TotalPresent - @TotalOnLeave - @TotalWeekEnd - @TotalNoWorkDay - @TotalHoliday

	if @TotalAbsent < = 0
		Set @TotalAbsent = 0;

	return @TotalAbsent;
end

GO

-- select dbo.fnCountWorkingDay(2021,5);

alter function fnCountWorkingDay(@year int, @month int)
returns int
as
begin
	
	Declare @TotalWorkingDay as int Set @TotalWorkingDay = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @DaysInYear as int Set @DaysInYear = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	Declare @TotalCompensatoryLeave as int Set @TotalCompensatoryLeave = 0;
	Select @TotalCompensatoryLeave = dbo.fnCountCompensatoryLeave(@year,@month);

	if @Month = 0
	begin
		set @MonthParam = '%'
		Set @DaysInYear = DATEDIFF(DAY,DATEADD(DD,-DATEPART(DY,GETDATE())+1,GETDATE()), DATEADD(DD,-1,DATEADD(YY,DATEDIFF(YY,0,GETDATE())+1,0)))
	end
	else
	begin
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'
		Set @DaysInYear = DAY(EOMONTH(Convert(nvarchar,@month)+'/01/'+Convert(nvarchar,@year)))
	end

	select @TotalHoliday = Count(*)  from tblHolidays Where DATEPART(YEAR,HolidayDate)=@year
	and Convert(nvarchar,DATEPART(MONTH,HolidayDate)) like @MonthParam
	and DATENAME(WEEKDAY,HolidayDate) <> 'Friday'

	Set @TotalWorkingDay = @DaysInYear - @TotalHoliday - @TotalCompensatoryLeave
	
	return isnull(@TotalWorkingDay,0);
end

--select dbo.fnCountWorkingDay(2017,6)

GO
-- select dbo.fnCountWorkingDaydtRange('07/01/2020','07/31/2020')

alter function fnCountWorkingDaydtRange(@StartDate date, @EndDate date)
returns int
as
begin
	
	Declare @TotalWorkingDay as int Set @TotalWorkingDay = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @DaysInRange as int Set @DaysInRange = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	Set @DaysInRange = DATEDIFF(DAY,@StartDate,@EndDate)+1

	select @TotalHoliday = Count(*)  from tblHolidays 
	Where HolidayDate between @StartDate and @EndDate
	and DATENAME(WEEKDAY,HolidayDate) <> 'Friday'

	Set @TotalWorkingDay = @DaysInRange - @TotalHoliday
	
	return isnull(@TotalWorkingDay,0);
end


GO

Create function fnCountWKH(@EmployeeID nvarchar(50),@Year int,@Month int)
returns numeric(18,2)
as
begin

	Declare @TotalWKH as numeric(18,2) Set @TotalWKH = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	if @Month = 0
		set @MonthParam = '%'
	else
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalWKH = @TotalWKH + Convert(numeric(18,2),DATEDIFF(MINUTE,min(U.LogTime),Max(U.LogTime)))
	from tblUserAttendance U Where EmployeeID=@EmployeeID
	And DATEPART(YEAR,LogTime)=@Year 
	and Convert(nvarchar,DATEPART(MONTH,LogTime)) like @MonthParam
	group by DATEPART(DAY,U.LogTime)

	return 	ISNULL(@TotalWKH,0)/60
end

-- select dbo.fnCountWKH('EMP-00000098',2017,0)


GO

alter function fnCountOnLeave(@EmployeeID nvarchar(50),@Year int,@Month int)
returns int
as
begin
	Declare @TotalOnLeave as numeric(18,2) Set @TotalOnLeave = 0;
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	if @Month = 0
		set @MonthParam = '%'
	else
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalOnLeave = Count(*) from tblLeaveDetails LD 
	Where EmployeeID=@EmployeeID
	and DATEPART(YEAR,LD.LeaveDate)=@Year 
	and Convert(nvarchar,DATEPART(MONTH,LD.LeaveDate)) like @MonthParam
	--and DATENAME(WEEKDAY,LeaveDate) <> 'Friday'

	return @TotalOnLeave;
end

GO

-- select dbo.fnCountUnEmployed('EMP-00004071',2021,5);

alter function fnCountUnEmployed(@EmployeeID nvarchar(50),@Year int,@Month int)
returns int
as
begin
	Declare @TotalUnEmploymentDays as int Set @TotalUnEmploymentDays = 0;
	Declare @JoiningDate as date
	Declare @StartDateOfMonth as date
	Declare @EndOfMonth as date
	Declare @TotalWeekEnds as int Set @TotalWeekEnds = 0;
	Declare @TotalCompensatoryLeave as int Set @TotalCompensatoryLeave = 0;

	Select @TotalCompensatoryLeave = dbo.fnCountCompensatoryLeave(@year,@month);

	Set @StartDateOfMonth = convert(date,convert(nvarchar,@month)+'/01/'+convert(nvarchar,@year));
	Set @EndOfMonth = EOMONTH(@StartDateOfMonth)

	Select @JoiningDate = JoiningDate from tblEmployeeInfo Where EmployeeID=@EmployeeID;

	IF @JoiningDate < @StartDateOfMonth
		Set @TotalUnEmploymentDays = 0;

	If @JoiningDate >= @StartDateOfMonth and @JoiningDate <= @EndOfMonth
	begin
		Set @TotalWeekEnds = dbo.fnCountWeekEnddtRange(@StartDateOfMonth,@JoiningDate);
		Set @TotalUnEmploymentDays = DATEDIFF(DAY,@StartDateOfMonth,@JoiningDate);
		Set @TotalUnEmploymentDays = @TotalUnEmploymentDays - @TotalWeekEnds - @TotalCompensatoryLeave
	end

	return @TotalUnEmploymentDays;
end

GO

-- select * from tblEmployeeInfo where EmpCode='10213';
-- select dbo.fnCountOnLeavedtRange('EMP-00000818','2022-04-26','2022-05-31')
Create function fnCountOnLeavedtRange(@EmployeeID nvarchar(50),@StartDate date,@EndDate date)
returns int
as
begin
	Declare @TotalOnLeave as numeric(18,2) Set @TotalOnLeave = 0

	select @TotalOnLeave = Count(*) from tblLeaveDetails LD 
	Where EmployeeID=@EmployeeID
	and LD.LeaveDate between @StartDate and @EndDate
	and DATENAME(WEEKDAY,LeaveDate) <> 'Friday'

	return @TotalOnLeave;
end
-- select dbo.fnCountOnLeave('EMP-00000098',2017,0)
GO

-- select dbo.fnMeasureOTHrs('EMP-00000437','2019-01-01')

alter function fnMeasureOTHrs(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	Declare @OutTime datetime
	Declare @IdealLogOutTime datetime

	Select @OutTime=MAX(LogTime),@IdealLogOutTime=MAX(IdealLogOutTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)
	And AuthStatus='A'


	return DATEDIFF(MINUTE,@IdealLogOutTime,@OutTime) 
end

GO

-- select dbo.fnMeasureOTHrsCom('EMP-00001405','Apr 24 2021  7:01PM')
alter function fnMeasureOTHrsCom(@EmployeeID nvarchar(50),@Date datetime)
returns int
as
begin
	
	Declare @OutTime datetime
	Declare @IdealLogOutTime datetime

	Select @IdealLogOutTime=Max(IdealLogOutTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID 
	--And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)
	And MONTH(LogTime) = MONTH(@Date)
	And YEAR(LogTime) = YEAR(@Date)
	And DAY(LogTime) = DAY(@Date)
	And AuthStatus='A'

	return DATEDIFF(MINUTE,@IdealLogOutTime,@Date)
end

GO

-- select dbo.fnMeasureOTHrsComShifting('EMP-00001560','2022-04-01 07:03:00.000')
alter function fnMeasureOTHrsComShifting(@EmployeeID nvarchar(50),@Date datetime)
returns int
as
begin
	
	Declare @OutTime datetime
	Declare @IdealLogOutTime datetime
	Declare @OT as int Set @OT = 0;

	Declare @MorningShift as datetime Set @MorningShift = convert(nvarchar,@Date,101) + ' 5:00 AM';
	Declare @EveningShift as datetime Set @EveningShift = convert(nvarchar,@Date,101) + ' 5:00 PM';
	Declare @MorningShiftEnds as datetime Set @MorningShiftEnds = convert(nvarchar,@Date,101) + ' 9:00 AM';


	if @Date > @MorningShift and @Date < @MorningShiftEnds
	begin
		Set @OT = DATEDIFF(MINUTE,@MorningShift,@Date)
	end
	else
		Set @OT = DATEDIFF(MINUTE,@EveningShift,@Date)
	
	return @OT;
end

--select convert(nvarchar,getdate(),101);

GO

alter function fnMeasureLateHrs(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	Declare @LogTime datetime
	Declare @IdealLogInTime datetime

	Select @LogTime=MIN(LogTime),@IdealLogInTime=MIN(IdealLogTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)
	And AuthStatus='A'

	if DATEDIFF(MINUTE,@IdealLogInTime,@LogTime) < 0
		return 0

	return DATEDIFF(MINUTE,@IdealLogInTime,@LogTime)
end

GO

alter function fnCountHalfAbsent(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	Declare @MaxLogTime datetime
	Declare @HalfTime datetime

	Set @HalfTime = Convert(datetime, Convert(nvarchar,@Date,101)+ ' 02:00:00 PM')
	Select @MaxLogTime=min(LogTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)

	if @MaxLogTime > @HalfTime
		return 1

	return 0;
end

GO

Create function fnCountHalfAbsentShifting(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	return 0;
end

GO

-- select * from tblEmployeeInfo Where EmpCode like '%10208%'
-- exec spReportEmpJobCard 'EMP-00000811','ALL','2022','05'

alter proc spReportEmpJobCard
@EmployeeID nvarchar(50),
@SectionID nvarchar(50),
@year varchar(4),
@month varchar(2)
as
begin

	Declare @ReportMonth as nvarchar(10) Set @ReportMonth = '';
	Declare @EmployeeIDParam as nvarchar(50) set @EmployeeIDParam = '';
	Declare @SectionIDParam as nvarchar(50) set @SectionIDParam = '';
	Declare @InterimDate date;
	Declare @StartDate date;
	Declare @EndDate date;

	if exists(select * from tbl_job_card_rpt_dt_range where rpt_year=convert(int,@year) and rpt_month=convert(int,@month))
	begin
		select @StartDate = rpt_dt_starts,@EndDate = rpt_dt_ends from tbl_job_card_rpt_dt_range where rpt_year=convert(int,@year) and rpt_month=convert(int,@month);
	end
	else
	begin
		Set @StartDate = @month+'/01/'+@year;
		Set @EndDate = EOMONTH(@StartDate)
	end


	if @EmployeeID = 'ALL'
		Set @EmployeeIDParam = '%';
	else
		Set @EmployeeIDParam = '%' + @EmployeeID + '%';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	Declare @emp_tbl as table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(20),
	CardNo nvarchar(20),
	JoiningDate date,
	Taken bit default 0
	);

	Insert Into @emp_tbl(EmployeeID,EmployeeName,Designation,Section,MachineNo,CardNo,JoiningDate)
	Select E.EmployeeID,E.EmployeeName,D.Designation,S.Section,ISNULL(MachineNo,'-'),E.CardNo,E.JoiningDate
	from tblEmployeeInfo E Inner Join tblSection S ON E.SectionID = S.SectionID
	Inner Join tblDesignation D ON E.DesignationID = D.DesignationID
	Where E.EmployeeID like @EmployeeIDParam And E.SectionID like @SectionIDParam And E.isActive=1

	Declare @att_tbl table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(50),
	CardNo nvarchar(20),
	JoiningDate date,
	AttDate date,
	AttDay varchar(10),
	AttStatus varchar(10),
	InTime datetime,
	OutTime datetime,
	OverTimeHours int,
	OTHr int,
	OTMin int,
	LateHours int,
	LTHr int,
	LTMin int,
	TotalLeave int,
	TotalAbsent int,
	TotalHoliday int
	);

	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0

	Declare @EmployeeName as nvarchar(50) Set @EmployeeName = ''
	Declare @Designation as nvarchar(50) Set @Designation = ''
	Declare @Section as nvarchar(50) Set @Section = ''
	Declare @MachineNo as nvarchar(50) Set @MachineNo = ''
	Declare @CardNo as nvarchar(50) Set @CardNo = ''
	Declare @JoiningDate as date
	Declare @InTime datetime
	Declare @OutTime datetime
	Declare @AttDay as varchar(10) Set @AttDay = ''
	Declare @AttStatus as varchar(20) Set @AttStatus = ''
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0

	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)


	Select @NCount = Count(*) from @emp_tbl;

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@Section=Section,@MachineNo=MachineNo,
		@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @TotalAbsent = dbo.fnCountAbsent(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @TotalLeave = dbo.fnCountOnLeave(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @InterimDate = @StartDate

		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			Set @OTHours = dbo.fnMeasureOTHrs(@EmployeeID,convert(nvarchar,@InterimDate,101))

			if @OTHours < 0
				Set @OTHours = 0
			
			Set @LateHours = dbo.fnMeasureLateHrs(@EmployeeID,@InterimDate)

			--If @AttStatus <> 'Absent' And @AttStatus <> 'Holiday'
			--begin

				Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
				from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)

				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLeave,TotalHoliday,TotalAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@OutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLeave,@TotalHoliday,@TotalAbsent)
			--end
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1
	end

	Select * from @att_tbl
	
end

GO

-- exec spReportEmpJobCardCompliance 'ALL','SEC-00000024','ALL','2019','08'
-- select * from tblEmployeeInfo E where E.EmpCode like '%10208%'
-- exec spReportEmpJobCardCompliance 'EMP-00000589','ALL','ALL',2021,05
-- select * from tblUserAttendance where EmployeeID='EMP-00000589' and LogTime >= '4/1/2021';
GO
-- exec spReportEmpJobCardCompliance 'EMP-00003762','ALL','ALL','2022','9'
-- exec spReportEmpJobCardCompliance 'EMP-00003155','ALL','ALL','2022','9'
-- select dbo.fnMeasureOTHrsCom('EMP-00000006','Jun  1 2020  6:56PM')

alter proc spReportEmpJobCardCompliance
@EmployeeID nvarchar(50),
@SectionID nvarchar(50),
@BlockID nvarchar(50),
@year varchar(4),
@month varchar(2)
as
begin
SET NOCOUNT ON
	Declare @ReportMonth as nvarchar(10) Set @ReportMonth = ''
	Declare @EmployeeIDParam as nvarchar(50) set @EmployeeIDParam = ''
	Declare @SectionIDParam as nvarchar(50) set @SectionIDParam = ''
	Declare @BlockIDParam as nvarchar(50) set @BlockIDParam = ''
	Declare @StartDate date;
	Declare @InterimDate date;
	Declare @EndDate date;

	if exists(select * from tbl_job_card_rpt_dt_range where rpt_year=convert(int,@year) and rpt_month=convert(int,@month))
	begin
		select @StartDate = rpt_dt_starts,@EndDate = rpt_dt_ends from tbl_job_card_rpt_dt_range where rpt_year=convert(int,@year) and rpt_month=convert(int,@month);
	end
	else
	begin
		Set @StartDate = @month+'/01/'+@year;
		Set @EndDate = EOMONTH(@StartDate)
	end

	if @EmployeeID = 'ALL'
		Set @EmployeeIDParam = '%';
	else
		Set @EmployeeIDParam = '%' + @EmployeeID + '%';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	if @BlockID = 'ALL'
		Set @BlockIDParam = '%'
	else
		Set @BlockIDParam = '%' + @BlockID + '%'

	Declare @emp_tbl as table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	SectionID nvarchar(50),
	Section nvarchar(50),
	Block nvarchar(50),
	MachineNo nvarchar(20),
	CardNo nvarchar(20),
	JoiningDate date,
	Taken bit default 0
	);

	Insert Into @emp_tbl(EmployeeID,EmployeeName,Designation,SectionID,Section,Block,MachineNo,CardNo,JoiningDate)
	Select E.EmployeeID,E.EmployeeName,D.Designation,S.SectionID,ISNULL(S.Section,'N\A'),ISNULL(B.Block,'N\A'),ISNULL(MachineNo,'-'),E.CardNo,E.JoiningDate
	from tblEmployeeInfo E 
	Left outer Join tblSection S ON E.SectionID = S.SectionID
	Left outer Join tblDesignation D ON E.DesignationID = D.DesignationID
	Left outer join tblBlocks B ON E.BlockID = B.BlockID
	Where E.EmployeeID like @EmployeeIDParam 
	And E.SectionID like @SectionIDParam
	And (E.BlockID like @BlockIDParam or E.BlockID is null)
	And E.isActive=1

	Declare @att_tbl table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	Section nvarchar(50),
	Block nvarchar(50),
	MachineNo nvarchar(50),
	CardNo nvarchar(20),
	JoiningDate date,
	AttDate date,
	AttDay varchar(10),
	AttStatus varchar(20),
	InTime datetime,
	OutTime datetime,
	OverTimeHours int,
	OTHr int,
	OTMin int,
	LateHours int,
	LTHr int,
	LTMin int,
	TotalLateIn int,
	TotalLeave int,
	TotalAbsent int,
	TotalHoliday int,
	HalfAbsent numeric(5,2)
	);

	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0

	Declare @EmployeeName as nvarchar(50) Set @EmployeeName = ''
	Declare @Designation as nvarchar(50) Set @Designation = ''
	Declare @SectionIDCom as nvarchar(50) Set @SectionIDCom = ''
	Declare @Section as nvarchar(50) Set @Section = ''
	Declare @Block as nvarchar(50) Set @Block = ''
	Declare @MachineNo as nvarchar(50) Set @MachineNo = ''
	Declare @CardNo as nvarchar(50) Set @CardNo = ''
	Declare @JoiningDate as date
	Declare @InTime as datetime
	Declare @OutTime as datetime
	Declare @AttDay as varchar(10) Set @AttDay = ''
	Declare @AttStatus as varchar(20) Set @AttStatus = ''
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidaysdtRange(@StartDate,@EndDate)
	Declare @TotalUnEmployedDays as int Set @TotalUnEmployedDays = 0;

	Declare @ComplianceInTime as datetime
	Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''

	Select @NCount = Count(*) from @emp_tbl;

	--print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@Block=ISNULL(Block,'N\A'),
		@MachineNo=MachineNo,@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @TotalLateIn = dbo.fnCountLateIn(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		--Set @TotalUnEmployedDays = dbo.fnCountUnEmployed(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate));
		
		Set @TotalAbsent = dbo.fnCountAbsentdtRange(@EmployeeID,@StartDate,@EndDate)
		--print 'Total Absent : ' + convert(nvarchar,@TotalAbsent)
		--Set @TotalAbsent -= @TotalUnEmployedDays;
		Set @TotalLeave = dbo.fnCountOnLeavedtRange(@EmployeeID,@StartDate,@EndDate);--dbo.fnCountOnLeave(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @InterimDate = @StartDate

		print 'Total Absent: ' + convert(nvarchar,@TotalAbsent);
		--set @TotalAbsent = @TotalAbsent - @TotalHoliday;

		--- Finding Ideal Logout Time for the Section
		If @Section <> 'N\A'
		begin
			Declare @SelectedSectionID as nvarchar(50) Set @SelectedSectionID = ''
			Select @SelectedSectionID=SectionID from tblSection Where Section = @Section
			-- for other regular times enable below line
			Select @SecIdealLogoutTime = IdealLogoutTime,@ComplianceInTimeText=IdealLoginTime from tblSection Where SectionID=@SelectedSectionID
			-- for ramadan enable below line
			-- Select @SecIdealLogoutTime = IdealLogout,@ComplianceInTimeText=IdealLoginTime from tblSection Where SectionID=@SelectedSectionID
		end
		else
		begin
			Select @ComplianceInTimeText = PropertyValue from tblAppSettings Where PropertyName='IdealLoginTime';
			Select @SecIdealLogoutTime = PropertyValue from tblAppSettings Where PropertyName='IdealLogoutTime';
		end

		--print 'Second Ideal Logout Time : ' + convert(nvarchar,ISNULL(@SecIdealLogoutTime,'N\A'));

		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			--If @AttDay = 'Friday'
				--print 'Friday: ' + convert(nvarchar,@InterimDate,106)
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)
			print 'Att Status : ' + @AttStatus

			--Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @SecIdealLogoutTime)
			--select @ComplianceOutTime = DATEADD(HOUR,2,u.IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106);
			select @ComplianceOutTime = u.IdealLogOutTime from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106) and u.AuthStatus='A';
			
						
			--Print 'Compliance Out Time : ' + Convert(nvarchar,@ComplianceOutTime)
			--Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)

			select @ComplianceInTime = max(IdealLogTime) from tblUserAttendance where EmployeeID = @EmployeeID and convert(nvarchar,LogTime,106) = convert(nvarchar,@InterimDate,106) and AuthStatus='A'

			--Print 'Compliance In Time : ' + Convert(nvarchar,@ComplianceInTime)
			Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@InterimDate)

			if @OTHours < 0
				Set @OTHours = 0
			
			Set @LateHours = dbo.fnMeasureLateHrs(@EmployeeID,@InterimDate)
			

			--print 'Half Absent : ' + convert(nvarchar,ISNULL(@InterimDate,'N\A')) + ' Count: '+ convert(nvarchar,@HalfAbsent);
			If @AttStatus <> 'Absent' And @AttStatus <> 'Holiday' And @AttStatus <> 'on Leave'
				Set @HalfAbsent = dbo.fnCountHalfAbsent(@EmployeeID,@InterimDate) * 0.5;
			else
				Set @HalfAbsent = 0;

			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A'
			--print 'AA'
			--print 'Actual Logout Time : ' + convert(nvarchar,ISNULL(@OutTime,'N\A'))

			If (@SectionIDCom != 'SEC-00000032')
			begin
				If DATEDIFF(MINUTE,@InTime,@ComplianceInTime) > 30
				begin
					SET @InTime = DATEADD(MINUTE,(DATEDIFF(MINUTE,@InTime,@ComplianceInTime))-(FLOOR(RAND()*(20-10+1))+10),@InTime);
					print 'In Time : ' + convert(nvarchar,@InTime);
				end
			end

			--print 'In Time : ' + convert(nvarchar,@InTime);
			
			/*
			Declare @random_minute as int set @random_minute = FLOOR(RAND()*10);
			if @OutTime > @ComplianceOutTime
			begin
				Set @OutTime = DATEADD(MINUTE,-@random_minute,@ComplianceOutTime); 
			end
			*/
			--print 'BB'	
			--print 'Modified Logout Time : ' + convert(nvarchar,ISNULL(@OutTime,'N\A'));
			--print 'Attendance Status : ' + @AttStatus;
			--print 'Compliance Out Time : ' + convert(nvarchar,ISNULL(@ComplianceOutTime,'N\A'));
				
			If @AttStatus <> 'Absent'
			begin
				--print 'X'
				Declare @IdealLogoutTime as datetime
				select @IdealLogoutTime = max(IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106) and AuthStatus='A'
			
				--print 'OUT TIME BF - '+ convert(nvarchar,@OutTime)
				If @OutTime > @ComplianceOutTime
				begin
					
					--else
					--begin
					--	Set @OutTime = DATEADD(HOUR,-2,@OutTime)
					--end
					print 'OUT TIME AF - '+ convert(nvarchar,@OutTime)
					
					if @OutTime > @ComplianceOutTime
					begin
						if @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000006' or @SectionIDCom = 'SEC-00000027'
						begin
							Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
						end
						else if @SectionIDCom = 'SEC-00000058' or @SectionIDCom = 'SEC-00000049' or @SectionIDCom = 'SEC-00000060'
						begin
							Set @OutTime = DATEADD(HOUR,-1,@OutTime)
							If @OutTime > DATEADD(HOUR,2,@ComplianceOutTime)
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
								SET @OutTime = DATEADD(HOUR,2,@OutTime)
							end
						end
						else if @SectionIDCom = 'SEC-00000032'
						begin
							if @OutTime > @ComplianceOutTime
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
							end
						end
						else if @SectionIDCom = 'SEC-00000001'
						begin
							If @OutTime > DATEADD(HOUR,2,@ComplianceOutTime)
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
								SET @OutTime = DATEADD(HOUR,2,@OutTime)
							end
						end
						else
						begin
							if @OutTime <= DATEADD(HOUR,2,@ComplianceOutTime)
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
							end
							else if @OutTime >= DATEADD(HOUR,4,@ComplianceOutTime)
							begin
								Declare @random_min as int set @random_min = 0;
								set @random_min = FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1);
								--Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' 19:' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
								set @OutTime = DATEADD(HOUR,2,@ComplianceOutTime)
								set @OutTime = DATEADD(MINUTE,@random_min,@OutTime);
							end
							else if @OutTime >= DATEADD(HOUR,2,@ComplianceOutTime) and @OutTime <= DATEADD(HOUR,4,@ComplianceOutTime)
							begin
								Declare @excess_time int set @excess_time = 0;
								Set @excess_time = DATEDIFF(MINUTE,DATEADD(HOUR,2,@ComplianceOutTime),@OutTime)
								Set @OutTime = DATEADD(MINUTE,@excess_time,@ComplianceOutTime);
							end
							else
								Set @OutTime = DATEADD(HOUR,-2,@OutTime)
						end
						/*
						if @SectionIDCom = 'SEC-00000027'
						begin
							--Set @ComplianceOutTime = DATEADD(HOUR,-2,@ComplianceOutTime)
							--print @ComplianceOutTime; 
							If @ComplianceOutTime >= '4/13/2021' and @ComplianceOutTime <= '5/14/2021'
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
							end
							else
							begin
								Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
							end
						end
						else
						begin
							Set @ComplianceOutTime = DATEADD(HOUR,-1,@ComplianceOutTime)
							Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
						end
						*/
						
					end
					
					Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
				end
				else
				begin
					If @OutTime > @IdealLogoutTime
					begin
						Set @OutTime = Convert(datetime, Convert(nvarchar,@IdealLogoutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@IdealLogoutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':560' )
					end
					
					Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
					
				end
				
				if @OTHours < 0
					Set @OTHours = 0;
				
				-- Resetting for ramadan 
				If @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032' or @SectionIDCom = 'SEC-00000043' or @SectionIDCom = 'SEC-00000044' or @SectionIDCom = 'SEC-00000051' or @SectionIDCom = 'SEC-00000052' or @SectionIDCom = 'SEC-00000053' or @SectionIDCom = 'SEC-00000054' or @SectionIDCom = 'SEC-00000055' or @SectionIDCom = 'SEC-00000056' or @SectionIDCom = 'SEC-00000059'
				begin
					Set @OTHours = 0;
				end
				
			end
			
			
			--print 'In Time : ' + convert(nvarchar,@InTime);
			Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
			Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@OutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			print '***********************************************'

			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1
	end

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,AttStatus='Weekend',HalfAbsent=0
	Where AttDay='Friday' and AttDate not in (select ExceptionDate from tblExceptions)
	And AttDate <= '08/16/2022';

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,AttStatus='Weekend',HalfAbsent=0
	Where AttDay='Wednesday' and AttDate not in (select ExceptionDate from tblExceptions)
	And AttDate >= '08/17/2022';

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where AttStatus='NoWorkDay'

	Update @att_tbl Set AttStatus = c.Remarks
	from @att_tbl a inner join tblCompensatoryLeave c on a.AttDate = c.CompensatoryDate
	where a.AttDate in (select CompensatoryDate from tblCompensatoryLeave) 
	and AttStatus not in ('on Leave');

	Update @att_tbl set OverTimeHours=ISNULL(OverTimeHours,0),OTHr=ISNULL(OTHr,0),OTMin=ISNULL(OTMin,0),
	LateHours=ISNULL(LateHours,0), LTHr = ISNULL(LTHr,0), LTMin=ISNULL(LTMin,0);
	
	Select * from @att_tbl;
	
end

GO

Create table tblExceptions(
ExceptionID int identity(1,1) primary key,
ExceptionDate date,
Remarks nvarchar(50)
);

GO
Insert into tblExceptions(ExceptionDate,Remarks)values('08/09/2019','Weekend')
GO

Create table tblCompensatoryLeave(
CompensatoryLeaveID int identity(1,1) primary key,
CompensatoryDate date,
Remarks nvarchar(50)
);

GO
Insert into tblCompensatoryLeave(CompensatoryDate,Remarks)values('08/15/2019','Compensatory');

GO

alter proc spReportInActiveEmpJobCardCompliance
@EmployeeID nvarchar(50),
@SectionID nvarchar(50),
@year varchar(4),
@month varchar(2)
as
begin

	Declare @ReportMonth as nvarchar(10) Set @ReportMonth = ''
	Declare @EmployeeIDParam as nvarchar(50) set @EmployeeIDParam = ''
	Declare @SectionIDParam as nvarchar(50) set @SectionIDParam = ''
	Declare @StartDate date Set @StartDate = @month+'/01/'+@year;
	Declare @InterimDate date 
	Declare @EndDate date Set @EndDate = EOMONTH(@StartDate)

	if @EmployeeID = 'ALL'
		Set @EmployeeIDParam = '%';
	else
		Set @EmployeeIDParam = '%' + @EmployeeID + '%';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	Declare @emp_tbl as table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	SectionID nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(20),
	CardNo nvarchar(20),
	JoiningDate date,
	Taken bit default 0
	);

	Insert Into @emp_tbl(EmployeeID,EmployeeName,Designation,SectionID,Section,MachineNo,CardNo,JoiningDate)
	Select distinct E.EmployeeID,E.EmployeeName,D.Designation,S.SectionID,S.Section,ISNULL(MachineNo,'-'),E.CardNo,E.JoiningDate
	from tblEmployeeInfo E Inner Join tblSection S ON E.SectionID = S.SectionID
	Inner Join tblDesignation D ON E.DesignationID = D.DesignationID
	Inner Join tblUserAttendance A ON E.EmployeeID = A.EmployeeID
	Where E.EmployeeID like @EmployeeIDParam 
	And E.SectionID like @SectionIDParam
	And E.isActive=0
	And YEAR(A.LogTime)=@year And MONTH(A.LogTime)=@month

	Declare @att_tbl table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(50),
	CardNo nvarchar(20),
	JoiningDate date,
	AttDate date,
	AttDay varchar(10),
	AttStatus varchar(10),
	InTime datetime,
	OutTime datetime,
	OverTimeHours int,
	OTHr int,
	OTMin int,
	LateHours int,
	LTHr int,
	LTMin int,
	TotalLateIn int,
	TotalLeave int,
	TotalAbsent int,
	TotalHoliday int,
	HalfAbsent numeric(5,2)
	);

	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0

	Declare @EmployeeName as nvarchar(50) Set @EmployeeName = ''
	Declare @Designation as nvarchar(50) Set @Designation = ''
	Declare @SectionIDCom as nvarchar(50) Set @SectionIDCom = ''
	Declare @Section as nvarchar(50) Set @Section = ''
	Declare @MachineNo as nvarchar(50) Set @MachineNo = ''
	Declare @CardNo as nvarchar(50) Set @CardNo = ''
	Declare @JoiningDate as date
	Declare @InTime as datetime
	Declare @OutTime as datetime
	Declare @AttDay as varchar(10) Set @AttDay = ''
	Declare @AttStatus as varchar(20) Set @AttStatus = ''
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''

	Select @NCount = Count(*) from @emp_tbl;

	print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@MachineNo=MachineNo,
		@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @TotalLateIn = dbo.fnCountLateIn(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @TotalAbsent = dbo.fnCountAbsent(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @TotalLeave = dbo.fnCountOnLeave(@EmployeeID,DATEPART(YEAR,@StartDate),MONTH(@StartDate))
		Set @InterimDate = @StartDate

		--- Finding Ideal Logout Time for the Section
		If @Section <> 'N\A'
		begin
			Declare @SelectedSectionID as nvarchar(50) Set @SelectedSectionID = ''
			Select @SelectedSectionID=SectionID from tblSection Where Section = @Section
			Select @SecIdealLogoutTime = IdealLogoutTime from tblSection Where SectionID=@SelectedSectionID
		end
		else
		begin
			Select @SecIdealLogoutTime = PropertyValue from tblAppSettings Where PropertyName='IdealLogoutTime'
		end

		print @SecIdealLogoutTime

		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @SecIdealLogoutTime)
			Print 'Compliance Out Time : ' + Convert(nvarchar,@ComplianceOutTime)
			Set @OTHours = dbo.fnMeasureOTHrs(@EmployeeID,@InterimDate)

			if @OTHours < 0
				Set @OTHours = 0
			
			Set @LateHours = dbo.fnMeasureLateHrs(@EmployeeID,@InterimDate)
			Set @HalfAbsent = dbo.fnCountHalfAbsent(@EmployeeID,@InterimDate) * 0.5

			--If @AttStatus <> 'Absent' And @AttStatus <> 'Holiday'
			--begin

				Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
				from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)

				print @AttStatus
				print @ComplianceOutTime
				If @AttStatus <> 'Absent'
				begin
					if @OutTime > @ComplianceOutTime
					begin
						If DATEPART(MINUTE,@OutTime) > 30
						begin
							Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
							Set @OutTime = DATEADD(HOUR,-1,@OutTime)
							Print 'Out Time : ' + convert(nvarchar,@OutTime)
							Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
							Print 'OT Hour: A : ' + convert(nvarchar,@OTHours)
						end
						else
						begin
							Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(10-1)+1)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':560' )
							Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
							Print 'OT Hour: B : ' + convert(nvarchar,@OTHours)
						end
					
					end
					if @OTHours < 0
						Set @OTHours = 0;
					If @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032'
						Set @OTHours = 0; 
				end

				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@OutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			--end
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1
	end

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,AttStatus='Weekend',HalfAbsent=0
	Where AttDay='Friday'

	Select * from @att_tbl;
	
end

select * from tblSection where Section like '%OFFICe%'

GO

Declare @ComplianceOutTime as datetime
Set @ComplianceOutTime = 'Jul  3 2018  5:00PM'
Declare @A as datetime
Set @A = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
Select @A

-- exec spReportEmpJobCardCompliance 'ALL','SEC-00000015','2018','07'

GO


-- Finding Second & Milisecond Part
Select Convert(nvarchar,getdate(),113)
Select SUBSTRING(Convert(nvarchar,getdate(),113),18,7)
Select DATEPART(SECOND,getdate())
Select DATEPART(MILLISECOND,getdate())


--Selecting Random Number From 50 to 59
select FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50)

Select DATEADD(HOUR,-1,GETDATE())

GO

ALTER proc spReportEmpJobCardShifting
@EmployeeID nvarchar(50),
@SectionID nvarchar(50),
@year int,
@month int
as
begin
	
	Declare @EmpID as nvarchar(50)
	Declare @EmployeeIDParam as nvarchar(50)
	Declare @SectionIDParam as nvarchar(50)

	If @EmployeeID = 'ALL'
		Set @EmployeeIDParam = '%';
	else
		Set @EmployeeIDParam = '%'+ @EmployeeID +'%';

	If @SectionID = 'ALL'
		Set @SectionIDParam = '%';
	else
		Set @SectionIDParam = '%'+ @SectionID +'%';
	
	Declare @Count as int Set @Count=1;
	Declare @NCount as int Set @NCount=0;
	Declare @SLNO as int Set @SLNO=0;

	Declare @Att as table(
	EmployeeID nvarchar(50),
	EmployeeName nvarchar(50),
	Designation nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(50),
	CardNo nvarchar(20),
	JoiningDate date,
	AttDate date,
	AttDay varchar(10),
	AttStatus varchar(20),
	InTime datetime,
	OutTime datetime,
	OverTimeHours int,
	OTHr int,
	OTMin int,
	LateHours int,
	LTHr int,
	LTMin int,
	TotalLateIn int,
	TotalLeave int,
	TotalAbsent int,
	TotalHoliday int,
	HalfAbsent numeric(5,2)
	)

	Declare @EmpTbl as table(
	SLNO int identity(1,1),
	EmployeeID nvarchar(50),
	Taken bit default 0
	);

	Insert Into @EmpTbl(EmployeeID)
	Select EmployeeID from tblEmployeeInfo E INNER JOIN tblSection S ON E.SectionID=S.SectionID
	Where E.EmployeeID like @EmployeeIDParam And E.SectionID like @SectionIDParam
	And E.IsActive=1 And S.IsSpecial=1

	Select @NCount=Count(*) from @EmpTbl;

	While @Count <= @NCount
	begin
		Select top 1 @SLNO=SLNO,@EmpID=EmployeeID from @EmpTbl Where Taken=0;

		Insert Into @Att
		Select * from dbo.fnGetAttForShifting(@EmpID,@year,@month) order by convert(date,AttDate)

		Update @EmpTbl Set Taken=1 Where SLNO=@SLNO;
		Set @Count += 1;
	end

	 select * from @Att order by EmployeeID,convert(date,AttDate);
end
