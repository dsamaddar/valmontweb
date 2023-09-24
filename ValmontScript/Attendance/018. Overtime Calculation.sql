/*
01-May-2021 to 11-May-2021 {Start Time 6:00PM - 8:00PM}
and
11-May-2021 to 30-May-2021 {Start Time 7:00PM - 9:00PM}
*/

-- select * from tblEmployeeInfo where EmpCode like '%10821%'
-- select * from tblEmployeeInfo where SectionID = 'SEC-00000011' and isactive=1;
-- select * from tblSection where Section like '%jac%'
-- exec spReportEmpJobCardOT 'EMP-00000710','ALL','ALL',2022,8

GO

alter proc spReportEmpJobCardOT
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
	OTOutTime datetime,
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
	Declare @OTOutTime as datetime
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @OTStartTime as datetime
	Declare @WeekendOTEndTime as datetime
	Declare @ComplianceInTime as datetime
	Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''
	Declare @extra_min as int Set @extra_min = 0;

	Select @NCount = Count(*) from @emp_tbl;

	--print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@Block=ISNULL(Block,'N\A'),
		@MachineNo=MachineNo,@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @InterimDate = @StartDate

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
			set @OTStartTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '08:00:00 PM');
			set @WeekendOTEndTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '05:00:00 PM');
			print 'Weekday : ' + @AttDay;
			If @AttDay = 'Wednesday'
				print 'Wednesday: ' + convert(nvarchar,@InterimDate,106)
			
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			--Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @SecIdealLogoutTime)
			if(@InterimDate >= '4/14/2021' and @InterimDate <= '5/12/2021')
			begin
				
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '06:00:00 PM')
			end
			else
			begin
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '07:00:00 PM')
			end

			Print 'Compliance Out Time : ' + Convert(nvarchar,@ComplianceOutTime)
			Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)
			Print 'Compliance In Time : ' + Convert(nvarchar,@ComplianceInTime)
			--Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@InterimDate)

			if @AttDay = 'Wednesday' and not exists(select * from tblExceptions where convert(nvarchar,ExceptionDate,106) = convert(nvarchar,@InterimDate,106))
			begin
				Set @ComplianceOutTime = @ComplianceInTime
			end

			if @OTHours < 0
				Set @OTHours = 0
			
			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A';

			
			Set @OTOutTime = @OutTime;

			print 'Actual In Time : ' + convert(nvarchar,@InTime);
			print 'Actual Out time : ' + convert(nvarchar,@OutTime);

			Declare @OTStandardOutTime datetime
			Declare @OTStandardInTime datetime

			If @InterimDate >= '4/15/2021' and @InterimDate <= '5/14/2021'
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 06:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 08:00:00 PM');
			end
			else
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 07:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 11:50:00 PM');
			end
			
			print 'OT Standard IN TIME : ' + convert(nvarchar,@OTStandardInTime)
			print 'OT Standard OUT TIME : ' + convert(nvarchar,@OTStandardOutTime)
			
			If @AttStatus <> 'Absent'
			begin
				Print 'A'

				If @AttDay = 'Wednesday' and @InterimDate >= '08/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime);
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				If @AttDay = 'Friday' and @InterimDate < '08/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				If @AttDay <> 'Wednesday' and @InterimDate >= '08/17/2022'
				begin

					if  @OTOutTime > @OTStandardInTime and @OTOutTime > @OTStartTime
					begin
						Print 'X'
						SET @InTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTStandardInTime);
						SET @OTHours = DATEDIFF(MINUTE,@OTStartTime,@OTOutTime)
						SET @OTOutTime = DATEADD(MINUTE,@OTHours,@InTime);

						print 'x->'+ convert(nvarchar,@InTime);

							

						print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
						print 'OTHRS : ' + convert(nvarchar,@OTHours);
					end
					else
					begin
						Print 'D'
						Set @OTHours = 0
					end

				end

				If @AttDay <> 'Friday' and @InterimDate < '08/17/2022'
				begin

					if  @OTOutTime > @OTStandardInTime and @OTOutTime > @OTStartTime
					begin
						Print 'X'
						SET @InTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTStandardInTime);
						SET @OTHours = DATEDIFF(MINUTE,@OTStartTime,@OTOutTime)
						SET @OTOutTime = DATEADD(MINUTE,@OTHours,@InTime);

						print 'x->'+ convert(nvarchar,@InTime);

							

						print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
						print 'OTHRS : ' + convert(nvarchar,@OTHours);
					end
					else
					begin
						Print 'D'
						Set @OTHours = 0
					end

				end
				
				-- padding few random minutes
				


				if @OTHours < 0
					Set @OTHours = 0;
				
				
				-- Resetting for ramadan 
				If @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032' or @SectionIDCom = 'SEC-00000043' or @SectionIDCom = 'SEC-00000044' or @SectionIDCom = 'SEC-00000051' or @SectionIDCom = 'SEC-00000052' or @SectionIDCom = 'SEC-00000053' or @SectionIDCom = 'SEC-00000054' or @SectionIDCom = 'SEC-00000055' or @SectionIDCom = 'SEC-00000056' or @SectionIDCom = 'SEC-00000059'
				begin
					Set @OTHours = 0;
				end
				
			end

			print 'x->'+ convert(nvarchar,@InTime);
			
			Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
			Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			print '***********************************************'

			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1;
		set @InTime = null;
		set @OTOutTime = null;
	end
	
	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where AttStatus='NoWorkDay'

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where OTHr=0 and OTMin = 0;

	delete from @att_tbl where InTime is NULL and OutTime is NULL;
	delete from @att_tbl where OverTimeHours < 20;

	Update @att_tbl Set AttStatus = c.Remarks
	from @att_tbl a inner join tblCompensatoryLeave c on a.AttDate = c.CompensatoryDate
	where a.AttDate in (select CompensatoryDate from tblCompensatoryLeave)
	

	Select * from @att_tbl;
	
end

GO

-- exec spReportWeekendJobCardOT 'EMP-00001754','ALL','ALL',2022,12
alter proc spReportWeekendJobCardOT
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
	And E.SectionID in (select SectionID from tblSection where Section in ('LINKING','TRIMMING'))
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
	OTOutTime datetime,
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
	Declare @OTOutTime as datetime
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @OTStartTime as datetime
	Declare @WeekendOTEndTime as datetime
	Declare @ComplianceInTime as datetime
	Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''
	Declare @extra_min as int Set @extra_min = 0;

	Select @NCount = Count(*) from @emp_tbl;

	--print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@Block=ISNULL(Block,'N\A'),
		@MachineNo=MachineNo,@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @InterimDate = @StartDate

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
			
			set @OTStartTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '08:00:00 PM');
			set @WeekendOTEndTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '05:00:00 PM');
			print 'Weekday : ' + @AttDay;
			If @AttDay = 'Wednesday'
				print 'Wednesday: ' + convert(nvarchar,@InterimDate,106)
			
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			--Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @SecIdealLogoutTime)
			if(@InterimDate >= '4/14/2021' and @InterimDate <= '5/12/2021')
			begin
				
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '06:00:00 PM')
			end
			else
			begin
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '07:00:00 PM')
			end

			Print 'Compliance Out Time : ' + Convert(nvarchar,@ComplianceOutTime)
			Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)
			Print 'Compliance In Time : ' + Convert(nvarchar,@ComplianceInTime)
			--Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@InterimDate)

			if @AttDay = 'Wednesday' and not exists(select * from tblExceptions where convert(nvarchar,ExceptionDate,106) = convert(nvarchar,@InterimDate,106))
			begin
				Set @ComplianceOutTime = @ComplianceInTime
			end

			if @OTHours < 0
				Set @OTHours = 0
			
			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A';

			
			Set @OTOutTime = @OutTime;

			print 'Actual In Time : ' + convert(nvarchar,@InTime);
			print 'Actual Out time : ' + convert(nvarchar,@OutTime);

			Declare @OTStandardOutTime datetime
			Declare @OTStandardInTime datetime

			If @InterimDate >= '4/15/2021' and @InterimDate <= '5/14/2021'
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 06:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 08:00:00 PM');
			end
			else
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 07:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 11:50:00 PM');
			end
			
			print 'OT Standard IN TIME : ' + convert(nvarchar,@OTStandardInTime)
			print 'OT Standard OUT TIME : ' + convert(nvarchar,@OTStandardOutTime)
			
			If @AttStatus <> 'Absent'
			begin
				Print 'A'

				If @AttDay = 'Wednesday' and @InterimDate >= '08/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)-60;
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				If @AttDay = 'Friday' and @InterimDate < '08/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)-60;
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				if @OTHours < 0
					Set @OTHours = 0;				
			end
			
			If @AttDay = 'Wednesday' and @InterimDate >= '08/17/2022'
			begin
				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			end

			If @AttDay = 'Friday' and @InterimDate < '08/17/2022'
			begin
				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			end
			print '***********************************************'

			NOTWEEKEND:
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1;
		set @InTime = null;
		set @OTOutTime = null;
	end
	
	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where AttStatus='NoWorkDay'

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where OTHr=0 and OTMin = 0;

	delete from @att_tbl where InTime is NULL and OutTime is NULL;
	--delete from @att_tbl where OverTimeHours < 20;

	Update @att_tbl Set AttStatus = c.Remarks
	from @att_tbl a inner join tblCompensatoryLeave c on a.AttDate = c.CompensatoryDate
	where a.AttDate in (select CompensatoryDate from tblCompensatoryLeave)
	

	Select * from @att_tbl;
	
end



GO

-- exec spReportWeekendJobCardJacOT 'EMP-00001837','ALL','ALL',2022,9
alter proc spReportWeekendJobCardJacOT
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
	And E.SectionID in (select SectionID from tblSection where Section in ('JACQUARD-Morning','JACQUARD-EVENING'))
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
	OTOutTime datetime,
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
	Declare @OTOutTime as datetime
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @OTStartTime as datetime
	Declare @WeekendOTEndTime as datetime
	Declare @ComplianceInTime as datetime
	Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''
	Declare @extra_min as int Set @extra_min = 0;

	Select @NCount = Count(*) from @emp_tbl;

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@Block=ISNULL(Block,'N\A'),
		@MachineNo=MachineNo,@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @InterimDate = @StartDate

		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			If @AttDay = 'Wednesday'
				print @AttDay;
			
			set @OTStartTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '07:30:00 PM');
			set @WeekendOTEndTime = Convert(datetime,Convert(nvarchar,DATEADD(DAY,1,@InterimDate)) + ' ' + '08:00:00 AM');
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			Select @InTime=MIN(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A'
			And LogTime > @OTStartTime;

			Select @OutTime=MIN(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID
			And AuthStatus='A' And LogTime > @InTime

			
			Set @OTOutTime = @OutTime;

			print 'Actual In Time : ' + convert(nvarchar,@InTime);
			print 'Actual Out time : ' + convert(nvarchar,@OutTime);

			Declare @OTStandardOutTime datetime
			Declare @OTStandardInTime datetime
			
			If @AttStatus <> 'Absent'
			begin
				Print 'A'

				If @AttDay = 'Wednesday' and @InterimDate >= '8/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)-60
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				If @AttDay = 'Friday' and @InterimDate < '8/17/2022'
				begin
					Print 'B'

					if @OTOutTime > @WeekendOTEndTime
						set @OTOutTime = @WeekendOTEndTime;
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)-60
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				if @OTHours < 0
					Set @OTHours = 0;
				
				
			end

			if @AttDay = 'Wednesday' and @InterimDate >= '8/17/2022'
			begin
				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
				
			end
			if @AttDay = 'Friday' and @InterimDate < '8/17/2022'
			begin
				Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
				Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
				
			end
			print '***********************************************'

			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1;
		set @InTime = null;
		set @OTOutTime = null;
	end
	
	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where AttStatus='NoWorkDay'

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where OTHr=0 and OTMin = 0;

	delete from @att_tbl where InTime is NULL and OutTime is NULL;
	delete from @att_tbl where OverTimeHours < 20;

	Update @att_tbl Set AttStatus = c.Remarks
	from @att_tbl a inner join tblCompensatoryLeave c on a.AttDate = c.CompensatoryDate
	where a.AttDate in (select CompensatoryDate from tblCompensatoryLeave)
	

	Select * from @att_tbl;
	
end



GO

-- exec spReportEmpJobCardOT_old 'EMP-00000727','SEC-00000011','ALL',2022,11

alter proc spReportEmpJobCardOT_old
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
	OTOutTime datetime,
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
	Declare @OTOutTime as datetime
	Declare @OTHours as int Set @OTHours = 0
	Declare @LateHours as int Set @LateHours = 0
	Declare @HalfAbsent as numeric(5,2) Set @HalfAbsent = 0

	Declare @TotalLateIn as int Set @TotalLateIn = 0
	Declare @TotalLeave as int Set @TotalLeave = 0
	Declare @TotalAbsent as int Set @TotalAbsent = 0
	Declare @TotalHoliday as int Set @TotalHoliday = dbo.fnCountHolidays(@year,@month)

	Declare @ComplianceInTime as datetime
	Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
	Declare @ComplianceOutTime as datetime
	Declare @SecIdealLogoutTime as nvarchar(50) Set @SecIdealLogoutTime = ''
	Declare @extra_min as int Set @extra_min = 0;

	Select @NCount = Count(*) from @emp_tbl;

	--print Convert(nvarchar,@NCount)

	While @Count <= @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@Designation=Designation,@SectionIDCom=SectionID,@Section=ISNULL(Section,'N\A'),@Block=ISNULL(Block,'N\A'),
		@MachineNo=MachineNo,@CardNo=CardNo,@JoiningDate=JoiningDate
		from @emp_tbl Where Taken = 0

		Set @InterimDate = @StartDate

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
			print 'Weekday : ' + @AttDay;
			If @AttDay = 'Wednesday'
					print 'Wednesday: ' + convert(nvarchar,@InterimDate,106)
			
			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)

			--Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @SecIdealLogoutTime)
			if(@InterimDate >= '4/14/2021' and @InterimDate <= '5/12/2021')
			begin
				
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '06:00:00 PM')
			end
			else
			begin
				Set @ComplianceOutTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + '07:00:00 PM')
			end

			Print 'Compliance Out Time : ' + Convert(nvarchar,@ComplianceOutTime)
			Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)
			Print 'Compliance In Time : ' + Convert(nvarchar,@ComplianceInTime)
			--Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@InterimDate)

			if @AttDay = 'Wednesday' and not exists(select * from tblExceptions where convert(nvarchar,ExceptionDate,106) = convert(nvarchar,@InterimDate,106))
			begin
				Set @ComplianceOutTime = @ComplianceInTime
			end

			if @OTHours < 0
				Set @OTHours = 0
			
			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A';

			
			Set @OTOutTime = @OutTime;

			print 'Actual In Time : ' + convert(nvarchar,@InTime);
			print 'Actual Out time : ' + convert(nvarchar,@OutTime);

			Declare @OTStandardOutTime datetime
			Declare @OTStandardInTime datetime

			If @InterimDate >= '4/15/2021' and @InterimDate <= '5/14/2021'
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 06:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 08:00:00 PM');
			end
			else
			begin
				Set @OTStandardInTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 07:00:00 PM');
				Set @OTStandardOutTime = convert(datetime,convert(nvarchar,@OTOutTime,101)+' 10:00:00 PM');
			end
			
			print 'OT Standard IN TIME : ' + convert(nvarchar,@OTStandardInTime)
			print 'OT Standard OUT TIME : ' + convert(nvarchar,@OTStandardOutTime)
			
			If @AttStatus <> 'Absent'
			begin
				Print 'A'

				If @AttDay = 'Wednesday'
				begin
					Print 'B'
							
					SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)
					print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
					print 'OTHRS : ' + convert(nvarchar,@OTHours);
				end

				If @AttDay <> 'Wednesday'
				begin

					if  @OTOutTime > @OTStandardInTime
					begin
						If @OTOutTime > @OTStandardOutTime
						begin
							Print 'C'
							SET @InTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTStandardInTime);
							SET @OTOutTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTStandardOutTime);

							SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)

							print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
							print 'OTHRS : ' + convert(nvarchar,@OTHours);
						end
						else
						begin
							Print 'X'
							SET @InTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTStandardInTime);
							SET @OTOutTime = DATEADD(MINUTE,FLOOR(RAND(CHECKSUM(NEWID()))*(5-1)+1),@OTOutTime);

							print 'x->'+ convert(nvarchar,@InTime);

							SET @OTHours = DATEDIFF(MINUTE,@InTime,@OTOutTime)

							print 'In Time: ' + convert(nvarchar,@InTime) + ' Out Time : ' + convert(nvarchar,@OTOutTime)
							print 'OTHRS : ' + convert(nvarchar,@OTHours);
						end
					end
					else
					begin
						Print 'D'
						Set @OTHours = 0
					end

				end
				
				-- padding few random minutes
				


				if @OTHours < 0
					Set @OTHours = 0;
				
				
				-- Resetting for ramadan 
				If @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032' or @SectionIDCom = 'SEC-00000043' or @SectionIDCom = 'SEC-00000044' or @SectionIDCom = 'SEC-00000051' or @SectionIDCom = 'SEC-00000052' or @SectionIDCom = 'SEC-00000053' or @SectionIDCom = 'SEC-00000054' or @SectionIDCom = 'SEC-00000055' or @SectionIDCom = 'SEC-00000056' or @SectionIDCom = 'SEC-00000059'
				begin
					Set @OTHours = 0;
				end
				
			end

			print 'x->'+ convert(nvarchar,@InTime);
			
			Insert Into @att_tbl(EmployeeID,EmployeeName,Designation,Section,Block,MachineNo,CardNo,JoiningDate,AttDate,AttDay,AttStatus,InTime,OutTime,OTOutTime,OverTimeHours,OTHr,OTMin,LateHours,LTHr,LTMin,TotalLateIn,TotalLeave,TotalHoliday,TotalAbsent,HalfAbsent)
			Values(@EmployeeID,@EmployeeName,@Designation,@Section,@Block,@MachineNo,@CardNo,@JoiningDate,@InterimDate,@AttDay,@AttStatus,@InTime,@InTime,@OTOutTime,@OTHours,@OTHours/60,@OTHours%60,@LateHours,@LateHours/60,@LateHours%60,@TotalLateIn,@TotalLeave,@TotalHoliday,@TotalAbsent,@HalfAbsent)
			print '***********************************************'

			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @HalfAbsent = 0
		end

		Update @emp_tbl Set Taken = 1 Where EmployeeID = @EmployeeID
		Set @Count = @Count + 1;
		set @InTime = null;
		set @OTOutTime = null;
	end
	
	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where AttStatus='NoWorkDay'

	Update @att_tbl Set InTime=NULL,OutTime=NULL,OTOutTime=NULL,OverTimeHours=NULL,OTHr=NULL,OTMin=NULL,LateHours=NULL,LTHr=NULL,
	LTMin=NULL,HalfAbsent=0
	Where OTHr=0 and OTMin = 0;

	delete from @att_tbl where InTime is NULL and OutTime is NULL;

	Update @att_tbl Set AttStatus = c.Remarks
	from @att_tbl a inner join tblCompensatoryLeave c on a.AttDate = c.CompensatoryDate
	where a.AttDate in (select CompensatoryDate from tblCompensatoryLeave)
	

	Select * from @att_tbl;
	
end

GO

