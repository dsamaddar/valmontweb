

select * from tblEmployeeInfo Where CardNo IN ('10240')
--Evening
update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM')
--,IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM')
where EmployeeID IN ('EMP-00001583')
And LogTime between '09-14-2019' and '09-15-2019 08:30:59 AM';
