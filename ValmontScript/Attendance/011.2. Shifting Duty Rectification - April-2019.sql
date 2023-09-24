/*
11825,11824,11814,
11639,11615,10240,
*/

/* Evening Schedule********************************/
/*
evening
01.04.19-04.04.19
11585,11619,11638,11704,11759,11762,10229,10253,11566,11568,11569,11516
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-01-2019' and '04-05-2019 08:59:59 AM'
and AttendanceID in (11516);

/*
evening
06.04.19-11.04.19
11012
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-06-2019' and '04-12-2019 08:59:59 AM'
and AttendanceID in (11012);

/*
evening
20.04.19-25.04.19
11824,11825,11615,10237
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-20-2019' and '04-26-2019 08:59:59 AM'
and AttendanceID in (10237);

/*
evening
06.04.19-12.04.19
10240
*/

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-06-2019' and '04-12-2019 08:59:59 AM'
and AttendanceID in (10240);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-20-2019' and '04-26-2019 08:59:59 AM'
and AttendanceID in (11012);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '04-27-2019' and '05-01-2019 08:59:59 AM'
and AttendanceID in (11838);

/*Morning Schedule********************************/

/*
Morning
01.04.19 - 07.04.19
11639,11012
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '04-01-2019' and '04-04-2019 11:59:59 PM'
and AttendanceID in (11012);

Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '04-13-2019' and '04-19-2019 11:59:59 PM'
and AttendanceID in (11012);

/*
Morning
27.04.19 - 30.04.19
11814
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '04-27-2019' and '04-30-2019 11:59:59 PM'
and AttendanceID in (11814);

/*All rectification*/

GO
update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
where EmployeeID IN (
select EmployeeID from tblEmployeeInfo Where SectionID NOT IN ('SEC-00000003','SEC-00000004','SEC-00000027','SEC-00000029','SEC-00000032',
'SEC-00000043','SEC-00000044','SEC-00000039','SEC-00000040','SEC-00000041','SEC-00000022','SEC-00000042')
)
And LogTime between '04-01-2019' and '04-30-2019 11:59:59 PM'
