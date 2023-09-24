
declare @EmpTbl as table(
SLNO int identity(1,1),
EmployeeID nvarchar(50),
Salary numeric(18,2),
Taken bit default 0
);

Insert  into @EmpTbl(EmployeeID,Salary)
Select EmployeeID,BasicSalary from 
tblEmployeeInfo where IsActive=1
and SectionID not  in (
'SEC-00000003',
'SEC-00000004',
'SEC-00000006'
);

select * from @EmpTbl;

declare @Count as int Set @Count = 1
Declare @NCount as int
select @NCount = count(*) from @EmpTbl;

declare @EmployeeID as nvarchar(50) Set @EmployeeID = '';
declare @Salary as numeric(18,2) Set @Salary = 0;
declare @BasicSalary as numeric(18,2) Set @BasicSalary = 0;
declare @HouseRent as numeric(18,2) Set @HouseRent = 0;
declare @MedicalAllowance as numeric(18,2) Set @MedicalAllowance = 0;
While @Count < @NCount
begin
	Select top 1 @EmployeeID=EmployeeID,@Salary=Salary 
	from @EmpTbl where Taken = 0;

	Set @BasicSalary = (@Salary-200)/1.4;
	set @HouseRent = @BasicSalary*0.4;
	Set @MedicalAllowance = 200;

	exec spInsertSalarySetup @EmployeeID,@BasicSalary,@HouseRent,@MedicalAllowance,0,0,'mamun'

	Update @EmpTbl Set Taken = 1 where EmployeeID=@EmployeeID;
	Set @Count = @Count + 1;
	Set @EmployeeID = '';
	Set @Salary = 0;
	Set @BasicSalary = 0;
	Set @HouseRent = 0;
	Set @MedicalAllowance = 0;

end;


-- select * from tblSalarySetup;