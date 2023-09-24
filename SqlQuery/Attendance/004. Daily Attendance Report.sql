
-- exec spReportDailyPresentList '02/27/2018'
GO

Create proc spReportDailyPresentList
@ReportDate date
as
begin
	Select E.EmployeeID,EmployeeName,CardNo,D.Designation,S.Section,U.LogTime
	from tblEmployeeInfo E INNER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	INNER JOIN tblSection S ON E.SectionID = S.SectionID
	INNER JOIN 
	(Select EmployeeID,MIN(LogTime) as 'LogTime' from tblUserAttendance 
	Where Convert(nvarchar,LogTime,101) = Convert(nvarchar,@ReportDate,101)
	group by EmployeeID) as U
	ON E.EmployeeID=U.EmployeeID
	Order by Section,Designation,CardNo,EmployeeName
end

GO

-- exec spReportDailyAbsentList '02/27/2018'

Create proc spReportDailyAbsentList
@ReportDate date
as
begin
	Select E.EmployeeID,EmployeeName,CardNo,D.Designation,S.Section
	from tblEmployeeInfo E INNER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	INNER JOIN tblSection S ON E.SectionID = S.SectionID
	Where E.IsActive=1 And dbo.fnGetAttStatus(E.EmployeeID,@ReportDate)='Absent'
end

GO

-- exec spReportDailyLateAttList '02/27/2018'

Create proc spReportDailyLateAttList
@ReportDate date
as
begin
	Select E.EmployeeID,EmployeeName,CardNo,D.Designation,S.Section,U.LogTime,U.IdealLogTime,
	DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime)/60 as 'HourLate',DATEDIFF(MINUTE,U.IdealLogTime,U.LogTime)%60 as 'MinuteLate'
	from tblEmployeeInfo E INNER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	INNER JOIN tblSection S ON E.SectionID = S.SectionID
	INNER JOIN 
	(Select EmployeeID,MIN(LogTime) as 'LogTime',MAX(IdealLogTime) as 'IdealLogTime' from tblUserAttendance 
	Where Convert(nvarchar,LogTime,101) = Convert(nvarchar,@ReportDate,101)
	group by EmployeeID) as U
	ON E.EmployeeID=U.EmployeeID
	Where U.LogTime > U.IdealLogTime
	Order by Section,Designation,CardNo,EmployeeName
end
