
-- searching for absent
select x.EmployeeID,x.EmpCode,y.EmployeeID from tblEmployeeInfo x left outer join (
select distinct EmployeeID from tblUserAttendance 
where LogTime between '02/19/2021' and '02/20/2021' and AuthStatus <> 'D'
) y on x.EmployeeID = y.EmployeeID
where x.IsActive=1 and y.EmployeeID is null

-- searching for on leave
select d.*,e.EmpCode from tblLeaveDetails d inner join tblEmployeeInfo e 
on d.EmployeeID=e.EmployeeID where LeaveDate = '02/19/2021';