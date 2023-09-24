


exec spGetErrorReportShiftingDuty 'ALL','ALL',2019,2

create proc spGetErrorReportShiftingDuty
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


	 select * from @Att where OTHr >= 4 order by EmployeeID,convert(date,AttDate);
end

GO

exec spGetErrorReportShiftingDutyDaily '02/25/2019'

create proc spGetErrorReportShiftingDutyDaily
@ReportDate date
as
begin

	Select T.* from (
	Select E.EmployeeID,E.EmployeeName,E.EmpCode,S.Section,SH.ShiftName,ISNULL(MAX(A.LogTime),DATEADD(HOUR,-2,convert(nvarchar,@ReportDate,101)+ ' '+SH.ShiftLogStarts)) LogTime,
	convert(nvarchar,@ReportDate,101)+ ' '+SH.ShiftLogStarts as IdealLogTime,
	DATEDIFF(HOUR,
		ISNULL(MAX(A.LogTime),DATEADD(HOUR,-2,convert(nvarchar,@ReportDate,101)+ ' '+SH.ShiftLogStarts)),
		convert(nvarchar,@ReportDate,101)+ ' '+SH.ShiftLogStarts
		) LagTime
	from tblEmployeeInfo E 
	LEFT OUTER JOIN tblSection S ON E.SectionID = S.SectionID 
	LEFT OUTER JOIN tblShifts SH ON S.ShiftID = SH.ShiftID
	LEFT OUTER JOIN tblUserAttendance A ON E.EmployeeID = A.EmployeeID
	Where S.ShiftID IS NOT NULL
	And Convert(nvarchar,ISNULL(A.LogTime,@ReportDate),106) = convert(nvarchar,@ReportDate,106)
	And E.IsActive=1
	group by E.EmployeeID,E.EmployeeName,E.EmpCode,S.Section,SH.ShiftName,SH.ShiftLogStarts,SH.ShiftLogEnds
	) T
	Where T.LagTime > 2

end