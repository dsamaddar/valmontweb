/* Evening Schedule********************************/
/*
evening
02.03.19 - 07.03.19
10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11566,11568,
11569,11611,11612,11615,11616
*/


Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-02-2019' and '03-08-2019 08:59:59 AM'
and AttendanceID in (10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11566,11568,
11569,11611,11612,11615,11616);

GO
/*
evening
09.03.19 -14.03.19
10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,
11572,11639,11653,11656,11657,11658,11666
*/
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-09-2019' and '03-15-2019 08:59:59 AM'
and AttendanceID in (10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,
11572,11639,11653,11656,11657,11658,11666);

/*
evening
16.03.19 -21.03.19
10227,10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11566,11568,11569,
11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11663,11704,11714
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-16-2019' and '03-22-2019 08:59:59 AM'
and AttendanceID in (10227,10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11566,11568,11569,
11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11663,11704,11714);

/*
23.03.19 -28.03.19
10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,11572,
11639,11653,11656,11657,11658,11664,11666,11694,11690,11701,11724,11604
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-23-2019' and '03-29-2019 08:59:59 AM'
and
AttendanceID in (10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,11572,
11639,11653,11656,11657,11658,11664,11666,11694,11690,11701,11724,11604);

/*
evening
30.03.19 -04.04.19
11336,11044,11004,11126,10991,10921,10228,10980,11049,11284,10247,10230,10947,10244,11012,10843,11434,11379,11615,11616,11619,11638,11649,
11663,11704,11714,11611,11612,11566,11569,11568
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-30-2019' and '04-01-2019 08:59:59 AM'
and
AttendanceID in (11568);


/*Evening
02.03.19 - 07.03.19
4019,4028,4058,4075
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-02-2019' and '03-07-2019 08:59:59 AM'
and
AttendanceID in (4019,4028,4058,4075);

/*
evening
09.03.19 -14.03.19
4019,4028,4058,4075
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-09-2019' and '03-14-2019 08:59:59 AM'
and
AttendanceID in (4019,4028,4058,4075);

/*
evening
16.03.19 -21.03.19
4019,4035,4074,4081,4088,4089
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-16-2019' and '03-21-2019 08:59:59 AM'
and
AttendanceID in (4019,4035,4074,4081,4088,4089);

/*
evening
23.03.19 -28.03.19
4019,4028,4058,4075
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-23-2019' and '03-28-2019 08:59:59 AM'
and
AttendanceID in (4019,4028,4058,4075);

/*
evening
30.03.19 -04.04.19
4081,4074,4035,4019
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 PM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 AM'),
ShiftID='SFT-00000002'
Where LogTime between '03-30-2019' and '03-31-2019 08:59:59 AM'
and
AttendanceID in (4081,4074,4035,4019);


/*Morning Schedule********************************/
/*
Morning
02.03.19 - 07.03.19
10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,11639
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-02-2019' and '03-07-2019 11:59:59 PM'
and AttendanceID in 
(10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,11572,11639);

/*
Morning
09.03.19 -14.03.19
10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11568,
11569,11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11704,10227
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-09-2019' and '03-14-2019 8:59:59 PM'
and AttendanceID in 
(10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11568,
11569,11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11704,10227);

/*
Morning
16.03.19 -21.03.19
10226,10227,10229,10231,10232,10233,10237,10238,10240,10249,10253,10803,10826,10930,11035,11133,11153,11464,11516,
11572,11639,11653,11656,11657,11658,11664,11666,11694,11690,11724
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-16-2019' and '03-21-2019 11:59:59 PM'
and AttendanceID in 
(10227);

/*
Morning
23.03.19 -28.03.19
10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11568,11569,
11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11663,11704,11714
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-23-2019' and '03-28-2019 11:59:59 PM'
and AttendanceID in 
(10228,10230,10244,10247,10843,10921,10947,10980,10991,11004,11012,11044,11049,11126,11284,11336,11379,11434,11568,11569,
11585,11604,11605,11611,11612,11615,11616,11619,11638,11649,11663,11704,11714);

/*
Morning
30.03.19 -04.04.19
10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229,11516,11639,11653,
11656,11657,11658,11664,11666,11694,11690,11701,11724
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-30-2019' and '03-31-2019 11:59:59 PM'
and AttendanceID in 
(10253,10237,11133,10930,10233,10826,10231,10232,11464,10227,11035,10238,10226,10240,10803,11153,10249,10229,11516,11639,11653,
11656,11657,11658,11664,11666,11694,11690,11701,11724);

/*
Morning
02.03.19 - 07.03.19
4019,4035,4074,4081,4089
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-02-2019' and '03-07-2019 11:59:59 PM'
and AttendanceID in (4019,4035,4074,4081,4089);

/*
Morning
09.03.19 -14.03.19
4019,4035,4074,4081,4088,4089
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-09-2019' and '03-14-2019 11:59:59 PM'
and AttendanceID in (4019,4035,4074,4081,4088,4089);

/*
Morning
16.03.19 -21.03.19
4019,4028,4058,4075
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-16-2019' and '03-21-2019 11:59:59 PM'
and AttendanceID in (4019,4028,4058,4075);

/*
Morning
23.03.19 -28.03.19
4019,4035,4074,4081,4088,4089
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-23-2019' and '03-28-2019 11:59:59 PM'
and AttendanceID in (4019,4035,4074,4081,4088,4089);

/*
Morning
30.03.19 -04.04.19
4028,4058,4075,4019
*/
GO
Update tblUserAttendance set IdealLogTime=Convert(datetime,CONVERT(nvarchar,IdealLogTime,101)+' 08:00 AM'),
IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM'),
ShiftID='SFT-00000001'
Where LogTime between '03-30-2019' and '03-31-2019 11:59:59 PM'
and AttendanceID in (4028,4058,4075,4019);

/*All rectification*/

GO
update tblUserAttendance Set IdealLogOutTime=Convert(datetime,CONVERT(nvarchar,IdealLogOutTime,101)+' 05:00 PM')
where EmployeeID IN (
select EmployeeID from tblEmployeeInfo Where SectionID NOT IN ('SEC-00000003','SEC-00000004','SEC-00000027','SEC-00000029','SEC-00000032',
'SEC-00000043','SEC-00000044','SEC-00000039','SEC-00000040','SEC-00000041','SEC-00000022','SEC-00000042')
)
And LogTime between '03-01-2019' and '03-31-2019 11:59:59 PM'
