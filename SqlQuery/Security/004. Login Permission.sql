
-- exec spLogin 'Inventory','nirpen','standard'
alter proc spLogin
@AccessModule nvarchar(50),
@UserID nvarchar(50),
@UserPassword nvarchar(50)
as
begin
	
	Declare @EmployeeID as nvarchar(50) Set @EmployeeID = ''
	Declare @EmployeeName as nvarchar(50) Set @EmployeeName = ''
	Declare @PermittedMenu as nvarchar(MAx) Set @PermittedMenu = ''


	if exists(select * from tblEmployeeInfo Where UserID=@UserID And UserPassword=@UserPassword And IsActive=1)
	begin
		select @EmployeeID=EmployeeID,@EmployeeName=EmployeeName,@PermittedMenu=dbo.fnGetPermittedMenu(EmployeeID)
		from tblEmployeeInfo Where UserID=@UserID And UserPassword=@UserPassword And IsActive=1
	end

	select @EmployeeID as 'EmployeeID',@EmployeeName as 'EmployeeName',@PermittedMenu as 'PermittedMenu'
	
end

