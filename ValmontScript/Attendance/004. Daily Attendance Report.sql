
-- exec spReportDailyPresentList '12/07/2018'
GO

alter proc spReportDailyPresentList
@ReportDate date
as
begin
	Select E.EmployeeID,EmployeeName,CardNo,ISNULL(E.MachineNo,'N\A') as 'OldCardNo',ISNULL(D.Designation,'N\A') as 'Designation',
	ISNULL(S.Section,'N\A') as 'Section',ISNULL(B.Block,'N\A') as 'Block',U.LogTime
	from tblEmployeeInfo E 
	LEFT OUTER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	LEFT OUTER JOIN tblSection S ON E.SectionID = S.SectionID
	LEFT OUTER JOIN tblBlocks B ON E.BlockID = B.BlockID
	INNER JOIN 
	(Select EmployeeID,MIN(LogTime) as 'LogTime' from tblUserAttendance 
	Where Convert(nvarchar,LogTime,101) = Convert(nvarchar,@ReportDate,101)
	group by EmployeeID) as U
	ON E.EmployeeID=U.EmployeeID
	Order by Section,Block,Designation,CardNo,EmployeeName
end

GO

-- exec spReportDailyAbsentList '02/10/2019'

alter proc spReportDailyAbsentList
@ReportDate date
as
begin
	Select E.EmployeeID,EmployeeName,CardNo,ISNULL(E.MachineNo,'N\A') as 'OldCardNo',ISNULL(D.Designation,'N\A') as 'Designation',
	ISNULL(S.Section,'N\A') as 'Section',ISNULL(B.Block,'N\A') as 'Block'
	from tblEmployeeInfo E 
	LEFT OUTER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	LEFT OUTER JOIN tblSection S ON E.SectionID = S.SectionID
	LEFT OUTER JOIN tblBlocks B ON E.BlockID = B.BlockID
	Where E.IsActive=1 And dbo.fnGetAttStatus(E.EmployeeID,@ReportDate)='Absent'
	order by Section,Block,CardNo
end

GO

-- exec spReportDailyLateAttList '12/05/2018'

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

GO

alter proc spReportDailyErrorAttList
@ReportDate date
as
begin
	Declare @LowerLimit as datetime Set @LowerLimit = Convert(datetime,convert(nvarchar,@ReportDate,101) + ' 7:00:00.000')

	Select E.EmployeeID,EmployeeName,CardNo,ISNULL(MachineNo,'N\A') MachineNo,D.Designation,S.Section,B.Block,U.LogTime,U.IdealLogOutTime,
	DATEDIFF(MINUTE,U.LogTime,U.IdealLogOutTime)/60 as 'HourLag',DATEDIFF(MINUTE,U.LogTime,U.IdealLogOutTime)%60 as 'MinuteLag'
	from tblEmployeeInfo E INNER JOIN tblDesignation D ON E.DesignationID = D.DesignationID
	INNER JOIN tblSection S ON E.SectionID = S.SectionID
	LEFT OUTER JOIN tblBlocks B ON E.BlockID = B.BlockID
	INNER JOIN 
	(Select EmployeeID,MAX(LogTime) as 'LogTime',MAX(IdealLogOutTime) as 'IdealLogOutTime' from tblUserAttendance 
	Where Convert(nvarchar,LogTime,101) = Convert(nvarchar,@ReportDate,101)
	group by EmployeeID) as U
	ON E.EmployeeID=U.EmployeeID
	Where U.LogTime < U.IdealLogOutTime
	And U.LogTime >= @LowerLimit
	And DATEDIFF(MINUTE,U.LogTime,U.IdealLogOutTime)/60 > 2
	Order by Section,Block,Designation,CardNo,EmployeeName
end

-- exec spReportDailyErrorAttList '02/24/2019'

Select EmployeeID,MAX(LogTime) as 'LogTime',MAX(IdealLogOutTime) as 'IdealLogOutTime' from tblUserAttendance 
	Where Convert(nvarchar,LogTime,101) = Convert(nvarchar,'11/06/2018',101)
	group by EmployeeID


select 'A'+'B' 

select convert(nvarchar,getdate(),101)