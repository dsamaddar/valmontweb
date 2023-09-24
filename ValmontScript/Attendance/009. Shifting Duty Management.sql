DECLARE @Employee TABLE (UserID int, LogDate datetime, C1 varchar(10));

INSERT INTO @Employee (UserID, LogDate, C1) VALUES
--(1019, '2016-03-01 05:17:03.000', 'Out'),
(1019, '2016-03-01 18:41:14.000', 'In'),
--(1019, '2016-03-01 22:06:24.000', 'Out'),
--(1019, '2016-03-01 22:34:03.000', 'In'),
--(1019, '2016-03-02 01:32:33.000', 'Out'),
--(1019, '2016-03-02 01:38:03.000', 'In'),
(1019, '2016-03-02 05:32:33.000', 'Out');

DECLARE @Shifts TABLE (UserID int, ShiftName varchar(50), ShiftStartMinutesFromMidnight int);
INSERT INTO @Shifts (UserID, ShiftName, ShiftStartMinutesFromMidnight) VALUES
(1019, 'Night Shift-1', 18*60 + 30 - 2*60); -- 18:30 minus 2 hours

--select * from @Employee;
--select * from @Shifts;

SELECT
    EIn.UserID
    ,CAST(DATEADD(minute, -ShiftStartMinutesFromMidnight, EIn.LogDate) AS date) AS dt
    ,EIn.LogDate AS LogIn
    ,CA_Out.LogDate AS LogOut
    ,DATEDIFF(minute, EIn.LogDate, CA_Out.LogDate) AS WorkingMinutes
FROM
    @Employee AS EIn
    CROSS APPLY
    (
        SELECT TOP(1) EOut.LogDate
        FROM @Employee AS EOut
        WHERE
            EOut.UserID = EIn.UserID
            AND EOut.C1 = 'Out'
            AND EOut.LogDate >= EIn.LogDate
        ORDER BY EOut.LogDate
    ) AS CA_Out
    INNER JOIN @Shifts AS S ON S.UserID = EIn.UserID
WHERE
    EIn.C1 = 'In'
ORDER BY
    UserID
    ,LogIn
;



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
	SectionID nvarchar(50),
	Section nvarchar(50),
	MachineNo nvarchar(20),
	CardNo nvarchar(20),
	JoiningDate date,
	Taken bit default 0
	);

	Insert Into @emp_tbl(EmployeeID,EmployeeName,Designation,SectionID,Section,MachineNo,CardNo,JoiningDate)
	Select E.EmployeeID,E.EmployeeName,D.Designation,S.SectionID,S.Section,ISNULL(MachineNo,'-'),E.CardNo,E.JoiningDate
	from tblEmployeeInfo E Inner Join tblSection S ON E.SectionID = S.SectionID
	Inner Join tblDesignation D ON E.DesignationID = D.DesignationID
	Where E.EmployeeID like @EmployeeIDParam 
	And E.SectionID like @SectionIDParam
	And E.isActive=1

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
					If @SectionIDCom = 'SEC-00000001' or @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032'
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