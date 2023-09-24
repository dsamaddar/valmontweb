

Create table tblUploadedFiles(
UploadFileID nvarchar(50) primary key,
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
FileType nvarchar(50),
FileTitle nvarchar(200),
EntryBy nvarchar(50),
EntryDate datetime default getdate(),
);

GO


Create proc spInsertUploadedFiles
@EmployeeID nvarchar(50),
@FileType nvarchar(50),
@FileTitle nvarchar(200),
@EntryBy nvarchar(50)
as
begin
	Declare @UploadFileID nvarchar(50)
	Declare @CurrentUploadFileID numeric(18,0)
	Declare @UploadFileIDPrefix as nvarchar(6)

	set @UploadFileIDPrefix='UP-DOC-'

begin tran
	
	select @CurrentUploadFileID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentUploadFileID'
	
	set @CurrentUploadFileID=isnull(@CurrentUploadFileID,0)+1
	Select @UploadFileID=dbo.generateID(@UploadFileIDPrefix,@CurrentUploadFileID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblUploadedFiles(UploadFileID,EmployeeID,FileType,FileTitle,EntryBy) 
	Values(@UploadFileID,@EmployeeID,@FileType,@FileTitle,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentUploadFileID where PropertyName='CurrentUploadFileID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spGetUploadedFilesByEmp
@EmployeeID nvarchar(50)
as
begin
	Select FileType,FileTitle,EntryBy,Convert(nvarchar,EntryDate,106) as 'UploadedOn'
	from tblUploadedFiles Where EmployeeID=@EmployeeID
end

-- exec spGetUploadedFilesByEmp 'EMP-00000648'

Select * from tblUploadedFiles