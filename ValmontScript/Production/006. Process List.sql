
-- drop table tblProcess
Create table tblProcess(
ProcessID nvarchar(50) primary key,
Process nvarchar(50) unique(Process),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO


Create proc spInsertProcess
@Process nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @ProcessID nvarchar(50)
	Declare @CurrentProcessID numeric(18,0)
	Declare @ProcessIDPrefix as nvarchar(4)

	set @ProcessIDPrefix='PRC-'

begin tran
	
	select @CurrentProcessID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentProcessID'
	
	set @CurrentProcessID=isnull(@CurrentProcessID,0)+1
	Select @ProcessID=dbo.generateID(@ProcessIDPrefix,@CurrentProcessID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblProcess(ProcessID,Process,IsActive,EntryBy) Values(@ProcessID,@Process,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentProcessID where PropertyName='CurrentProcessID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO
/*
exec  spInsertProcess 'BODY',1,'dsamaddar'
exec  spInsertProcess 'NECK',1,'dsamaddar'
exec  spInsertProcess 'PIPING',1,'dsamaddar'
exec  spInsertProcess 'F/P',1,'dsamaddar'
exec  spInsertProcess 'B/P',1,'dsamaddar'
exec  spInsertProcess 'SLEEVE',1,'dsamaddar'
*/

GO

alter proc spGetProcessList
as
begin
	Select ProcessID,Process from tblProcess Where IsActive=1 order by Process
end

-- exec spGetProcessList

GO

Create proc spGetProcessListDetails
as
begin
	Select ProcessID,Process,CASE IsActive When 1 Then 'Y' ELSE 'N' END as 'Active',
	EntryBy,EntryDate from tblProcess Where IsActive=1 order by Process
end

-- exec spGetProcessListDetails