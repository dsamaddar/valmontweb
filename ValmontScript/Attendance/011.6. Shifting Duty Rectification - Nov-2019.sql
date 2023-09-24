
select * from tblEmployeeInfo Where CardNo IN ('11906')
--Evening
update tblUserAttendance 
Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM')
,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM')
where EmployeeID IN ('EMP-00002984')
And LogTime between '10-19-2019' and '10-25-2019 08:30:59 AM';

-- Morning
update tblUserAttendance 
Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM')
where EmployeeID IN ('EMP-00002930')
And LogTime between '10-20-2019' and '10-24-2019 08:30:59 PM';
