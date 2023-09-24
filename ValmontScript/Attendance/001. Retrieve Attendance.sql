alter view vwEmpInfo
as
select E.EmployeeID,E.CardNo,E.IsActive,E.EmployeeName,S.SectionID,S.Section,D.DesignationID,D.Designation,
'' as 'ULCBranchID',E.InCludedInPayroll 
from tblEmployeeInfo E left outer JOIN tblSection S ON E.SectionID = S.SectionID
left outer join tblDesignation D ON E.DesignationID = D.DesignationID

GO

declare @date as datetime set @date = GETDATE();
exec spInsertUserAttendance '13399',97772157,'3/21/2022 1:48:25 PM',1,1,@date

alter proc spInsertUserAttendance
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
	Declare @ShiftID as nvarchar(50)

	Declare @DepartmentID as nvarchar(50)
	Declare @DesignationID as nvarchar(50)
	Declare @ULCBranchID as nvarchar(50)
	Declare @UserAttendanceID nvarchar(50)
	Declare @CurrentUserAttendanceID numeric(18,0)
	Declare @UserAttendanceIDPrefix as nvarchar(8)
	Declare @IdealLogTimeText as nvarchar(50)=''
	Declare @IdealLogOutTimeText as nvarchar(50)=''

	Declare @CheckInLogTime as nvarchar(50) Set @CheckInLogTime = CONVERT(VARCHAR(10), @LogTime, 101)+ ' ' + '00:01:00 AM';
	Declare @CheckOutLogTime as nvarchar(50) Set @CheckOutLogTime = CONVERT(VARCHAR(10), @LogTime, 101)+ ' ' + '06:30:00 AM'

	Declare @PrevDayLogTime as nvarchar(50) Set @PrevDayLogTime = CONVERT(VARCHAR(10), DATEADD(DAY,-1,@LogTime), 101)+ ' ' + '11:59:59 PM';
	Declare @NextDayLogTime as nvarchar(50) Set @NextDayLogTime = CONVERT(VARCHAR(10), @LogTime, 101)+ ' ' + '00:01:00 AM';

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

		Declare @IsSpecial as bit Set @IsSpecial = 0;
		Declare @SpecialLogOutTime as nvarchar(50) Set @SpecialLogOutTime = '';

		Select @EmployeeID=EmployeeID,@UserID = UserID,@DepartmentID=E.SectionID,@DesignationID=DesignationID,@ULCBranchID=NULL,
		@IdealLogTimeText= ISNULL(SH.ShiftLogStarts,S.IdealLoginTime),
		@IdealLogOutTimeText= ISNULL(SH.ShiftLogEnds,S.IdealLogout),
		@IsSpecial=ISNULL(S.IsSpecial,0),
		@SpecialLogOutTime = ISNULL(SH.ShiftLogEnds,''),
		@ShiftID=S.ShiftID
		from tblEmployeeInfo E INNER JOIN tblSection S ON E.SectionID = S.SectionID
		LEFT OUTER JOIN tblShifts SH ON S.ShiftID=SH.ShiftID
		Where CardNo=@AttendanceID

		If @IdealLogTimeText = ''
		begin
			Set @FinalIdealLoginTime = @IdealLoginTime
			Set @FinalIdealLogOutTime = @IdealLogOutTime
		end
		else
		begin
			Set @FinalIdealLoginTime = convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @IdealLogTimeText)
			Set @FinalIdealLogOutTime =  convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @IdealLogOutTimeText)
		end
		/*
		--Closed on 16th mar 2022
		If @LogTime between Convert(datetime,@CheckInLogTime) and Convert(datetime,@CheckOutLogTime) and @IsSpecial = 1
		begin
			-- Previous Day Log Time
			Insert into tblUserAttendance (UserAttendanceID,EmployeeID,UserID,DepartmentID,DesignationID,ULCBranchID,AttendanceID,LogIndex,LogTime,IdealLogTime,IdealLogOutTime,NodeID,AuthType,WorkStation,AttSystem,Remarks,ShiftID,EntryDate)
			Values(@UserAttendanceID,@EmployeeID,@UserID,@DepartmentID,@DesignationID,@ULCBranchID,@AttendanceID,@LogIndex,@PrevDayLogTime,@PrevDayLogTime,@PrevDayLogTime,@NodeID,@AuthType,'','Auto','',@ShiftID,@SLogTime)
			IF (@@ERROR <> 0) GOTO ERR_HANDLER

			set @CurrentUserAttendanceID=isnull(@CurrentUserAttendanceID,0)+1
			Select @UserAttendanceID=dbo.generateID(@UserAttendanceIDPrefix,@CurrentUserAttendanceID,8)		
			IF (@@ERROR <> 0) GOTO ERR_HANDLER
			
			-- Current Day Log Time
			If @IsSpecial = 1 
			begin
				Set @FinalIdealLogOutTime =  convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @SpecialLogOutTime)
			end

			Insert into tblUserAttendance (UserAttendanceID,EmployeeID,UserID,DepartmentID,DesignationID,ULCBranchID,AttendanceID,LogIndex,LogTime,IdealLogTime,IdealLogOutTime,NodeID,AuthType,WorkStation,AttSystem,Remarks,ShiftID,EntryDate)
			Values(@UserAttendanceID,@EmployeeID,@UserID,@DepartmentID,@DesignationID,@ULCBranchID,@AttendanceID,@LogIndex,@NextDayLogTime,@NextDayLogTime,@FinalIdealLogOutTime,@NodeID,@AuthType,'','Auto','',@ShiftID,@SLogTime)
			IF (@@ERROR <> 0) GOTO ERR_HANDLER

			set @CurrentUserAttendanceID=isnull(@CurrentUserAttendanceID,0)+1
			Select @UserAttendanceID=dbo.generateID(@UserAttendanceIDPrefix,@CurrentUserAttendanceID,8)		
			IF (@@ERROR <> 0) GOTO ERR_HANDLER
		end
		*/
		If @IsSpecial = 1 
		begin
			Set @FinalIdealLogOutTime =  convert(datetime,Convert(nvarchar,@LogTime,101) +' ' + @SpecialLogOutTime)

			Insert into tblUserAttendance (UserAttendanceID,EmployeeID,UserID,DepartmentID,DesignationID,ULCBranchID,AttendanceID,LogIndex,LogTime,IdealLogTime,IdealLogOutTime,NodeID,AuthType,WorkStation,AttSystem,Remarks,ShiftID,EntryDate)
			Values(@UserAttendanceID,@EmployeeID,@UserID,@DepartmentID,@DesignationID,@ULCBranchID,@AttendanceID,@LogIndex,@LogTime,@FinalIdealLoginTime,@FinalIdealLogOutTime,@NodeID,@AuthType,'','Thumb-Detection','',@ShiftID,@SLogTime)
			IF (@@ERROR <> 0) GOTO ERR_HANDLER
		end
			
		If @IsSpecial = 0
		begin
			Insert into tblUserAttendance (UserAttendanceID,EmployeeID,UserID,DepartmentID,DesignationID,ULCBranchID,AttendanceID,LogIndex,LogTime,IdealLogTime,IdealLogOutTime,NodeID,AuthType,WorkStation,AttSystem,Remarks,ShiftID,EntryDate)
			Values(@UserAttendanceID,@EmployeeID,@UserID,@DepartmentID,@DesignationID,@ULCBranchID,@AttendanceID,@LogIndex,@LogTime,@FinalIdealLoginTime,@FinalIdealLogOutTime,@NodeID,@AuthType,'','Thumb-Detection','',@ShiftID,@SLogTime)
			IF (@@ERROR <> 0) GOTO ERR_HANDLER
		end
		
		update tblAppSettings set PropertyValue=@CurrentUserAttendanceID where PropertyName='CurrentUserAttendanceID'
		IF (@@ERROR <> 0) GOTO ERR_HANDLER

		Select @IdealLoginTime
		set @IsSpecial = 0;
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

exec spUsrAttLogIndex;

 select isnull( max(LogIndex),0) from tblUserAttendance Where AttSystem='Thumb-Detection'
	

GO

/*Clearing Unnecessary Att Data*/

create proc spClearUnnecessaryAtt
@EmployeeID nvarchar(50)
as
begin
	
	declare @att_tbl as table(
	UserAttendanceID nvarchar(50),
	LogTime datetime,
	Taken bit default 0
	);

	Insert into @att_tbl(UserAttendanceID,LogTime)
	select UserAttendanceID,LogTime from tblUserAttendance where EmployeeID = @EmployeeID




end
