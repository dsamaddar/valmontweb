

update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
where EmployeeID IN (
select EmployeeID from tblEmployeeInfo Where SectionID IN (
'SEC-00000001')
)
And LogTime between '05-01-2019' and '05-07-2019 11:59:59 PM'
--------------------------------------------------------------------

update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM')
where EmployeeID IN (
select EmployeeID from tblEmployeeInfo Where SectionID IN ('SEC-00000042')
)
And ShiftID='SFT-00000002'
And LogTime between '05-01-2019' and '05-05-2019 11:59:59 PM'

-----------------------------------------------------

select * from tblEmployeeInfo Where CardNo IN ('11658')
--Evening
update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM')
--,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM')
where EmployeeID IN ('EMP-00002658')
And LogTime between '06-15-2019' and '06-19-2019 08:59:59 PM';

select * from tblEmployeeInfo Where CardNo IN ('11638')
--Morning
update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
--,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM')
where EmployeeID IN ('EMP-00002632')
And LogTime between '06-29-2019' and '06-29-2019 08:59:59 PM'
