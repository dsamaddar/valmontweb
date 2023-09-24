
Insert into tblAppSettings(PropertyName,PropertyValue)Values('CurrentNoWorkDayID',0)

GO

Create table tblNoWorkDay(
NoWorkDayID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
NoWorkDay date,
EntryDate datetime
);

GO

Create proc spGetNoWorkDayByEmpID
@EmployeeID nvarchar(50)
as
begin
	Select NW.NoWorkDayID,EI.EmployeeName,EI.EmpCode,NW.NoWorkDay
	from tblEmployeeInfo EI INNER JOIN tblNoWorkDay NW ON EI.EmployeeID = NW.EmployeeID
	Where NW.EmployeeID = @EmployeeID
	order by NW.NoWorkDay
end

--exec spGetNoWorkDayByEmpID 'EMP-00002486'

GO


Create proc spInsertNoWorkDays
@EmployeeID nvarchar(50),
@NoWorkDayStartDate date,
@NoWorkDayEndDate date
as
begin

	Declare @InterimDate as date
	Set @InterimDate = @NoWorkDayStartDate

begin tran
	While @InterimDate <= @NoWorkDayEndDate
	begin
		exec spInsertNoWorkDay @EmployeeID,@InterimDate
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Set @InterimDate = DATEADD(DAY,1,@InterimDate)
	end
COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spInsertNoWorkDay
@EmployeeID nvarchar(50),
@NoWorkDay date
as
begin
	Declare @NoWorkDayID nvarchar(50)
	Declare @CurrentNoWorkDayID numeric(18,0)
	Declare @NoWorkDayIDPrefix as nvarchar(4)

	set @NoWorkDayIDPrefix='NWD-'

begin tran
	
	select @CurrentNoWorkDayID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentNoWorkDayID'
	
	if not exists(
	select * from tblNoWorkDay Where NoWorkDay=@NoWorkDay and EmployeeID = @EmployeeID
	)
	begin
		set @CurrentNoWorkDayID=isnull(@CurrentNoWorkDayID,0)+1
		Select @NoWorkDayID=dbo.generateID(@NoWorkDayIDPrefix,@CurrentNoWorkDayID,8)		
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Insert into tblNoWorkDay(NoWorkDayID,EmployeeID,NoWorkDay,EntryDate) 
		Values(@NoWorkDayID,@EmployeeID,@NoWorkDay,GETDATE())

		update tblAppSettings set PropertyValue=@CurrentNoWorkDayID where PropertyName='CurrentNoWorkDayID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spDeleteNoWorkDay
@NoWorkDayID nvarchar(50)
as
begin
	delete from tblNoWorkDay Where NoWorkDayID=@NoWorkDayID
end

select * from tblNoWorkDay