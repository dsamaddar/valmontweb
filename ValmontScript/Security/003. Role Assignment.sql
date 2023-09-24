GO

Insert Into tblAppSettings(PropertyName,PropertyValue)Values('CurrentRoleAssignID',0)

GO

Create table tblRoleAssignment(
RoleAssignID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
RoleID nvarchar(50) foreign key references tblRole(RoleID),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spGetAssignedRoleByEmployee
@EmployeeID nvarchar(50)
as
begin
	Select R.RoleID,R.RoleName from tblRoleAssignment RA INNER JOIN tblRole R ON RA.RoleID=R.RoleID
	Where RA.EmployeeID = @EmployeeID
	Order By R.RoleName
end
-- exec spGetAssignedRoleByEmployee 'EMP-00000901'

GO

alter proc spInsertRoleAssignmentList
@EmployeeID nvarchar(50),
@RoleList nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	Declare @RoleTbl table(
	SL int identity(1,1),
	RoleID nvarchar(50)
	);

begin tran

	delete from tblRoleAssignment Where EmployeeID=@EmployeeID

	Insert Into @RoleTbl
	Select value from dbo.Split(',',@RoleList)

	Declare @RoleID as nvarchar(50) Set @RoleID = ''
	Declare @Count as int Set @Count = 1
	Declare @NCount as int Set @NCount = 0

	Select @NCount = Count(*) from @RoleTbl

	While @Count <= @NCount
	begin
		Select @RoleID=RoleID from @RoleTbl Where SL = @Count

		exec spInsertRoleAssignment @EmployeeID,@RoleID,@EntryBy
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @Count = @Count + 1
	end

	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spInsertRoleAssignment
@EmployeeID nvarchar(50),
@RoleID nvarchar(500),
@EntryBy nvarchar(50)
as
begin
	Declare @RoleAssignID nvarchar(50)
	Declare @CurrentRoleAssignID numeric(18,0)
	Declare @RoleAssignIDPrefix as nvarchar(3)

	set @RoleAssignIDPrefix='RA-'

begin tran

	select @CurrentRoleAssignID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentRoleAssignID'
	
	set @CurrentRoleAssignID=isnull(@CurrentRoleAssignID,0)+1
	Select @RoleAssignID=dbo.generateID(@RoleAssignIDPrefix,@CurrentRoleAssignID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblRoleAssignment(RoleAssignID,EmployeeID,RoleID,EntryBy)
	Values(@RoleAssignID,@EmployeeID,@RoleID,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentRoleAssignID where PropertyName='CurrentRoleAssignID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create function fnGetPermittedMenu(@EmployeeID as nvarchar(50))
returns nvarchar(MAX)
as
begin
	Declare @MenuList as nvarchar(MAX) Set @MenuList = ''

	Select @MenuList=@MenuList+R.MenuList from tblRoleAssignment RA INNER JOIN tblRole R ON RA.RoleID=R.RoleID
	Where EmployeeID=@EmployeeID

	return @MenuList;
end

--Select dbo.fnGetPermittedMenu('EMP-00000901')
--Select dbo.fnGetPermittedMenu('EMP-00001324')

select * from tblRoleAssignment;


