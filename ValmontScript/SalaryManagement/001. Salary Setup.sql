
Insert Into tblAppSettings(PropertyName,PropertyValue)values('CurrentSalarySetupID',0);


-- select * from tblEmployeeInfo where EmpCode='10085';
-- select * from tblSalarySetup where EmployeeID = 'EMP-00001437';
-- select * into tblSalarySetupTemp from tblSalarySetup;
-- insert into tblSalarySetup select * from tblSalarySetupTemp;
-- drop table tblSalarySetup
Create table tblSalarySetup(
SalarySetupID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
BasicSalary numeric(10,2),
HouseRent numeric(10,2),
MedicalAllowance numeric(10,2),
GrossSalary numeric(10,2),
FridayAllowance_per numeric(5,2),
FridayAllowance_fixed numeric(10,2),
Conveyance numeric(10,2),
FoodAllowance numeric(10,2),
PaymentMethod char(1),
BankAccountNo nvarchar(50),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spGetSalarySetup
@EmployeeID nvarchar(50)
as
begin
	if not exists(Select * from tblSalarySetup Where EmployeeID = @EmployeeID )
	begin
		Select 0 as BasicSalary,0 as HouseRent,0 as MedicalAllowance,0 as GrossSalary,0 as FridayAllowance_per,
		0 as FridayAllowance_fixed, 0 as Conveyance, 0 as FoodAllowance,'C' as PaymentMethod, '' as BankAccountNo
		from tblSalarySetup Where EmployeeID = @EmployeeID;
	end
	else
	begin
		Select BasicSalary,HouseRent,MedicalAllowance,GrossSalary,FridayAllowance_per,FridayAllowance_fixed,
		ISNULL(Conveyance,0) as Conveyance, ISNULL(FoodAllowance,0) as FoodAllowance,ISNULL(PaymentMethod,'C') as PaymentMethod,
		ISNULL(BankAccountNo,'') as BankAccountNo
		from tblSalarySetup Where EmployeeID = @EmployeeID;
	end
end

GO

alter proc spInsertSalarySetup
@EmployeeID nvarchar(50),
@BasicSalary numeric(10,2),
@HouseRent numeric(10,2),
@MedicalAllowance numeric(10,2),
@GrossSalary numeric(10,2),
@FridayAllowance_per numeric(5,2),
@FridayAllowance_fixed numeric(10,2),
@Conveyance numeric(10,2),
@FoodAllowance numeric(10,2),
@PaymentMethod char(1),
@BankAccountNo nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @SalarySetupID nvarchar(50)
	Declare @CurrentSalarySetupID numeric(18,0)
	Declare @SalarySetupIDPrefix as nvarchar(4)

	set @SalarySetupIDPrefix='SS-'

begin tran
	
	select @CurrentSalarySetupID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentSalarySetupID'
	
	set @CurrentSalarySetupID=isnull(@CurrentSalarySetupID,0)+1
	Select @SalarySetupID=dbo.generateID(@SalarySetupIDPrefix,@CurrentSalarySetupID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	if exists(select * from tblSalarySetup Where EmployeeID = @EmployeeID)
	begin
		update tblSalarySetup set BasicSalary=@BasicSalary,HouseRent = @HouseRent,MedicalAllowance=@MedicalAllowance,
		FridayAllowance_per=@FridayAllowance_per,FridayAllowance_fixed=@FridayAllowance_fixed,GrossSalary = @GrossSalary,
		Conveyance = @Conveyance, FoodAllowance = @FoodAllowance,PaymentMethod=@PaymentMethod,BankAccountNo=@BankAccountNo
		where EmployeeID = @EmployeeID
	end
	else
	begin
		Insert Into tblSalarySetup(SalarySetupID,EmployeeID,BasicSalary,HouseRent,MedicalAllowance,FridayAllowance_per,FridayAllowance_fixed,GrossSalary,Conveyance,FoodAllowance,PaymentMethod,BankAccountNo,EntryBy)
		Values(@SalarySetupID,@EmployeeID,@BasicSalary,@HouseRent,@MedicalAllowance,@FridayAllowance_per,@FridayAllowance_fixed,@GrossSalary,@Conveyance,@FoodAllowance,@PaymentMethod,@BankAccountNo,@EntryBy)
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentSalarySetupID where PropertyName='CurrentSalarySetupID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

COMMIT TRAN
RETURN 0
ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Insert Into tblAppSettings(PropertyName,PropertyValue)values('CurrentCompSalarySetupID',0);

-- drop table tblSalarySetupComp
Create table tblSalarySetupComp(
CompSalarySetupID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
BasicSalary numeric(10,2),
HouseRent numeric(10,2),
MedicalAllowance numeric(10,2),
GrossSalary numeric(10,2),
FridayAllowance_per numeric(5,2),
FridayAllowance_fixed numeric(10,2),
Conveyance numeric(10,2),
FoodAllowance numeric(10,2),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spInsertSalarySetupComp
@EmployeeID nvarchar(50),
@BasicSalary numeric(10,2),
@HouseRent numeric(10,2),
@MedicalAllowance numeric(10,2),
@GrossSalary numeric(10,2),
@FridayAllowance_per numeric(5,2),
@FridayAllowance_fixed numeric(10,2),
@Conveyance numeric(10,2),
@FoodAllowance numeric(10,2),
@EntryBy nvarchar(50)
as
begin
	Declare @CompSalarySetupID nvarchar(50)
	Declare @CurrentCompSalarySetupID numeric(18,0)
	Declare @CompSalarySetupIDPrefix as nvarchar(4)

	set @CompSalarySetupIDPrefix='SSC-'

begin tran
	
	select @CurrentCompSalarySetupID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentCompSalarySetupID'
	
	set @CurrentCompSalarySetupID=isnull(@CurrentCompSalarySetupID,0)+1
	Select @CompSalarySetupID=dbo.generateID(@CompSalarySetupIDPrefix,@CurrentCompSalarySetupID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	if exists(select * from tblSalarySetupComp Where EmployeeID = @EmployeeID)
	begin
		update tblSalarySetupComp set BasicSalary=@BasicSalary,HouseRent = @HouseRent,MedicalAllowance=@MedicalAllowance,
		FridayAllowance_per=@FridayAllowance_per,FridayAllowance_fixed=@FridayAllowance_fixed,GrossSalary = @GrossSalary,
		Conveyance=@Conveyance,FoodAllowance=@FoodAllowance
		where EmployeeID = @EmployeeID
	end
	else
	begin
		Insert Into tblSalarySetupComp(CompSalarySetupID,EmployeeID,BasicSalary,HouseRent,MedicalAllowance,GrossSalary,FridayAllowance_per,FridayAllowance_fixed,Conveyance,FoodAllowance,EntryBy)
		Values(@CompSalarySetupID,@EmployeeID,@BasicSalary,@HouseRent,@MedicalAllowance,@GrossSalary,@FridayAllowance_per,@FridayAllowance_fixed,@Conveyance,@FoodAllowance,@EntryBy)
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentCompSalarySetupID where PropertyName='CurrentCompSalarySetupID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

COMMIT TRAN
RETURN 0
ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO
-- exec spGetSalarySetupComp 'EMP-00000648'
alter proc spGetSalarySetupComp
@EmployeeID nvarchar(50)
as
begin
	if not exists(Select * from tblSalarySetupComp Where EmployeeID = @EmployeeID )
	begin
		Select 0 as BasicSalary,0 as HouseRent,600 as MedicalAllowance,0 as GrossSalary,0 as FridayAllowance_per,
		0 as FridayAllowance_fixed,350 as Conveyance, 900 as FoodAllowance
	end
	else
	begin
		Select BasicSalary,HouseRent,MedicalAllowance,GrossSalary,FridayAllowance_per,FridayAllowance_fixed,
		Conveyance,FoodAllowance
		from tblSalarySetupComp Where EmployeeID = @EmployeeID;
	end
end

GO

/* join and update compliance salary to the actual salary*/

update S
set S.BasicSalary = CS.BasicSalary,
	S.HouseRent = CS.HouseRent,
	S.MedicalAllowance = CS.MedicalAllowance,
	S.GrossSalary = CS.GrossSalary,
	S.FridayAllowance_per = CS.FridayAllowance_per,
	S.FridayAllowance_fixed = CS.FridayAllowance_fixed,
	S.Conveyance = CS.Conveyance,
	S.FoodAllowance = CS.FoodAllowance
from tblSalarySetup S inner join tblSalarySetupComp CS ON S.EmployeeID = CS.EmployeeID

-- select * from tblSalarySetup

/*KNITTING,LINKING,TRIMMING Salary Setup*/

/*
Declare @Count as int Set @Count = 1
Declare @NCount as int Set @NCount = 0
Declare @EmployeeID as nvarchar(50) Set @EmployeeID = '';

declare @tbl as table(
EmployeeID nvarchar(50),
taken bit default 0
);

insert into @tbl(EmployeeID)
select EmployeeID from tblEmployeeInfo where SectionID in ('SEC-00000003','SEC-00000004','SEC-00000027');

select @NCount = count(*) from @tbl

while @Count <= @NCount
begin
	select top 1 @EmployeeID = EmployeeID from @tbl where taken=0

	exec spInsertSalarySetup @EmployeeID,3912,1565,200,5678,0,0,'mamun';

	update @tbl set taken=1 where EmployeeID=@EmployeeID
	Set @Count +=1;
	Set @EmployeeID = '';
end

*/





