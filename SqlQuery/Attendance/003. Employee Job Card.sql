
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

Create function fnCountHolidays(@year int, @month int)
returns int
as
begin
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalHoliday = Count(*)  from tblHolidays Where DATEPART(YEAR,HolidayDate)=@year
	and Convert(nvarchar,DATEPART(MONTH,HolidayDate)) like @MonthParam

	return @TotalHoliday
end

-- select dbo.fnCountHolidays(2018,6)

GO

Create function fnCountAbsent(@EmployeeID nvarchar(50),@year int, @month int)
returns int
as
begin
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @TotalOnLeave as int Set @TotalOnLeave = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''
	Declare @TotalPresent as int Set @TotalPresent = 0

	set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%';
	Set @TotalOnLeave = dbo.fnCountOnLeave(@EmployeeID,@year,@month)

	select @TotalHoliday = Count(*)  from tblHolidays Where DATEPART(YEAR,HolidayDate)=@year
	and Convert(nvarchar,DATEPART(MONTH,HolidayDate)) like @MonthParam

	Select @TotalPresent = Count(*) from tblUserAttendance U Where U.EmployeeID = @EmployeeID And YEAR(U.LogTime) = @year And MONTH(U.LogTime)= @month

	Set @TotalAbsent = dbo.fnCountWorkingDay(@year,@month) - @TotalHoliday - @TotalPresent - @TotalOnLeave

	return @TotalAbsent
end

GO

Create function fnCountWorkingDay(@year int, @month int)
returns int
as
begin
	
	Declare @TotalWorkingDay as int Set @TotalWorkingDay = 0
	Declare @TotalHoliday as int Set @TotalHoliday = 0
	Declare @DaysInYear as int Set @DaysInYear = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

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

	Set @TotalWorkingDay = @DaysInYear - @TotalHoliday
	
	return isnull(@TotalWorkingDay,0);
end

--select dbo.fnCountWorkingDay(2017,0)

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

Create function fnCountOnLeave(@EmployeeID nvarchar(50),@Year int,@Month int)
returns int
as
begin
	Declare @TotalOnLeave as numeric(18,2) Set @TotalOnLeave = 0
	Declare @MonthParam as nvarchar(50) Set @MonthParam = ''

	if @Month = 0
		set @MonthParam = '%'
	else
		set @MonthParam = '%'+ Convert(nvarchar,@Month) +'%'

	select @TotalOnLeave = Count(*) from tblLeaveDetails LD 
	Where EmployeeID=@EmployeeID
	and DATEPART(YEAR,LD.LeaveDate)=@Year 
	and Convert(nvarchar,DATEPART(MONTH,LD.LeaveDate)) like @MonthParam

	return @TotalOnLeave;
end
-- select dbo.fnCountOnLeave('EMP-00000098',2017,0)
GO

-- select dbo.fnMeasureOTHrs('EMP-00000951','2018-06-02')

Create function fnMeasureOTHrs(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	Declare @OutTime datetime
	Declare @IdealLogOutTime datetime

	Select @OutTime=MAX(LogTime),@IdealLogOutTime=Max(IdealLogOutTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)


	return DATEDIFF(MINUTE,@IdealLogOutTime,@OutTime)
end

GO

alter function fnMeasureLateHrs(@EmployeeID nvarchar(50),@Date date)
returns int
as
begin
	
	Declare @LogTime datetime
	Declare @IdealLogInTime datetime

	Select @LogTime=MIN(LogTime),@IdealLogInTime=MIN(IdealLogTime)
	from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@Date,101)

	if DATEDIFF(MINUTE,@IdealLogInTime,@LogTime) < 0
		return 0

	return DATEDIFF(MINUTE,@IdealLogInTime,@LogTime)
end

GO

-- select * from tblEmployeeInfo Where EmployeeName like '%sumon%'
-- exec spReportEmpJobCard 'ALL','SEC-00000015','2018','06'

alter proc spReportEmpJobCard
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

			Set @OTHours = dbo.fnMeasureOTHrs(@EmployeeID,@InterimDate)

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
-- exec spReportEmpJobCardCompliance 'ALL','SEC-00000024','2018','07'

alter proc spReportEmpJobCardCompliance
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
	Declare @InTime as datetime
	Declare @OutTime as datetime
	Declare @AttDay as varchar(10) Set @AttDay = ''
	Declare @AttStatus as varchar(20) Set @AttStatus = ''
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0

	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''

	Select @NCount = Count(*) from @emp_tbl;

	print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@Section=ISNULL(Section,'N\A'),@MachineNo=MachineNo,
		@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

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
			Set @OTHours = dbo.fnMeasureOTHrs(@EmployeeID,@InterimDate)

			if @OTHours < 0
				Set @OTHours = 0
			
			Set @LateHours = dbo.fnMeasureLateHrs(@EmployeeID,@InterimDate)

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
						end
						else
						begin
							Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(10-1)+1)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':560' )
						end
					
					end
				end

				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLeave,TotalHoliday,TotalAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@OutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLeave,@TotalHoliday,@TotalAbsent)
			--end
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1
	end

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,AttStatus='Weekend'
	Where AttDay='Friday'

	Select * from @att_tbl
	
end

Declare @ComplianceOutTime as datetime
Set @ComplianceOutTime = 'Jul  3 2018  5:00PM'
Declare @A as datetime
Set @A = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50))+ ':' + Convert(nvarchar, FLOOR(RAND(CHECKSUM(NEWID()))*(59-1)+1)) + ':570' )
Select @A

-- exec spReportEmpJobCardCompliance 'ALL','SEC-00000015','2018','07'

GO

/*
alter proc spReportMonthlyAttSummary
@DesignationID nvarchar(50),
@year varchar(4),
@month varchar(2)
as
begin

	Declare @ReportMonth as nvarchar(10) Set @ReportMonth = ''
	Declare @DesignationIDParam as nvarchar(50) set @DesignationIDParam = ''
	Declare @ParameterDate as date

	if @DesignationID = 'ALL'
		Set @DesignationIDParam = '%'
	else
		Set @DesignationIDParam = '%' + @DesignationID + '%'

	if @month = 0
		Set @ParameterDate = convert(nvarchar,DATEPART(MONTH,GETDATE()))+'/01/'+Convert(nvarchar,@year);
	else
		Set @ParameterDate = convert(nvarchar,@month)+'/01/'+Convert(nvarchar,@year);
	 
	Set @ReportMonth =  DATENAME(MONTH,@ParameterDate);

	Declare @WD as int Set @WD = 0
	Set @WD = dbo.fnCountWorkingDay(@year,@month)

	Select distinct E.EmpCode,E.EmployeeName as 'Employee',E.OfficialDesignation as 'Designation',ISNULL(E.DeptName,'N\A') as 'Department',
	dbo.fnCountLateIn(E.EmployeeID,@year,@month) as 'LI',
	dbo.fnCountEarlyOut(E.EmployeeID,@year,@month) as 'EO',
	dbo.fnCountOnLeave(E.EmployeeID,@year,@month) as 'LE',
	@WD as 'WD',
	dbo.fnCountWKH(E.EmployeeID,@year,@month) as 'WKH',
	@ReportMonth as 'ReportMonth'
	from vwEmpInfo E Where E.isActive = 1
	and E.OfficialDesignationID like @DesignationIDParam
	order by E.EmpCode
end

-- exec spReportMonthlyAttSummary 'ALL',2018,2

select * from tblSection
*/


-- Finding Second & Milisecond Part
Select Convert(nvarchar,getdate(),113)
Select SUBSTRING(Convert(nvarchar,getdate(),113),18,7)
Select DATEPART(SECOND,getdate())
Select DATEPART(MILLISECOND,getdate())


--Selecting Random Number From 50 to 59
select FLOOR(RAND(CHECKSUM(NEWID()))*(59-50)+50)

Select DATEADD(HOUR,-1,GETDATE())