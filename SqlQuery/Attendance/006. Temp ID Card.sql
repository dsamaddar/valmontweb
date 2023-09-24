


select * from vwEmpInfo

select Section,Count(*) from vwEmpInfo Where IsActive=1 
group by Section 

alter proc spRptTempEmpIDCard
as
begin
select EmployeeName,CardNo,Designation,Section from vwEmpInfo Where IsActive=1
and Section IN ('OFFICE STAFF'
)
and CardNo Is Not NULL
order by Len(CardNo),CardNo
end

exec spRptTempEmpIDCard

