select * from dbo.migration;

select distinct Section from dbo.migration;
select distinct Designation from dbo.migration;

select * from dbo.migration where Designation NOT IN (select Designation from tblDesignation)

select distinct Designation from dbo.migration  where (Designation LIKE '%elec%');
select distinct Designation from dbo.migration  where (Designation LIKE '%link%');


update dbo.migration Set Designation='GEN. OPERATOR' Where Designation='G.OPT';

declare @mtbl as table(
slno int identity(1,1),
name nvarchar(200),
cardno nvarchar(50),
section nvarchar(50),
block nvarchar(50),
designation nvarchar(50),
joiningdate date,
basicsalary numeric(18,2),
taken bit default 0
)

Insert into @mtbl(name,cardno,section,block,designation,joiningdate,basicsalary)
Select name,cardno,dbo.fnsection(section),dbo.fnBlolck(block),dbo.fnDesignation(designation),joiningdate,basicsalary 
from emptbl

SElect * from @mtbl


Declare @Count as int Set @Count = 1
Declare @NCount as int Set @NCount = 0

declare @slno as int Set @slno = 0
Declare @name as nvarchar(200) Set @name = ''
Declare @cardno as nvarchar(50) set @cardno = ''
Declare @section as nvarchar(50) set @section =''
Declare @block as nvarchar(50) set @block = ''
Declare @designation as nvarchar(50) set @designation = ''
Declare @joiningdate as date
Declare @basicsalary as numeric(18,2) set @basicsalary= 0


Select @NCount = Count(*) from @mtbl

While @Count <= @NCount
begin
	
	Select top 1 @slno=slno,@name=name,@cardno=cardno,@section=section,@block=block,@designation=designation,@joiningdate=isnull(joiningdate,getdate()),@basicsalary=isnull(basicsalary,0)
	from @mtbl Where taken=0

	exec spInsertEmployeeSimple @name,@cardno,@joiningdate,@basicsalary,@block,@section,@designation

	update @mtbl Set taken=1 Where slno=@slno
	set @Count = @Count + 1
	set @name = ''
	SEt @cardno = ''
	set @block =''
	set @section= ''
	set @designation = ''
end



