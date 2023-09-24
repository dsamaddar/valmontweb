
/*
Evening
02.02.19 - 07.02.19
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-02-2019' and '02-08-2019 08:59:59 AM'
and
AttendanceID in (
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379 );

/*
Morning
02.02.19 - 07.02.19
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229,
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-02-2019' and '02-07-2019 11:59:59 PM'
and
AttendanceID in (
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229);

/*
Always Morning
10225

*/

update tblUserAttendance Set ShiftID='SFT-00000001'
Where LogTime between '02-01-2019' and '02-07-2019 11:59:59 PM'
and
AttendanceID in (
10225);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
Where LogTime between '02-01-2019' and '02-20-2019 11:59:59 PM'
and
AttendanceID in (
10225);

/*
Morning
09.02.19 - 14.02.19
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-09-2019' and '02-14-2019 11:59:59 PM'
and
AttendanceID in (
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379);

/*
Evening
09.02.19 - 14.02.19
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-09-2019' and '02-15-2019 11:59:59 PM'
and
AttendanceID in (
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-09-2019' and '02-15-2019 11:59:59 PM'
and
AttendanceID in (11516);


/*
Evening
17.02.19 - 21.02.19
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-17-2019' and '02-21-2019 11:59:59 PM'
and
AttendanceID in (
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379);

/*
Morning
17.02.19 - 21.02.19
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-17-2019' and '02-21-2019 11:59:59 PM'
and
AttendanceID in (10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229);

/*
Morning
23.02.19 - 28.02.19
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-17-2019' and '02-21-2019 11:59:59 PM'
and
AttendanceID in (11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379);

/*
evening
23.02.19 - 28.02.19
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-23-2019' and '02-28-2019 11:59:59 PM'
and
AttendanceID in (
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-23-2019' and '02-28-2019 11:59:59 PM'
and
AttendanceID in (10229);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-23-2019' and '02-28-2019 11:59:59 PM'
and
AttendanceID in (11516);







/**************************************************Production Staff******************************************/
/*
Morning
02.02.19 - 07.02.19
4081,4074,4035
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-02-2019' and '02-07-2019 11:59:59 PM'
and
AttendanceID in (4081,4074,4035);

/*
Evening
09.02.19 - 14.02.19
4081,4074,4035
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-09-2019' and '02-14-2019 11:59:59 PM'
and
AttendanceID in (4081,4074,4035);

/*
Morning
16.02.19 - 21.02.19
4081,4074,4035
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-16-2019' and '02-21-2019 11:59:59 PM'
and
AttendanceID in (4081,4074,4035);

/*
Evening
23.02.19 - 28.02.19
4081,4074,4035
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-23-2019' and '02-28-2019 11:59:59 PM'
and
AttendanceID in (4081,4074,4035);

/*
Evening
02.02.19 - 07.02.19
4028,4058,4075,4019
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-02-2019' and '02-07-2019 11:59:59 PM'
and
AttendanceID in (4028,4058,4075,4019);

/*
Morning
09.02.19 - 14.02.19
4028,4058,4075,4019
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-09-2019' and '02-14-2019 11:59:59 PM'
and
AttendanceID in (4028,4058,4075,4019);

/*
Evening
16.02.19 - 21.02.19
4028,4058,4075,4019
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 AM'),
ShiftID='SFT-00000002'
Where LogTime between '02-16-2019' and '02-21-2019 11:59:59 PM'
and
AttendanceID in (4028,4058,4075,4019);

/*
Morning
23.02.19 - 28.02.19
4028,4058,4075,4019
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 08:40 PM'),
ShiftID='SFT-00000001'
Where LogTime between '02-23-2019' and '02-28-2019 11:59:59 PM'
and
AttendanceID in (4028,4058,4075,4019);



select * from tblUserAttendance where AttendanceID='4058' order by LogTime asc
select dbo.fnGetAttStatus('EMP-00001365','02-14-2019')

select * from tblEmployeeInfo Where EmpCode='10001'

update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
where EmployeeID IN (
select EmployeeID from tblEmployeeInfo Where SectionID NOT IN ('SEC-00000003','SEC-00000004','SEC-00000027','SEC-00000029','SEC-00000032',
'SEC-00000043','SEC-00000044','SEC-00000039','SEC-00000040','SEC-00000041','SEC-00000022','SEC-00000042')
)
And LogTime between '02-01-2019' and '03-07-2019 11:59:59 PM'
And AttendanceID IN (10206);


update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
where EmployeeID IN (select EmployeeID from tblEmployeeInfo Where SectionID IN ('SEC-00000001'))
And LogTime between '02-01-2019' and '02-28-2019 11:59:59 PM';

select * from tblUserAttendance Where AttendanceID='1006' order by LogTime desc

