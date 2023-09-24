

select dbo.fnGetComplianceOutTime('2020-03-03 17:00:00 PM');
select dbo.fnGetComplianceOutTime('2020-03-03 08:05:00 AM');
select dbo.fnGetComplianceOutTime('2020-03-03 20:05:00 PM');

select DATEPART(MILLISECOND,GETDATE())%15;

alter function fnGetComplianceOutTime(@LogTime datetime)
returns datetime
as
begin
	Declare @InterimDate date
	Declare @Hour int
	Declare @ComplianceOutTime datetime
	Declare @FinalOutTime datetime 
	Declare @CompLogoutJacquardEvening nvarchar(15);
	Declare @CompLogoutJacquardMorning nvarchar(15);
	Declare @RandomMinute as int Set @RandomMinute = DATEPART(MILLISECOND,GETDATE())%8;

	select @CompLogoutJacquardEvening=PropertyValue from tblAppSettings where PropertyName='CompLogoutJacquardEvening';
	select @CompLogoutJacquardMorning=PropertyValue from tblAppSettings where PropertyName='CompLogoutJacquardMorning';

	Set @InterimDate = convert(date,@LogTime)
	Set @Hour = DATEPART(HOUR,@LogTime)

	if @Hour > 12
	begin
		Set @ComplianceOutTime = convert(datetime,convert(nvarchar,@InterimDate) + ' ' + @CompLogoutJacquardEvening)

		if @ComplianceOutTime < @LogTime
			Set @FinalOutTime = DATEADD(MINUTE,@RandomMinute,@ComplianceOutTime)
		else
			Set @FinalOutTime = @LogTime;
	end
	else
	begin
		Set @ComplianceOutTime = convert(datetime,convert(nvarchar,@InterimDate) + ' ' + @CompLogoutJacquardMorning)

		if @ComplianceOutTime < @LogTime
			Set @FinalOutTime = DATEADD(MINUTE,@RandomMinute,@ComplianceOutTime)
		else
			Set @FinalOutTime = @LogTime;
	end

	return  @FinalOutTime;
end
