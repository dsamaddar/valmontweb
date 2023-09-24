alter view vwEmpInfo
as
select E.EmployeeID,E.CardNo,E.IsActive,E.EmployeeName,S.SectionID,S.Section,D.DesignationID,D.Designation,
'' as 'ULCBranchID',E.InCludedInPayroll 
from tblEmployeeInfo E left outer JOIN tblSection S ON E.SectionID = S.SectionID
left outer join tblDesignation D ON E.DesignationID = D.DesignationID

GO
GO

Create proc spInsertUserAttendance
@AttendanceID nvarchar(50),
@LogIndex numeric(18,0),
@LogTime datetime,
@NodeID int,
@AuthType int,
@SLogTime datetime
as
begin

	Declare @EmployeeID as nvarchar(50)
	Declare @UserID as nvarchar(50)
	Declare @IdeaTime as nvarchar(50)
	Declare @LogOutTime as nvarchar(50)
	Declare @IdealLoginTime as nvarchar(50)
	Declare @FinalIdealLoginTime as datetime
	Declare @IdealLogOutTime as nvarchar(50)
	Declare @FinalIdealLogOutTime as datetime

	Declare @DepartmentID as nvarchar(50)
	Declare @DesignationID as nvarchar(50)
	Declare @ULCBranchID as nvarchar(50)
	Declare @UserAttendanceID nvarchar(50)
	Declare @CurrentUserAttendanceID numeric(18,0)
	Declare @UserAttendanceIDPrefix as nvarchar(8)
	Declare @IdealLogTimeText as nvarchar(50)=''

	set @UserAttendanceIDPrefix='USR-ATT-'

begin tran
	
	if exists(
	Select * from tblEmployeeInfo Where CardNo=@AttendanceID
	)
	begin
		select @CurrentUserAttendanceID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentUserAttendanceID'
	
		set @CurrentUserAttendanceID=isnull(@CurrentUserAttendanceID,0)+1
		Select @UserAttendanceID=dbo.generateID(@UserAttendanceIDPrefix,@CurrentUserAttendanceID,8)		
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Select @IdeaTime = PropertyValue from tblAppSettings where  PropertyName='IdealLoginTime'
		Select @LogOutTime = PropertyValue from tblAppSettings where  PropertyName='IdealLogoutTime'

		Set @IdealLoginTime =CONVERT(VARCHAR(10), @LogTime, 101)+ ' ' + @IdeaTime
		Set @IdealLogOutTime =CONVERT(VARCHAR(10), @LogTime, 101)+ ' ' + @LogOutTime

		Select @EmployeeID=EmployeeID,@UserID = UserID,@DepartmentID=SectionID,@DesignationID=DesignationID,@ULCBranchID=NULL,
		@IdealLogTimeText= ISNULL(IdealLoginTime,'')
		from tblEmployeeInfo Where CardNo=@AttendanceID

		If @IdealLogTimeText = ''
		begin
			Set @FinalIdealLoginTime = @IdealLoginTime
			Set @FinalIdealLogOutTime = @IdealLogOutTime
		end
		else
		begin
			Set @FinalIdealLoginTime = convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @IdealLogTimeText)
			Set @FinalIdealLogOutTime =  convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @IdealLogTimeText)
		end

		Insert into tblUserAttendance (UserAttendanceID,EmployeeID,UserID,DepartmentID,DesignationID,ULCBranchID,AttendanceID,LogIndex,LogTime,IdealLogTime,IdealLogOutTime,NodeID,AuthType,WorkStation,AttSystem,Remarks,EntryDate)
		Values(@UserAttendanceID,@EmployeeID,@UserID,@DepartmentID,@DesignationID,@ULCBranchID,@AttendanceID,@LogIndex,@LogTime,@FinalIdealLoginTime,@FinalIdealLogOutTime,@NodeID,@AuthType,'','Thumb-Detection','',@SLogTime)
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		update tblAppSettings set PropertyValue=@CurrentUserAttendanceID where PropertyName='CurrentUserAttendanceID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Select @IdealLoginTime
	end

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUsrAttLogIndex
as
begin
	Declare @AttendanceIDList as varchar(MAX) Set @AttendanceIDList = ''
	Declare @MaxLogIndex as numeric(18,0) Set @MaxLogIndex = 0
	
	Select @MaxLogIndex = isnull( max(LogIndex),0) from tblUserAttendance Where AttSystem='Thumb-Detection'
	
	Select  @AttendanceIDList=  @AttendanceIDList + '''' +CardNo +''',' from tblEmployeeInfo Where CardNo is not null 
	Set @AttendanceIDList = SUBSTRING(@AttendanceIDList,0,len(@AttendanceIDList))

	Select @MaxLogIndex as 'MaxLogIndex',@AttendanceIDList as 'AttendanceIDList'
end