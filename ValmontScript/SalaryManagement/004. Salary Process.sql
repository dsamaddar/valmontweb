
insert into tblAppSettings(PropertyName,PropertyValue)values('CurrentGeneratedSalaryID',0);

GO

-- select * from tblGeneratedSalary order by ProcessDate desc;
-- select * from tblGeneratedFestivalBonus where FestivalTypeID=2;
-- select * from tblEmployeeInfo where IsActive=1;
-- drop table tblGeneratedSalary
-- delete from tblGeneratedSalary;
Create table tblGeneratedSalary(
GeneratedSalaryID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
SalaryYear int,
SalaryMonth int,
StartDate date,
EndDate date,
DesignationID nvarchar(50) foreign key references tblDesignation(DesignationID),
Grade int,
CardNo nvarchar(50),
SectionID nvarchar(50) foreign key references tblSection(SectionID),
BlockID nvarchar(50) foreign key references tblBlocks(BlockID),
JoiningDate date,
basic_salary numeric(18,2) default 0,
house_rent numeric(18,2) default 0,
medical_allowance numeric(18,2) default 0,
conveyance numeric(10,2),
food_allowance numeric(10,2),
gross_salary numeric(18,2) default 0,
ttl_dom int default 0,
present_days int default 0,
absent_days int default 0,
leave_days int default 0,
absent_deduction numeric(18,2) default 0,
friday_allowance_rate numeric(18,2) default 0,
ttl_friday int default 0,
friday_allowance numeric(18,2) default 0,
attendance_bonus numeric(18,2) default 0,
ot_rate numeric(5,2),
ot_hr numeric(5,2),
ot_amt numeric(10,2),
advance numeric(10,2),
revenue_deduction numeric(10,2),
ttl_payable_amt numeric(18,2) default 0,
stamp_deduction numeric(18,2) default 10,
net_payable numeric(18,2) default 0,
bank_account nvarchar(50),
EntryPoint nvarchar(50),
ProcessedBy nvarchar(50) default 'admin',
ProcessDate datetime default getdate()
);

GO

alter proc spGetEntryPoints
@SalaryYear int,
@SalaryMonth int
as
begin
	Select Distinct EntryPoint as id,
	EntryPoint+' ['+convert(nvarchar,StartDate,106)+'-'+ convert(nvarchar,EndDate,106) +']'  as value
	from tblGeneratedSalary where SalaryMonth=@SalaryMonth and SalaryYear=@SalaryYear
end

-- exec spGetEntryPoints 2020,7

GO
 
-- exec spGetSalaryReport 2020,7,'ALL','ALL'
alter proc spGetSalaryReport
@SalaryYear int,
@SalaryMonth int,
@SectionID nvarchar(50),
@BlockID nvarchar(50),
@EntryPoint nvarchar(50)
as
begin
	Declare @SectionIDParam as nvarchar(50) Set @SectionIDParam = '';
	Declare @BlockIDParam as nvarchar(50) Set @BlockIDParam = '';
	Declare @advance as numeric(10,2) Set @advance = 0;
	Declare @renenue_deduction as numeric(10,2) Set @renenue_deduction = 0;

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	if @BlockID = 'ALL'
		Set @BlockIDParam = '%'
	else
		Set @BlockIDParam = '%' + @BlockID + '%'

	Select E.EmployeeName,G.CardNo+ '/' + ISNULL(E.MachineNo,'-') as 'CardNo',convert(nvarchar,G.JoiningDate,101) as 'JoiningDate',
	D.Designation,G.Grade,S.Section,ISNULL(B.Block,'-') as 'Block',
	convert(nvarchar(15),StartDate,106) as StartDate,convert(nvarchar(15),EndDate,106) as EndDate,basic_salary,
	house_rent,medical_allowance,isnull(G.conveyance,0) as 'conveyance',isnull(G.food_allowance,0) as 'food_allowance',gross_salary,ttl_dom,
	present_days,absent_days,leave_days,absent_deduction,
	friday_allowance_rate,ttl_friday,friday_allowance,attendance_bonus,isnull(G.ot_rate,0) as 'ot_rate',isnull(G.ot_hr,0) as 'ot_hr',
	isnull(G.ot_amt,0) as 'ot_amt',ttl_payable_amt,stamp_deduction,net_payable,isnull(bank_account,'') as 'bank_account',
	@advance as 'advance',@renenue_deduction as 'rd'
	from tblGeneratedSalary G 
	left outer join tblEmployeeInfo E On G.EmployeeID = E.EmployeeID
	left outer join tblDesignation D On G.DesignationID = D.DesignationID
	left outer join tblSection S On G.SectionID = S.SectionID
	left outer join tblBlocks B on G.BlockID=B.BlockID
	Where SalaryYear = @SalaryYear and SalaryMonth = @SalaryMonth
	and G.SectionID like @SectionIDParam
	and ISNULL(G.BlockID,'') like @BlockIDParam
	and EntryPoint = @EntryPoint
	order by S.Section,G.CardNo,G.JoiningDate
end

GO

-- exec spGetSalarySummary 2020,7
alter proc spGetSalarySummary
@SalaryYear int,
@SalaryMonth int
as
begin

	Select S.Section,count(*) as 'NoOfEmp',sum(net_payable) as 'SalaryAmount',SUM(G.friday_allowance) as 'friday_allowance','' as 'Remarks'
	from tblGeneratedSalary G 
	inner join tblEmployeeInfo E On G.EmployeeID = E.EmployeeID
	left outer join tblDesignation D On G.DesignationID = D.DesignationID
	left outer join tblSection S On G.SectionID = S.SectionID
	Where SalaryYear = @SalaryYear and SalaryMonth = @SalaryMonth
	group by S.Section
	order by S.Section
end

GO

-- exec spProcessSalaryAll 2020,07,'07/01/2020','07/24/2020','mamun'
alter proc spProcessSalaryAll
@SalaryYear int,
@SalaryMonth int,
@StartDate date,
@EndDate date,
@ProcessedBy nvarchar(50)
as
begin
SET NOCOUNT ON
	Declare @EntryPoint as nvarchar(50) Set @EntryPoint ='';
	Declare @Count as int Set @Count = 0;
	Declare @NCount as int Set @NCount = 0;
	Declare @EmployeeID as nvarchar(50) Set @EmployeeID = '';

BEGIN TRAN

	Set @EntryPoint = 'S.'+convert(nvarchar,CURRENT_TIMESTAMP,102)+'.'+convert(nvarchar,CURRENT_TIMESTAMP,108);

	declare @emp_tbl as table(
	SLNO int identity(1,1),
	EmployeeID nvarchar(50),
	Taken bit default 0
	);

	Insert Into @emp_tbl(EmployeeID)
	Select S.EmployeeID from tblSalarySetup S inner join tblEmployeeInfo E on S.EmployeeID = E.EmployeeID
	Where E.IsActive=1;

	Insert Into @emp_tbl(EmployeeID)
	Select distinct S.EmployeeID from tblSalarySetup S inner join tblEmployeeInfo E on S.EmployeeID = E.EmployeeID
	inner join tblUserAttendance U on E.EmployeeID = U.EmployeeID
	Where E.IsActive=0 and YEAR(U.LogTime)=@SalaryYear and MONTH(U.LogTime)=@SalaryMonth

	Select @NCount = count(*)  from @emp_tbl;

	While @Count < @NCount
	begin
		Select top 1 @EmployeeID=EmployeeID from @emp_tbl where Taken =0;

		exec spProcessSalary @EmployeeID,@SalaryYear,@SalaryMonth,@StartDate,@EndDate,@EntryPoint,@ProcessedBy

		update @emp_tbl Set Taken = 1 where EmployeeID = @EmployeeID;
		Set @Count = @Count + 1;
		Set @EmployeeID = '';
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end


GO

select * from tblSalarySetup where len(isnull(BankAccountNo,'')) > 1;

-- exec spProcessSalary 'EMP-00003747',2021,04,'04/01/2021','04/30/2021','S.2021050300001','dsamaddar'

alter proc spProcessSalary
@EmployeeID nvarchar(50),
@SalaryYear int,
@SalaryMonth int,
@StartDate date,
@EndDate date,
@EntryPoint nvarchar(50),
@ProcessedBy nvarchar(50)
as
begin

	Declare @GeneratedSalaryID nvarchar(50)
	Declare @CurrentGeneratedSalaryID numeric(18,0)
	Declare @GeneratedSalaryIDPrefix as nvarchar(3)

	set @GeneratedSalaryIDPrefix='GS-';

begin tran

	Declare @StartOfTheMonth as date Set @StartOfTheMonth = convert(date, convert(nvarchar,@SalaryMonth) + '/1/' +convert(nvarchar,@SalaryYear));

	Declare @DesignationID as nvarchar(50) Set @DesignationID = '';
	Declare @Grade as int Set @Grade = 0;
	Declare @CardNo as nvarchar(50) Set @CardNo = '';
	Declare @SectionID as nvarchar(50) Set @SectionID = '';
	Declare @BlockID as nvarchar(50) Set @BlockID = '';
	Declare @JoiningDate as date
	Declare @ExitDate as date

	Declare @basic_salary as numeric(18,2) Set @basic_salary = 0;
	Declare @house_rent as numeric(18,2) Set @house_rent =0;
	Declare @medical_allowance numeric(18,2) Set @medical_allowance =0;
	Declare @conveyance as numeric(10,2) Set @conveyance = 0;
	Declare @food_allowance as numeric(10,2) Set @food_allowance = 0;
	Declare @gross_salary as numeric(18,2) Set @gross_salary =0;
	
	Declare @ttl_dom int Set @ttl_dom = 0;
	Declare @ttl_working_days int Set @ttl_working_days = 0;
	Declare @ttl_sal_days int Set @ttl_sal_days = 0;
	Declare @absent_days as int Set @absent_days = 0;
	Declare @interim_abs_days as int Set @interim_abs_days = 0;
	Declare @leave_days as int Set @leave_days =0;
	Declare @present_days as int Set @present_days = 0;

	Declare @absent_deduction as numeric(18,2) Set @absent_deduction = 0;
	Declare @friday_allowance_rate as numeric(18,2) Set @friday_allowance_rate = 0;
	Declare @ttl_friday as int Set @ttl_friday = 0;
	Declare @friday_allowance as numeric(18,2) Set @friday_allowance =0;
	Declare @attendance_bonus as numeric(18,2) Set @attendance_bonus =0;
	Declare @ot_rate as numeric(5,2) Set @ot_rate = 0;
	Declare @ot_hr numeric(5,2) Set @ot_hr = 0;
	Declare @ot_amt numeric(10,2) Set @ot_amt = 0;
	Declare @advance as numeric(10,2) Set @advance = 0;
	Declare @renenue_deduction as numeric(10,2) Set @renenue_deduction = 0;
	Declare @stamp_deduction as numeric(18,2) Set @stamp_deduction =10;
	Declare @ttl_payable_amt as numeric(18,2) Set @ttl_payable_amt = 0;
	Declare @net_payable as numeric(18,2) Set @net_payable =0;
	Declare @bank_account as nvarchar(50) Set @bank_account = '';
	Declare @sDate as date Set @sDate = @StartDate;
	Declare @eDate as date Set @eDate = @EndDate;


	Select @DesignationID=e.DesignationID,@Grade=isnull(d.IntOrder,0),@CardNo=CardNo, @SectionID = SectionID,@BlockID=BlockID, @JoiningDate = JoiningDate,
	@ExitDate = ISNULL(ExitDate,'01/01/2030')
	from tblEmployeeInfo e left join tblDesignation d on e.DesignationID = d.DesignationID
	Where EmployeeID = @EmployeeID

	Select @basic_salary=BasicSalary,@house_rent=HouseRent,@medical_allowance=MedicalAllowance,@conveyance = Conveyance,@food_allowance = FoodAllowance,
	@gross_salary=GrossSalary,@bank_account = BankAccountNo
	from tblSalarySetup Where EmployeeID = @EmployeeID;

	Set @ttl_dom = DAY(EOMONTH(@StartOfTheMonth));
	
	if @JoiningDate > @StartDate
		Set @StartDate = @JoiningDate

	if @ExitDate < @EndDate
		Set @EndDate = @ExitDate

	if @ExitDate < @StartDate
		Set @EndDate = @StartDate 

	Set @ttl_working_days = dbo.fnCountWorkingDaydtRange(@StartDate,@EndDate);
	
	Set @ttl_sal_days = DATEDIFF(DAY,@StartDate,@EndDate)+1;

	Set @absent_days = dbo.fnCountAbsentdtRange(@EmployeeID,@StartDate,@EndDate);
	
	Set @interim_abs_days = dbo.fnCountInterimAbsentdtRange(@EmployeeID,@StartDate,@EndDate);
	
	Set @leave_days = dbo.fnCountOnLeavedtRange(@EmployeeID,@StartDate,@EndDate);
	

	Set @absent_days = @absent_days - @interim_abs_days;
	
	Set @present_days = @ttl_working_days - @absent_days - @leave_days
	--print 'PD - ' + convert(nvarchar,@present_days)

	Set @absent_deduction = (@gross_salary/@ttl_dom) * @absent_days;
	
	if @EmployeeID='EMP-00000901'
		Set @friday_allowance_rate = 300;
	else
		Set @friday_allowance_rate = dbo.fnGetFridayAllowanceRate(@SectionID,@gross_salary,@ttl_dom);

	Set @ot_rate = (@basic_salary/208)*2;
	Set @ot_hr = dbo.fnGetOTHrsSalaryPart(@EmployeeID,@StartDate,@EndDate);
	Set @ot_amt = @ot_rate * @ot_hr;

	Set @ttl_friday = dbo.fnCountFridayAttendancedtRange(@EmployeeID,@StartDate,@EndDate);
	Set @friday_allowance = @friday_allowance_rate * @ttl_friday;

	Set @attendance_bonus = dbo.fnGetAttendanceBonusdtRange(@SectionID,@ttl_dom,@StartDate,@EndDate,@present_days);
	Set @ttl_payable_amt = ((@gross_salary/@ttl_dom)*(@present_days+@leave_days))+@friday_allowance+@attendance_bonus + @conveyance + @food_allowance + @ot_amt;
	Set @net_payable = @ttl_payable_amt - @stamp_deduction - @advance - @renenue_deduction
	
	if not exists(select * from tblGeneratedSalary where EmployeeID=@EmployeeID and SalaryMonth=@SalaryMonth and SalaryYear=@SalaryYear and StartDate=@StartDate and EndDate=@EndDate)
	begin
		select @CurrentGeneratedSalaryID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentGeneratedSalaryID'
		set @CurrentGeneratedSalaryID=isnull(@CurrentGeneratedSalaryID,0)+1
		Select @GeneratedSalaryID=dbo.generateID(@GeneratedSalaryIDPrefix,@CurrentGeneratedSalaryID,8)		
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		insert into tblGeneratedSalary(GeneratedSalaryID,EmployeeID,SalaryYear,SalaryMonth,StartDate,EndDate,DesignationID,Grade,CardNo,SectionID,BlockID,
		JoiningDate,basic_salary,house_rent,medical_allowance,conveyance,food_allowance,gross_salary,ttl_dom,present_days ,
		absent_days,leave_days,absent_deduction,friday_allowance_rate,ttl_friday,friday_allowance,
		attendance_bonus,ot_rate,ot_hr,ot_amt,advance,revenue_deduction,ttl_payable_amt,stamp_deduction,net_payable,bank_account,EntryPoint,ProcessedBy)
		values(@GeneratedSalaryID,@EmployeeID,@SalaryYear,@SalaryMonth,@sDate,@eDate,@DesignationID,@Grade,@CardNo,@SectionID,@BlockID,
		@JoiningDate,round(@basic_salary,0),round(@house_rent,0),round(@medical_allowance,0),@conveyance,@food_allowance,round(@gross_salary,0),@ttl_dom,@present_days ,
		@absent_days,@leave_days,round(@absent_deduction,0),round(@friday_allowance_rate,0),@ttl_friday,round(@friday_allowance,0),
		round(@attendance_bonus,0),@ot_rate,@ot_hr,@ot_amt,@advance,@renenue_deduction,round(@ttl_payable_amt,0),@stamp_deduction,round(@net_payable,0),@bank_account,@EntryPoint,@ProcessedBy);
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentGeneratedSalaryID where PropertyName='CurrentGeneratedSalaryID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end
	else
	begin
		update tblGeneratedSalary 
		set DesignationID=@DesignationID,Grade=@Grade,CardNo=@CardNo,SectionID=@SectionID,BlockID=@BlockID,
		JoiningDate=@JoiningDate,basic_salary=round(@basic_salary,0),house_rent=round(@house_rent,0),medical_allowance=round(@medical_allowance,0),
		conveyance=@conveyance,food_allowance=@food_allowance,gross_salary=round(@gross_salary,0),ttl_dom=@ttl_dom,present_days=@present_days ,
		absent_days=@absent_days,leave_days=@leave_days,absent_deduction=round(@absent_deduction,0),friday_allowance_rate=round(@friday_allowance_rate,0),
		ttl_friday=@ttl_friday,friday_allowance=round(@friday_allowance,0),
		attendance_bonus=round(@attendance_bonus,0),ot_rate=@ot_rate,ot_hr=@ot_hr,ot_amt = @ot_amt,advance=@advance,revenue_deduction = @renenue_deduction,
		ttl_payable_amt=round(@ttl_payable_amt,0),stamp_deduction=@stamp_deduction,
		net_payable=round(@net_payable,0),bank_account=@bank_account,EntryPoint=@EntryPoint,ProcessedBy=@ProcessedBy
		Where EmployeeID=@EmployeeID and SalaryMonth=@SalaryMonth and SalaryYear=@SalaryYear and StartDate=@sDate and EndDate=@eDate
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

-- select * from tblEmployeeInfo where CardNo='10208';
-- select * from tblSalarySetup where EmployeeID='EMP-00000811';

GO

-- insert into tblAppSettings(PropertyName,PropertyValue)values('CurrentGeneratedFestivalID',0);
-- drop table tblGeneratedFestivalBonus;
GO
-- delete from tblGeneratedFestivalBonus;
Create table tblGeneratedFestivalBonus(
GeneratedFestivalID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
FestivalTypeID int,
FestivalYear int,
FestivalMonth int,
DesignationID nvarchar(50) foreign key references tblDesignation(DesignationID),
CardNo nvarchar(50),
SectionID nvarchar(50) foreign key references tblSection(SectionID),
BlockID nvarchar(50) foreign key references tblBlocks(BlockID),
Grade int,
JoiningDate date,
EffectiveDate date,
basic_salary numeric(18,2) default 0,
house_rent numeric(18,2) default 0,
medical_allowance numeric(18,2) default 0,
gross_salary numeric(18,2) default 0,
conveyance numeric(18,2) default 0,
food_allowance numeric(18,2) default 0,
bonus_amount numeric(18,2) default 0,
net_payable numeric(18,2) default 0,
EntryPoint nvarchar(50),
ProcessedBy nvarchar(50) default 'admin',
ProcessDate datetime default getdate()
);

GO

insert into tblAppSettings(PropertyName,PropertyValue)values('CurrentGeneratedFestivalCompID',0);

GO
Create table tblGeneratedFestivalBonusComp(
GeneratedFestivalCompID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
FestivalTypeID int,
FestivalYear int,
FestivalMonth int,
DesignationID nvarchar(50) foreign key references tblDesignation(DesignationID),
CardNo nvarchar(50),
SectionID nvarchar(50) foreign key references tblSection(SectionID),
BlockID nvarchar(50) foreign key references tblBlocks(BlockID),
Grade int,
JoiningDate date,
EffectiveDate date,
basic_salary numeric(18,2) default 0,
house_rent numeric(18,2) default 0,
medical_allowance numeric(18,2) default 0,
gross_salary numeric(18,2) default 0,
conveyance numeric(18,2) default 0,
food_allowance numeric(18,2) default 0,
bonus_amount numeric(18,2) default 0,
net_payable numeric(18,2) default 0,
EntryPoint nvarchar(50),
ProcessedBy nvarchar(50) default 'admin',
ProcessDate datetime default getdate()
);
GO

alter proc spProcessFestivalBonusInd
@EmployeeID nvarchar(50),
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int,
@EffectiveDate date,
@EntryPoint nvarchar(50),
@ProcessedBy nvarchar(50)
as
begin
	print 'X';
	Declare @GeneratedFestivalID nvarchar(50)
	Declare @CurrentGeneratedFestivalID numeric(18,0)
	Declare @GeneratedFestivalIDPrefix as nvarchar(3)
	print 'Y';
	set @GeneratedFestivalIDPrefix='GF-';

begin tran

	select @CurrentGeneratedFestivalID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentGeneratedFestivalID';
	print 'Z';
	set @CurrentGeneratedFestivalID=isnull(@CurrentGeneratedFestivalID,0)+1;
	Select @GeneratedFestivalID=dbo.generateID(@GeneratedFestivalIDPrefix,@CurrentGeneratedFestivalID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	print 'A';

	Declare @DesignationID as nvarchar(50) Set @DesignationID = '';
	Declare @CardNo as nvarchar(50) Set @CardNo = '';
	Declare @SectionID as nvarchar(50) Set @SectionID = '';
	Declare @BlockID as nvarchar(50) Set @BlockID = '';
	Declare @Grade as int Set @Grade = 0;
	Declare @JoiningDate as date

	Declare @basic_salary as numeric(18,2) Set @basic_salary = 0;
	Declare @house_rent as numeric(18,2) Set @house_rent =0;
	Declare @medical_allowance numeric(18,2) Set @medical_allowance =0;
	Declare @gross_salary as numeric(18,2) Set @gross_salary =0;
	Declare @conveyance as numeric(18,2) Set @conveyance = 0;
	Declare @food_allowance as numeric(18,2) Set @food_allowance = 0;
	Declare @bonus_amount as numeric(18,2) Set @bonus_amount = 0;
	Declare @tenor as int set @tenor = 0;
	Declare @net_payable as numeric(18,2) Set @net_payable =0;
	
	Select @DesignationID=DesignationID, @CardNo=CardNo, @SectionID = SectionID,@BlockID=BlockID, @JoiningDate = JoiningDate
	from tblEmployeeInfo Where EmployeeID = @EmployeeID

	Select @basic_salary=ISNULL(BasicSalary,0),@house_rent=ISNULL(HouseRent,0),
	@medical_allowance=ISNULL(MedicalAllowance,0),
	@gross_salary=ISNULL(GrossSalary,0),@conveyance = 350,@food_allowance=900
	from tblSalarySetup Where EmployeeID = @EmployeeID;

	select @Grade = IntOrder from tblDesignation where DesignationID = @DesignationID;
	Set @Grade = ISNULL(@Grade,0);

	print 'B';

	set @tenor = DATEDIFF(DAY,@JoiningDate,@EffectiveDate)

	if @tenor > 365
		set @bonus_amount = @basic_salary * 0.50
	else if @tenor > 270 and @tenor <= 365
		set @bonus_amount = @basic_salary * 0.33
	else if @tenor > 180 and @tenor <= 270
		set @bonus_amount = @basic_salary * 0.25
	else if @tenor > 90 and @tenor <= 180
		set @bonus_amount = 300
	else
		set @bonus_amount = 200

	Set @net_payable = @bonus_amount;

	print 'C';

	if not exists(select * from tblGeneratedFestivalBonus where EmployeeID=@EmployeeID and FestivalMonth=@FestivalMonth and FestivalYear=@FestivalYear and FestivalTypeID=@FestivalTypeID)
	begin
		insert into tblGeneratedFestivalBonus(GeneratedFestivalID,EmployeeID,FestivalTypeID,FestivalYear,FestivalMonth,DesignationID,
		CardNo,SectionID,BlockID,Grade,JoiningDate,EffectiveDate,basic_salary,house_rent,medical_allowance,gross_salary,conveyance,food_allowance,bonus_amount,net_payable,
		EntryPoint,ProcessedBy,ProcessDate)
		values(@GeneratedFestivalID,@EmployeeID,@FestivalTypeID,@FestivalYear,@FestivalMonth,@DesignationID,
		@CardNo,@SectionID,@BlockID,@Grade,@JoiningDate,@EffectiveDate,@basic_salary,@house_rent,@medical_allowance,@gross_salary,@conveyance,@food_allowance,@bonus_amount,@net_payable, 
		@EntryPoint,@ProcessedBy,GETDATE());
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentGeneratedFestivalID where PropertyName='CurrentGeneratedFestivalID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO


alter proc spProcessFestivalBonusCompInd
@EmployeeID nvarchar(50),
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int,
@EffectiveDate date,
@EntryPoint nvarchar(50),
@ProcessedBy nvarchar(50)
as
begin
	print 'X';
	Declare @GeneratedFestivalCompID nvarchar(50)
	Declare @CurrentGeneratedFestivalCompID numeric(18,0)
	Declare @GeneratedFestivalCompIDPrefix as nvarchar(4)
	print 'Y';
	set @GeneratedFestivalCompIDPrefix='GFC-';

begin tran

	select @CurrentGeneratedFestivalCompID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentGeneratedFestivalCompID';
	print 'Z';
	set @CurrentGeneratedFestivalCompID=isnull(@CurrentGeneratedFestivalCompID,0)+1;
	Select @GeneratedFestivalCompID=dbo.generateID(@GeneratedFestivalCompIDPrefix,@CurrentGeneratedFestivalCompID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	print 'A';

	Declare @DesignationID as nvarchar(50) Set @DesignationID = '';
	Declare @CardNo as nvarchar(50) Set @CardNo = '';
	Declare @SectionID as nvarchar(50) Set @SectionID = '';
	Declare @BlockID as nvarchar(50) Set @BlockID = '';
	Declare @Grade as int Set @Grade = 0;
	Declare @JoiningDate as date

	Declare @basic_salary as numeric(18,2) Set @basic_salary = 0;
	Declare @house_rent as numeric(18,2) Set @house_rent =0;
	Declare @medical_allowance numeric(18,2) Set @medical_allowance =0;
	Declare @gross_salary as numeric(18,2) Set @gross_salary =0;
	Declare @conveyance as numeric(18,2) Set @conveyance = 0;
	Declare @food_allowance as numeric(18,2) Set @food_allowance = 0;
	Declare @bonus_amount as numeric(18,2) Set @bonus_amount = 0;
	Declare @tenor as int set @tenor = 0;
	Declare @net_payable as numeric(18,2) Set @net_payable =0;
	
	Select @DesignationID=DesignationID, @CardNo=CardNo, @SectionID = SectionID,@BlockID=BlockID, @JoiningDate = JoiningDate
	from tblEmployeeInfo Where EmployeeID = @EmployeeID

	Select @basic_salary=ISNULL(BasicSalary,0),@house_rent=ISNULL(HouseRent,0),
	@medical_allowance=ISNULL(MedicalAllowance,0),
	@gross_salary=ISNULL(GrossSalary,0),@conveyance = 350,@food_allowance=900
	from tblSalarySetupComp Where EmployeeID = @EmployeeID;

	select @Grade = IntOrder from tblDesignation where DesignationID = @DesignationID;
	Set @Grade = ISNULL(@Grade,0);

	print 'B';

	set @tenor = DATEDIFF(DAY,@JoiningDate,@EffectiveDate)

	if @tenor > 365
		set @bonus_amount = @basic_salary * 0.50
	else if @tenor > 270 and @tenor <= 365
		set @bonus_amount = @basic_salary * 0.33
	else if @tenor > 180 and @tenor <= 270
		set @bonus_amount = @basic_salary * 0.25
	else if @tenor > 90 and @tenor <= 180
		set @bonus_amount = 300
	else
		set @bonus_amount = 200

	Set @net_payable = @bonus_amount;

	print 'C';

	if not exists(select * from tblGeneratedFestivalBonusComp where EmployeeID=@EmployeeID and FestivalMonth=@FestivalMonth and FestivalYear=@FestivalYear and FestivalTypeID=@FestivalTypeID)
	begin
		insert into tblGeneratedFestivalBonusComp(GeneratedFestivalCompID,EmployeeID,FestivalTypeID,FestivalYear,FestivalMonth,DesignationID,
		CardNo,SectionID,BlockID,Grade,JoiningDate,EffectiveDate,basic_salary,house_rent,medical_allowance,gross_salary,conveyance,food_allowance,bonus_amount,net_payable,
		EntryPoint,ProcessedBy,ProcessDate)
		values(@GeneratedFestivalCompID,@EmployeeID,@FestivalTypeID,@FestivalYear,@FestivalMonth,@DesignationID,
		@CardNo,@SectionID,@BlockID,@Grade,@JoiningDate,@EffectiveDate,@basic_salary,@house_rent,@medical_allowance,@gross_salary,@conveyance,@food_allowance,@bonus_amount,@net_payable, 
		@EntryPoint,@ProcessedBy,GETDATE());
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentGeneratedFestivalCompID where PropertyName='CurrentGeneratedFestivalCompID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

-- exec spProcessFestivalBonus 2,2020,8,'8/1/2020','mamun'
alter proc spProcessFestivalBonus
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int,
@EffectiveDate date,
@ProcessedBy nvarchar(50)
as
begin
	Declare @emp_tbl as table(
	EmployeeID nvarchar(50),
	Taken bit default 0
	);

	Declare @EmployeeID as nvarchar(50) Set @EmployeeID = '';
	Declare @Count as int Set @Count = 1;
	Declare @NCount as int Set @NCount = 0;
	Declare @EntryPoint as nvarchar(50) Set @EntryPoint='';

	insert into @emp_tbl(EmployeeID)
	select EmployeeID from tblEmployeeInfo where IsActive=1;

	Set @EntryPoint = 'F.'+convert(nvarchar,CURRENT_TIMESTAMP,102)+'.'+convert(nvarchar,CURRENT_TIMESTAMP,108);
	select @NCount = count(*) from  @emp_tbl;

	while @Count <= @NCount
	begin
		select top 1 @EmployeeID = EmployeeID from @emp_tbl where taken=0;

		exec spProcessFestivalBonusInd @EmployeeID,@FestivalTypeID,@FestivalYear,
		@FestivalMonth,@EffectiveDate,@EntryPoint,@ProcessedBy

		exec spProcessFestivalBonusCompInd @EmployeeID,@FestivalTypeID,@FestivalYear,
		@FestivalMonth,@EffectiveDate,@EntryPoint,@ProcessedBy

		update @emp_tbl set taken=1 where EmployeeID = @EmployeeID;
		Set @Count += 1;
		Set @EmployeeID = '';
	end
end

go

alter proc spGetBonusReport
@SectionID nvarchar(50),
@BlockID nvarchar(50),
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int
as
begin

	Declare @SectionIDParam as nvarchar(50) Set @SectionIDParam = '';
	Declare @BlockIDParam as nvarchar(50) Set @BlockIDParam = '';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	if @BlockID = 'ALL'
		Set @BlockIDParam = '%'
	else
		Set @BlockIDParam = '%' + @BlockID + '%'

	Select E.EmployeeName,G.CardNo+ '/' + ISNULL(E.MachineNo,'-') as 'CardNo',convert(nvarchar,G.JoiningDate,101) as 'JoiningDate',
	D.Designation,S.Section,ISNULL(B.Block,'-') as Block,ISNULL(G.Grade,0) as Grade,basic_salary,
	house_rent,medical_allowance,gross_salary,G.conveyance,food_allowance,net_payable
	from tblGeneratedFestivalBonus G 
	inner join tblEmployeeInfo E On G.EmployeeID = E.EmployeeID
	left outer join tblDesignation D On G.DesignationID = D.DesignationID
	left outer join tblSection S On G.SectionID = S.SectionID
	left outer join tblBlocks B on G.BlockID = B.BlockID
	Where FestivalYear = @FestivalYear and FestivalMonth = @FestivalMonth
	and FestivalTypeID = @FestivalTypeID
	and G.SectionID like @SectionIDParam
	and ISNULL(G.BlockID,'') like @BlockIDParam
	order by S.Section,B.Block,E.MachineNo
end

GO

Create proc spGetBonusReportComp
@SectionID nvarchar(50),
@BlockID nvarchar(50),
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int
as
begin

	Declare @SectionIDParam as nvarchar(50) Set @SectionIDParam = '';
	Declare @BlockIDParam as nvarchar(50) Set @BlockIDParam = '';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%' + @SectionID + '%'

	if @BlockID = 'ALL'
		Set @BlockIDParam = '%'
	else
		Set @BlockIDParam = '%' + @BlockID + '%'

	Select E.EmployeeName,G.CardNo+ '/' + ISNULL(E.MachineNo,'-') as 'CardNo',convert(nvarchar,G.JoiningDate,101) as 'JoiningDate',
	D.Designation,S.Section,ISNULL(B.Block,'-') as Block,ISNULL(G.Grade,0) as Grade,basic_salary,
	house_rent,medical_allowance,gross_salary,G.conveyance,food_allowance,net_payable
	from tblGeneratedFestivalBonusComp G 
	inner join tblEmployeeInfo E On G.EmployeeID = E.EmployeeID
	left outer join tblDesignation D On G.DesignationID = D.DesignationID
	left outer join tblSection S On G.SectionID = S.SectionID
	left outer join tblBlocks B on G.BlockID = B.BlockID
	Where FestivalYear = @FestivalYear and FestivalMonth = @FestivalMonth
	and FestivalTypeID = @FestivalTypeID
	and G.SectionID like @SectionIDParam
	and ISNULL(G.BlockID,'') like @BlockIDParam
	order by S.Section,B.Block,E.MachineNo
end


GO

alter proc spGetBonusSummary
@FestivalTypeID int,
@FestivalYear int,
@FestivalMonth int
as
begin
	Select S.Section,count(*) as 'NoOfEmp',sum(net_payable) as 'BonusAmount','' as 'Remarks'
	from tblGeneratedFestivalBonus G 
	inner join tblEmployeeInfo E On G.EmployeeID = E.EmployeeID
	left outer join tblDesignation D On G.DesignationID = D.DesignationID
	left outer join tblSection S On G.SectionID = S.SectionID
	left outer join tblBlocks B on G.BlockID = B.BlockID
	Where FestivalYear = @FestivalYear and FestivalMonth = @FestivalMonth
	and FestivalTypeID = @FestivalTypeID
	group by S.Section
	order by S.Section
end

GO

Create proc spReverseSalary
@EntryPoint nvarchar(50)
as
begin
	delete from tblGeneratedSalary Where EntryPoint = @EntryPoint
end

GO