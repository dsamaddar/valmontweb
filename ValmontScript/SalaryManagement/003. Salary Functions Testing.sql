		
		-- select * from tblGeneratedSalary;
		-- 
		
		Declare @EmployeeID as nvarchar(50) Set @EmployeeID ='EMP-00001437'
		Declare @StartDate as date Set @StartDate = '4/1/2021';
		Declare @EndDate as date Set @EndDate = '4/30/2021';
		Declare @InterimDate as date Set @InterimDate = @StartDate;
		Declare @Count as int Set @Count = 1
		Declare @NCount as int Set @NCount = 0
		Declare @AttDay as varchar(10) Set @AttDay = ''
		Declare @AttStatus as varchar(20) Set @AttStatus = ''
		Declare @OTHours as int Set @OTHours = 0
		Declare @ComplianceInTime as datetime
		Declare @ComplianceInTimeText as nvarchar(50) Set @ComplianceInTimeText = ''
		Declare @ComplianceOutTime as datetime
		Declare @SectionIDCom as nvarchar(50) Set @SectionIDCom = ''
		Declare @total_ot_hrs as numeric(5,2) Set @total_ot_hrs = 0;

		Declare @InTime as datetime
		Declare @OutTime as datetime
		
		select @ComplianceInTimeText = PropertyValue  from tblAppSettings Where PropertyName='IdealLoginTime';

		Select @SectionIDCom=SectionID from tblEmployeeInfo where EmployeeID = @EmployeeID


		While @InterimDate <= @EndDate
		begin
			Set @AttDay = DATENAME(WEEKDAY,@InterimDate)
			If @AttDay <> 'Friday'
			begin

			Set @AttStatus = dbo.fnGetAttStatus(@EmployeeID,@InterimDate)
			print 'ATS- ' + @AttStatus
			select @ComplianceOutTime = DATEADD(HOUR,2,u.IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106)
			
			
			Set @ComplianceInTime = Convert(datetime,Convert(nvarchar,@InterimDate) + ' ' + @ComplianceInTimeText)
			
			print 'CIT- ' + convert(nvarchar,@ComplianceInTime)
			print 'COT- ' +  convert(nvarchar,@ComplianceOutTime)

			--Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@InterimDate)

			--print 'OT-' + convert(nvarchar,isnull(@OTHours,0))

			--if @OTHours < 0
			--	Set @OTHours = 0
			
			Select @InTime=MIN(LogTime),@OutTime=MAX(LogTime)
			from tblUserAttendance Where EmployeeID = @EmployeeID And Convert(nvarchar,LogTime,101) = Convert(nvarchar,@InterimDate,101)
			And AuthStatus='A'
			
			If @AttStatus <> 'Absent'
			begin
				Declare @IdealLogoutTime as datetime
				select @IdealLogoutTime = max(IdealLogOutTime) from tblUserAttendance u where u.EmployeeID = @EmployeeID and convert(nvarchar,u.LogTime,106) = convert(nvarchar,@InterimDate,106)
			
				If @OutTime > @ComplianceOutTime
				begin
					print 'A';
					Set @OutTime = DATEADD(HOUR,-2,@OutTime)
					
					if @OutTime > @ComplianceOutTime
					begin
						Set @ComplianceOutTime = DATEADD(HOUR,-1,@ComplianceOutTime)
						Set @OutTime = Convert(datetime, Convert(nvarchar,@ComplianceOutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@ComplianceOutTime)) + ':' + Convert(nvarchar,50)+ ':' + Convert(nvarchar, 59) + ':570' )
						print 'OUTT- ' + convert(nvarchar,@OutTime)
					end
					
					Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
					print 'OTHR- '+ convert(nvarchar,@OTHours)
				end
				else
				begin
					print 'B';
					If @OutTime > @IdealLogoutTime
					begin
						Set @OutTime = Convert(datetime, Convert(nvarchar,@IdealLogoutTime,101)+ ' ' + Convert(nvarchar, DATEPART(HOUR,@IdealLogoutTime)) + ':00:59:560' )
					end
					
					Set @OTHours = dbo.fnMeasureOTHrsCom(@EmployeeID,@OutTime)
					print 'OTHR- '+ convert(nvarchar,isnull(@OTHours,0))
				end
				
				if @OTHours < 0
					Set @OTHours = 0;
				
				-- Resetting for ramadan 
				If @SectionIDCom = 'SEC-00000003' or @SectionIDCom = 'SEC-00000004' or @SectionIDCom = 'SEC-00000027' or @SectionIDCom = 'SEC-00000029' or @SectionIDCom = 'SEC-00000032' or @SectionIDCom = 'SEC-00000043' or @SectionIDCom = 'SEC-00000044' or @SectionIDCom = 'SEC-00000051' or @SectionIDCom = 'SEC-00000052' or @SectionIDCom = 'SEC-00000053' or @SectionIDCom = 'SEC-00000054' or @SectionIDCom = 'SEC-00000055' or @SectionIDCom = 'SEC-00000056' or @SectionIDCom = 'SEC-00000059'
				begin
					Set @OTHours = 0;
				end
				
			end

			end
			Set @total_ot_hrs += isnull(@OTHours,0);
			print 'Final - ' + convert(nvarchar,@total_ot_hrs);
			Set @InterimDate = DATEADD(DAY,1,@InterimDate)
			Set @OTHours = 0;
			print '***************************'
		end

		select @total_ot_hrs;