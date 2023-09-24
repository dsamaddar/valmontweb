CREATE FUNCTION GetWeekendDaysCount
(
    @Date datetime
)
RETURNS int
AS
BEGIN
    DECLARE @WeekendDays int
 
    ;WITH CTE AS
    (
        SELECT 
            @Date AS [Date], 
            MONTH(@Date) As [Month],
            DATENAME (MONTH,@Date) AS [MonthName],
            DATENAME (DW,@Date) AS [DayName]
        UNION ALL
        SELECT 
            DATEADD(DAY,1,[DATE]) AS [Date],
            MONTH(DATEADD(DAY,1,[DATE])) AS [Month],
            DATENAME (MONTH,DATEADD(DAY,1,[DATE])) AS [MonthName],
            DATENAME (DW ,DATEADD(DAY,1,[DATE])) AS [DayName] 
        FROM 
            CTE 
        WHERE 
            YEAR(DATEADD(DAY,1,[DATE]) )=YEAR(@Date)
            AND MONTH(DATEADD(DAY,1,[DATE]))=MONTH(@Date)
    )
    SELECT 
        @WeekendDays = COUNT(*)
    FROM 
        CTE 
    WHERE 
        [DayName] IN ('Friday') 
    OPTION 
        (MAXRECURSION 367)
 
    RETURN @WeekendDays
END

--select dbo.GetWeekendDaysCount('01-Jan-2020');

GO

alter function fnCountFridayAttendance(@EmployeeID nvarchar(50),@Year int, @Month int)
returns int
as
begin
	Declare @CountFriday as int Set @CountFriday = 0;

	select @CountFriday = Count(distinct LogTime) from (
	select convert(nvarchar,LogTime,106) LogTime from tblUserAttendance 
	Where EmployeeID = @EmployeeID 
	and DATEPART(YEAR,LogTime) = @Year
	and DATEPART(MONTH,LogTime) = @Month
	and DATENAME(DW,LogTime) = 'Friday'
	) as V;

	return @CountFriday;
end

GO

alter function fnCountFridayAttendancedtRange(@EmployeeID nvarchar(50),@StartDate date, @EndDate date)
returns int
as
begin
	Declare @CountFriday as int Set @CountFriday = 0;
	Declare @StDt as datetime
	Declare @EndDt as datetime
	Set @StDt =convert(nvarchar,@StartDate,101) + ' 00:00:01 AM';
	Set @EndDt =convert(nvarchar,@EndDate,101) + ' 23:59:59 PM';

	select @CountFriday = Count(distinct LogTime) from (
	select convert(nvarchar,LogTime,106) LogTime from tblUserAttendance 
	Where EmployeeID = @EmployeeID 
	and LogTime between @StDt and @EndDt
	and DATENAME(DW,LogTime) = 'Friday'
	) as V;

	return @CountFriday;
end


GO

alter function fnGetFridayAllowanceRate(@SectionID nvarchar(50),@Gross numeric(18,2),@ttl_dom int)
returns numeric(18,2)
as
begin
	Declare @friday_allowance_rate as numeric(18,2) Set @friday_allowance_rate =0;
	Declare @FAEligible as bit Set @FAEligible=1;

	select @friday_allowance_rate = ISNULL(FridayAllowance,0),@FAEligible=FAEligible
	from tblSection Where SectionID=@SectionID;

	If @friday_allowance_rate = 0 and @FAEligible=1
		Set @friday_allowance_rate = (@Gross/@ttl_dom)*0.6;

	return @friday_allowance_rate
end

--select dbo.fnGetFridayAllowanceRate('SEC-00000032',53104,31)

GO

create function fnGetAttendanceBonus(@SectionID nvarchar(50),@ttl_dom int,@present_days int)
returns numeric(18,2)
as
begin
	
	Declare @attendance_bonus as numeric(18,2) Set @attendance_bonus =0;

	if exists (select * from tblSection s where s.SectionID = @SectionID and s.Section like '%staff%')
	begin
		Set @attendance_bonus = 0;
	end
	else
	begin
		if @ttl_dom = @present_days
			Set @attendance_bonus = 200;
		else
			Set @attendance_bonus = 0;
	end
	return @attendance_bonus
end;

GO

alter function fnGetAttendanceBonusdtRange(@SectionID nvarchar(50),@ttl_dom int,@StartDate date,@EndDate date,@present_days int)
returns numeric(18,2)
as
begin
	
	Declare @attendance_bonus as numeric(18,2) Set @attendance_bonus =0;
	Declare @dtRange as int Set @dtRange = 0;
	Set @dtRange = datediff(day,@StartDate,@EndDate)+1;

	if exists (select * from tblSection s where s.SectionID = @SectionID and s.Section like '%staff%')
	begin
		Set @attendance_bonus = 0;
	end
	else
	begin
		if @ttl_dom = @present_days
			Set @attendance_bonus = 200;

		if @dtRange = @present_days
			Set @attendance_bonus = 200;
	end
	return @attendance_bonus
end;

GO


select dbo.fnCountInterimAbsentdtRange('EMP-00003747','4/1/2021','4/30/2021')

alter function fnCountInterimAbsentdtRange(@EmployeeID nvarchar(50),@StartDate date, @EndDate date)
returns int
as
begin
	Declare @InterimAbsent as int Set @InterimAbsent = 0;
	Declare @AttStatus as nvarchar(50) Set @AttStatus = '';
	Declare @dtName as nvarchar(50) Set @dtName = '';
	Declare @ThursdayDate as date
	Declare @StaurdayDate as date

	While @StartDate <= @EndDate
	begin
		Select @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@StartDate);

		if @AttStatus = 'Absent'
		begin
			if DATENAME(weekday,@StartDate) = 'Thursday'
				Set @ThursdayDate = @StartDate;
			if DATENAME(weekday,@StartDate) = 'Saturday'
				Set @StaurdayDate = @StartDate;

			if @StaurdayDate = DATEADD(DAY,2,@ThursdayDate)
			begin
				Set @InterimAbsent += 1;
				Set @ThursdayDate = NULL
				Set @StaurdayDate = NULL
			end
		end

		Set @StartDate = DATEADD(DAY,1,@StartDate)
	end
	return @InterimAbsent;
end

go

-- select * from tblEmployeeInfo where CardNo='10085';
-- select dbo.fnGetOTHrsSalaryPart('EMP-00001437','4/1/2021','4/30/2021')

alter function fnGetOTHrsSalaryPart(@EmployeeID nvarchar(50),@StartDate date, @EndDate date)
returns numeric(5,2)
as
begin

		Declare @InterimDate as date Set @InterimDate = @StartDate;
		Declare @Count as int Set @Count = 1
		Declare @NCount as int Set @NCount = 0
		Declare @AttDay as varchar(10) Set @AttDay = ''
		Declare @AttStatus as varchar(20) Set @AttStatus = ''
		Declare @OTHours as int Set @OTHours = 0
		Declare @ComplianceInTime as datetime
		Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
		Declare @ComplianceOutTime as datetime
		Declare @SectionIDCom as nvarchar(50) Set @SectionIDCom = ''
		Declare @total_ot_hrs as numeric(5,2) Set @total_ot_hrs = 0;

		Declare @InTime as datetime
		Declare @OutTime as datetime
		
		select @ComplianceInTimeText = PropertyValue  from tblAppSettings Where PropertyName='IdealLoginTime';

		Select @SectionIDCom=SectionID from tblEmployeeInfo where EmployeeID = @EmployeeID


		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			If @AttDay <> 'Friday'
			begin

			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)
			select @ComplianceOutTime = DATEADD(HOUR,2,u.IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106)
			
			
			Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)
			
			
			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A'
			
			If @AttStatus <> 'Absent'
			begin
				Declare @IdealLogoutTime as datetime
				select @IdealLogoutTime = max(IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106)
			
				If @OutTime > @ComplianceOutTime
				begin
					
					Set @OutTime = DATEADD(HOUR,-2,@OutTime)
					
					if @OutTime > @ComplianceOutTime
					begin
						Set @ComplianceOutTime = DATEADD(HOUR,-1,@ComplianceOutTime)
						Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':55:59:570' )
						
					end
					
					Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
					
				end
				else
				begin
					
					If @OutTime > @IdealLogoutTime
					begin
						Set @OutTime = Convert(datetime, Convert(nvarchar,@IdealLogoutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@IdealLogoutTime)) + ':00:59:560' )
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

			end
			Set @total_ot_hrs += isnull(@OTHours,0);
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @OTHours = 0;
			
		end

		return @total_ot_hrs/60;
end

select * from tblGeneratedSalary;