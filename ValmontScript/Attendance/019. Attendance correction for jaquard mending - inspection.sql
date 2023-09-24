select * from tblSection where Section like '%jac%'

select * from tblEmployeeInfo where EmpCode='12983';

select * from tblUserAttendance t where t.EmployeeID='EMP-00004051' and t.LogTime >= '5/1/2021';

select * from tblSection where SectionID in ('SEC-00000049','SEC-00000058','SEC-00000060');

update tblUserAttendance Set 
IdealLogTime = convert(datetime,convert(nvarchar,IdealLogTime,101) + ' 08:00:00 AM'),
IdealLogOutTime = convert(datetime,convert(nvarchar,IdealLogOutTime,101) + ' 05:00:00 PM')
where LogTime >= '5/14/2021' and LogTime < '6/01/2021' 
and EmployeeID IN (select EmployeeID from tblEmployeeInfo where 
SectionID in (
'SEC-00000001'
)
);



/*
update tblUserAttendance Set 
IdealLogTime = convert(datetime,convert(nvarchar,IdealLogTime,101) + ' 08:00:00 AM'),
IdealLogOutTime = convert(datetime,convert(nvarchar,IdealLogOutTime,101) + ' 05:00:00 PM')
where LogTime >= '5/1/2021' and LogTime < '5/13/2021' 
and EmployeeID IN (select EmployeeID from tblEmployeeInfo where SectionID in ('SEC-00000049','SEC-00000058'));
*/

update tblUserAttendance Set 
IdealLogTime = convert(datetime,convert(nvarchar,IdealLogTime,101) + ' 08:00:00 AM'),
IdealLogOutTime = convert(datetime,convert(nvarchar,IdealLogOutTime,101) + ' 05:00:00 PM')
where LogTime >= '4/1/2021' and LogTime < '5/1/2021' 
and EmployeeID IN (select EmployeeID from tblEmployeeInfo where SectionID in ('SEC-00000060'));



select convert(datetime,convert(nvarchar,IdealLogTime,101) + ' 08:00:00 AM'),IdealLogTime,
 convert(datetime,convert(nvarchar,IdealLogOutTime,101) + ' 05:00:00 PM'),
IdealLogOutTime
from tblUserAttendance where EmployeeID='EMP-00001405'
and LogTime >= '4/1/2021' and LogTime <= '4/30/2021';

/*
update tblUserAttendance Set 
IdealLogTime = convert(datetime,convert(nvarchar,IdealLogTime,101) + ' 08:00:00 AM')
where LogTime >= '4/1/2021' and LogTime < '5/1/2021' 
and EmployeeID IN ('EMP-00001325');
*/

