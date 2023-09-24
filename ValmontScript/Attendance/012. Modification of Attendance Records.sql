


alter proc spGetAttRecordByEmpID
@EmployeeID nvarchar(50)
as
begin
	Select UserAttendanceID,LogTime,IdealLogTime,IdealLogOutTime,AttSystem,AuthStatus,EntryDate
	from tblUserAttendance Where EmployeeID=@EmployeeID 
	And (YEAR(LogTime)=YEAR(CURRENT_TIMESTAMP) or YEAR(LogTime)=YEAR(CURRENT_TIMESTAMP)-1)
	--And MONTH(LogTime)=MONTH(CURRENT_TIMESTAMP)
	order by LogTime desc
end

-- exec spGetAttRecordByEmpID ''

GO

Create proc spDeleteAttRecord
@UserAttendanceID nvarchar(50)
as
begin
	Update tblUserAttendance Set AuthStatus='D' Where UserAttendanceID=@UserAttendanceID
end

GO

Create proc spActivateAttRecord
@UserAttendanceID nvarchar(50)
as
begin
	Update tblUserAttendance Set AuthStatus='A' Where UserAttendanceID=@UserAttendanceID
end