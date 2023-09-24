
-- drop table tblEmployeeInfo
Create table tblEmployeeInfo(
EmployeeID nvarchar(50) primary key,
EmployeeName nvarchar(200),
EmployeeNameBangla nvarchar(200),
EmpCode nvarchar(50),
UserID nvarchar(50) unique(UserID),
UserPassword nvarchar(50),
UserType nvarchar(50),
FathersName nvarchar(200),
MothersName nvarchar(200),
PresentDistrictID int,
PresentUpazilaID int,
PresentAddress nvarchar(500),
PermanentDistrictID int,
PermanentUpazilaID int,
PermanentAddress nvarchar(500),
JoiningDate date,
JoiningDateBangla nvarchar(20),
MobileNo nvarchar(50),
AlternateMobileNo nvarchar(50),
MachineNo nvarchar(50),
EmpPhoto nvarchar(50),
EmpSignature nvarchar(50),
BasicSalary numeric(18,2),
HouseRent numeric(18,2),
Medical numeric(18,2),
Conveyance numeric(18,2),
Food numeric(18,2),
GrossSalary numeric(18,2),
PaymentMethod char(1),
BlockID nvarchar(50) foreign key references tblBlocks(BlockID),
BlockIDBangla nvarchar(50) foreign key references tblBlocks(BlockID),
SectionID nvarchar(50) foreign key references tblSection(SectionID),
SectionIDBangla nvarchar(50) foreign key references tblSection(SectionID),
DesignationID nvarchar(50) foreign key references tblDesignation(DesignationID),
DesignationIDBangla nvarchar(50) foreign key references tblDesignation(DesignationID),
CurrentSupervisor nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
BloodGroup nvarchar(50),
NationalID nvarchar(50),
RFIDCode nvarchar(50),
ExistingCardNo nvarchar(50) unique(ExistingCardNo),
CardNo nvarchar(50) unique(CardNo),
CardNoBangla nvarchar(50) unique(CardNo),
EmpStatus nvarchar(50),
IsActive bit default 1,
InCludedInPayroll bit default 1,
ExitDate date,
IdealLogTime nvarchar(50),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spInsertEmployee
@EmployeeName nvarchar(200),
@EmpCode nvarchar(50),
@FathersName nvarchar(200),
@MothersName nvarchar(200),
@PresentDistrictID int,
@PresentUpazilaID int,
@PresentAddress nvarchar(500),
@PermanentDistrictID int,
@PermanentUpazilaID int,
@PermanentAddress nvarchar(500),
@JoiningDate datetime,
@MobileNo nvarchar(50),
@AlternateMobileNo nvarchar(50),
@MachineNo nvarchar(50),
@EmpPhoto nvarchar(50),
@EmpSignature nvarchar(50),
@BasicSalary numeric(18,2),
@PaymentMethod char(1),
@BlockID nvarchar(50),
@SectionID nvarchar(50),
@DesignationID nvarchar(50),
@EmpStatus nvarchar(50),
@IsActive bit,
@InCludedInPayroll bit,
@BloodGroup nvarchar(50),
@NationalID nvarchar(50),
@EntryBy nvarchar(50),
@CardNo nvarchar(50),
@CardNoBangla nvarchar(50),
@EmployeeNameBangla nvarchar(200),
@JoiningDateBangla nvarchar(20),
@ExitDate date
as
begin
	Declare @EmployeeID nvarchar(50)
	Declare @CurrentEmployeeID numeric(18,0)
	Declare @EmployeeIDPrefix as nvarchar(4)

	set @EmployeeIDPrefix='EMP-'

begin tran

	If @BlockID = 'N\A'
		Set @BlockID = NULL
	
	select @CurrentEmployeeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentEmployeeID'
	
	set @CurrentEmployeeID=isnull(@CurrentEmployeeID,0)+1
	Select @EmployeeID=dbo.generateID(@EmployeeIDPrefix,@CurrentEmployeeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblEmployeeInfo(EmployeeID,EmployeeName,EmpCode,FathersName,MothersName,PresentDistrictID,PresentUpazilaID,PresentAddress,
	PermanentDistrictID,PermanentUpazilaID,PermanentAddress,JoiningDate,MobileNo,MachineNo,EmpPhoto,EmpSignature,BasicSalary,PaymentMethod,BlockID,
	SectionID,DesignationID,EmpStatus,IsActive,InCludedInPayroll,BloodGroup,NationalID,EntryBy,CardNo,CardNoBangla,EmployeeNameBangla,JoiningDateBangla,ExitDate
	)
	Values(@EmployeeID,@EmployeeName,@EmpCode,@FathersName,@MothersName,@PresentDistrictID,@PresentUpazilaID,@PresentAddress,@PermanentDistrictID,
	@PermanentUpazilaID,@PermanentAddress,@JoiningDate,@MobileNo,@MachineNo,@EmpPhoto,@EmpSignature,@BasicSalary,@PaymentMethod,@BlockID,@SectionID,
	@DesignationID,@EmpStatus,@IsActive,@InCludedInPayroll,@BloodGroup,@NationalID,@EntryBy,@CardNo,@CardNoBangla,@EmployeeNameBangla,@JoiningDateBangla,@ExitDate)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentEmployeeID where PropertyName='CurrentEmployeeID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spGetAllEmpDetails
as
begin
	Select EI.EmployeeID,EI.EmployeeName,EI.EmpCode,EI.FathersName,EI.MothersName,
	ISNULL(EI.PresentDistrictID,0) as 'PresentDistrictID',
	ISNULL(dbo.fnGetDistrictNameByID(EI.PresentDistrictID),'N\A') as 'PreDistrict',
	Isnull(EI.PresentUpazilaID,0) as 'PresentUpazilaID',
	ISNULL(dbo.fnGetThanaNameByID(EI.PresentUpazilaID),'N\A') as 'PreUpazila',
	EI.PresentAddress,
	ISNULL(EI.PermanentDistrictID,0) as 'PermanentDistrictID',
	ISNULL(dbo.fnGetDistrictNameByID(EI.PermanentDistrictID),'N\A') as 'PerDistrict',
	isnull(EI.PermanentUpazilaID,0) as 'PermanentUpazilaID',
	ISNULL(dbo.fnGetThanaNameByID(EI.PermanentUpazilaID),'N\A') as 'PerUpazila',EI.PermanentAddress,
	Convert(nvarchar,EI.JoiningDate,101) as 'JoiningDate',
	EI.MobileNo,ISNULL(EI.AlternateMobileNo,'') as 'AlternateMobileNo',ISNULL(EI.MachineNo,'.') as 'MachineNo',
	EI.EmpPhoto,EI.EmpSignature,ISNULL(EI.BasicSalary,0) as 'BasicSalary',ISNULL(EI.PaymentMethod,'C') as PaymentMethod,
	ISNULL(EI.BlockID,'N\A') as 'BlockID',B.Block,EI.SectionID,S.Section,EI.DesignationID,D.Designation,ISNULL(EI.BloodGroup,'N\A') as 'BloodGroup',ISNULL(EI.NationalID,'') as 'NationalID',
	EI.EmpStatus,
	Case When EI.IsActive = 1 Then 'YES' Else 'NO' End as 'Active',
	Case When EI.InCludedInPayroll = 1 Then 'YES' Else 'NO' End as 'InPayroll',
	ISNULL(EI.CardNo,'.') as 'CardNo',ISNULL(EI.CardNoBangla,'.') as 'CardNoBangla',ISNULL(EI.EmployeeNameBangla,'.') as 'EmployeeNameBangla',
	ISNULL(EI.JoiningDateBangla,'.') as 'JoiningDateBangla',
	ISNULL(EI.ExitDate,'01/01/2030') as 'ExitDate'
	from tblEmployeeInfo EI Left Join tblSection S ON EI.SectionID = S.SectionID
	Left Join tblDesignation D ON EI.DesignationID = D.DesignationID
	Left Join tblBlocks B On EI.BlockID = B.BlockID
	Where EI.IsActive=1
end

-- exec spGetAllEmpDetails

GO


alter proc spInsertEmployeeSimple
@EmployeeName nvarchar(200),
@EmpCode nvarchar(50),
@JoiningDate datetime,
@BasicSalary numeric(18,2),
@BlockID nvarchar(50),
@SectionID nvarchar(50),
@DesignationID nvarchar(50)
as
begin
	Declare @EmployeeID nvarchar(50)
	Declare @CurrentEmployeeID numeric(18,0)
	Declare @EmployeeIDPrefix as nvarchar(4)

	set @EmployeeIDPrefix='EMP-'

begin tran
	
	select @CurrentEmployeeID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentEmployeeID'
	
	set @CurrentEmployeeID=isnull(@CurrentEmployeeID,0)+1
	Select @EmployeeID=dbo.generateID(@EmployeeIDPrefix,@CurrentEmployeeID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblEmployeeInfo(EmployeeID,EmployeeName,EmpCode,FathersName,MothersName,PresentAddress,PermanentAddress,JoiningDate,
	MobileNo,MachineNo,EmpPhoto,EmpSignature,BasicSalary,BlockID,SectionID,DesignationID,EmpStatus,IsActive,InCludedInPayroll,EntryBy)
	Values(@EmployeeID,@EmployeeName,@EmpCode,'','','','',@JoiningDate,'','',
	'','',@BasicSalary,@BlockID,@SectionID,@DesignationID,'Active',1,1,'dsamaddar')
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentEmployeeID where PropertyName='CurrentEmployeeID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateEmployee
@EmployeeID nvarchar(50),
@EmployeeName nvarchar(200),
@EmpCode nvarchar(50),
@FathersName nvarchar(200),
@MothersName nvarchar(200),
@PresentDistrictID int,
@PresentUpazilaID int,
@PresentAddress nvarchar(500),
@PermanentDistrictID int,
@PermanentUpazilaID int,
@PermanentAddress nvarchar(500),
@JoiningDate datetime,
@MobileNo nvarchar(50),
@AlternateMobileNo nvarchar(50),
@MachineNo nvarchar(50),
@EmpPhoto nvarchar(50),
@EmpSignature nvarchar(50),
@BasicSalary numeric(18,2),
@PaymentMethod char(1),
@BlockID nvarchar(50),
@SectionID nvarchar(50),
@DesignationID nvarchar(50),
@EmpStatus nvarchar(50),
@IsActive bit,
@InCludedInPayroll bit,
@BloodGroup nvarchar(50),
@NationalID nvarchar(50),
@EntryBy nvarchar(50),
@CardNo nvarchar(50),
@CardNoBangla nvarchar(50),
@EmployeeNameBangla nvarchar(200),
@JoiningDateBangla nvarchar(20),
@ExitDate date
as
begin
begin tran
	
	If @PresentDistrictID = 0
		Set @PresentDistrictID = NULL

	If @PermanentDistrictID = 0
		Set @PermanentDistrictID = NULL

	If @PresentUpazilaID = 0
		Set @PresentUpazilaID = NULL

	If @PermanentUpazilaID = 0
		Set @PermanentUpazilaID = NULL

	If @BlockID = 'N\A'
		Set @BlockID = NULL

	Declare @PrevEmpPhoto as nvarchar(50) Set @PrevEmpPhoto = ''
	Declare @PrevEmpSignature as nvarchar(50) Set @PrevEmpSignature = ''

	Select @PrevEmpPhoto=EmpPhoto,@PrevEmpSignature=EmpSignature from tblEmployeeInfo Where EmployeeID=@EmployeeID

	if @EmpPhoto = ''
		Set @EmpPhoto = @PrevEmpPhoto

	if @EmpSignature = ''
		Set @EmpSignature = @PrevEmpSignature

	Update tblEmployeeInfo SEt EmployeeName=@EmployeeName,EmpCode=@EmpCode,FathersName=@FathersName,MothersName=@MothersName,
	PresentDistrictID=@PresentDistrictID,PresentUpazilaID=@PresentUpazilaID,PresentAddress=@PresentAddress,
	PermanentDistrictID=@PermanentDistrictID,PermanentUpazilaID=@PermanentUpazilaID,PermanentAddress=@PermanentAddress,
	JoiningDate=@JoiningDate,MobileNo=@MobileNo,AlternateMobileNo=@AlternateMobileNo,MachineNo=@MachineNo,EmpPhoto=@EmpPhoto,EmpSignature=@EmpSignature,
	BasicSalary=@BasicSalary,PaymentMethod=@PaymentMethod,BlockID=@BlockID,SectionID=@SectionID,DesignationID=@DesignationID,EmpStatus=@EmpStatus,IsActive=@IsActive,
	InCludedInPayroll=@InCludedInPayroll,BloodGroup=@BloodGroup,NationalID=@NationalID,EntryBy=@EntryBy,
	CardNo=@CardNo,CardNoBangla=@CardNoBangla,EmployeeNameBangla=@EmployeeNameBangla,JoiningDateBangla=@JoiningDateBangla,
	ExitDate=@ExitDate
	Where EmployeeID=@EmployeeID

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create function fnGetDistrictNameByID(@DistrictID int)
returns nvarchar(200)
as
begin
	Declare @DistrictName as nvarchar(200)
	select @DistrictName = DistrictName from tblDistrict Where DistrictID=@DistrictID
	
	return @DistrictName
end

GO

Create function fnGetThanaNameByID(@UpazilaID int)
returns nvarchar(100)
begin
	Declare @UpazilaName as nvarchar(100)
	Select @UpazilaName = UpazilaName from tblUpazila Where UpazilaID=@UpazilaID

	return @UpazilaName
end

GO

Create proc spGetDistricts
as
begin
	SELECT DISTINCT DistrictName, DistrictID FROM tblDistrict ORDER BY DistrictName
end

GO

Create proc spGetUpazillaName
@DistrictID int
as

begin
	SELECT UpazilaName, UpazilaID FROM tblUpazila WHERE (DistrictID = @DistrictID) ORDER BY UpazilaName
end

GO

alter proc spSearchEmployee
@NameorID nvarchar(50),
@MobileNo nvarchar(50),
@NationalID nvarchar(50)
as
begin

	Declare @NameorIDParam as nvarchar(50) Set @NameorIDParam = ''
	Declare @MobileNoParam as nvarchar(50) Set @MobileNoParam = ''
	Declare @NationalIDParam as nvarchar(50) Set @NationalIDParam = ''

	If @NameorID = ''
		Set @NameorIDParam = '%'
	else
		Set @NameorIDParam = '%'+ @NameorID +'%'

	If @MobileNo = ''
		Set @MobileNoParam = '%'
	else
		Set @MobileNoParam = '%'+ @MobileNo +'%'

	If @NationalID = ''
		Set @NationalIDParam = '%'
	else
		Set @NationalIDParam = '%'+ @NationalID +'%'



	Select EmployeeID,EmployeeName,EmpCode,MobileNo from tblEmployeeInfo 
	Where 
	(EmployeeName like '%'+ @NameorIDParam +'%' Or EmpCode like '%'+ @NameorIDParam +'%') 
	And (MobileNo like '%'+ @MobileNoParam +'%' Or MobileNo Is NULL)
	And (NationalID like '%'+ @NationalIDParam +'%' Or NationalID Is NULL)
end

-- exec spSearchEmployee '10137','',''

GO

alter proc spSearchInActiveEmployee
@NameorID nvarchar(50),
@MobileNo nvarchar(50),
@NationalID nvarchar(50)
as
begin

	Declare @NameorIDParam as nvarchar(50) Set @NameorIDParam = ''
	Declare @MobileNoParam as nvarchar(50) Set @MobileNoParam = ''
	Declare @NationalIDParam as nvarchar(50) Set @NationalIDParam = ''

	If @NameorID = ''
		Set @NameorIDParam = '%'
	else
		Set @NameorIDParam = '%'+ @NameorID +'%'

	If @MobileNo = ''
		Set @MobileNoParam = '%'
	else
		Set @MobileNoParam = '%'+ @MobileNo +'%'

	If @NationalID = ''
		Set @NationalIDParam = '%'
	else
		Set @NationalIDParam = '%'+ @NationalID +'%'

	Select EmployeeID,EmployeeName,EmpCode,MobileNo,IsActive from tblEmployeeInfo 
	Where 
	(EmployeeName like '%'+ @NameorIDParam +'%' Or EmpCode like '%'+ @NameorIDParam +'%') 
	And (MobileNo like '%'+ @MobileNoParam +'%' Or MobileNo Is NULL)
	And (NationalID like '%'+ @NationalIDParam +'%' Or NationalID Is NULL)
	And IsActive=0
end

GO

Create proc spActivateEmployee
@EmployeeID nvarchar(50)
as
begin
	Update tblEmployeeInfo Set IsActive=1 where EmployeeID=@EmployeeID
end


GO

alter proc spPrintIDCard
@StartingCardNo nvarchar(50),
@EndingCardNo nvarchar(50)
as
begin
	Select EmployeeName,EmpCode,D.Designation,S.Section,Convert(nvarchar,JoiningDate,106) as 'JoiningDate',
	ISNULL(BloodGroup,'N\A') as 'BloodGroup',EmpPhoto
 	from tblEmployeeInfo EI Left Join tblDesignation D On EI.DesignationID = D.DesignationID 
	Left Join tblSection S On EI.SectionID = S.SectionID
	Where EmployeeName <> '' And EmpPhoto <> ''
	And CardNo >= Convert(int,@StartingCardNo) And CardNo <= Convert(int,@EndingCardNo)
	Order By EmployeeName
end

-- exec spPrintIDCard

GO

alter proc spPrintIDCardBangla
@StartingCardNo nvarchar(50),
@EndingCardNo nvarchar(50)
as
begin
	Select ISNULL(EmployeeNameBangla,'') as 'EmployeeName',EmpCode,ISNULL(D.DesignationBangla,'') as 'Designation',
	S.SectionInBangla as 'Section',	Convert(nvarchar,JoiningDate,106) as 'JoiningDate',
	ISNULL(BloodGroup,'N\A') as 'BloodGroup',EmpPhoto,MobileNo,ISNULL(NationalID,'N\A') as 'NationalID',PermanentAddress,JoiningDateBangla,
	CardNoBangla + ' Block: ' + ISNULL(B.Block,'N\A') as 'CardNoBangla'
 	from tblEmployeeInfo EI Left Join tblDesignation D On EI.DesignationID = D.DesignationID 
	Left outer Join tblSection S On EI.SectionID = S.SectionID
	Left Outer Join tblBlocks B On EI.BlockID = B.BlockId
	Where EmployeeName <> '' And EmpPhoto <> ''
	--And CardNo >= Convert(int,@StartingCardNo) And CardNo <= Convert(int,@EndingCardNo)
	And CardNo between Convert(nvarchar,@StartingCardNo) And Convert(nvarchar,@EndingCardNo)
	And EI.IsActive=1
	Order By EmpCode
end

-- select * from tblEmployeeInfo where EmpCode in('13025','13026');

-- exec spPrintIDCardBangla '13025','13025'
-- exec spPrintIDCardBangla '13026','13026'

GO

alter proc spPrintIDCardReport
as
begin

	Declare @EmpTbl table(
	EmployeeName nvarchar(200),
	EmpCode nvarchar(200),
	Designation nvarchar(200),
	Section nvarchar(50),
	JoiningDate Datetime,
	BloodGroup nvarchar(50),
	EmpPhoto  nvarchar(50),
	MobileNo nvarchar(50),
	NationalID nvarchar(50),
	PermanentAddress nvarchar(200),
	JoiningDateBangla nvarchar(200),
	CardNoBangla nvarchar(50),
	Picture image
	);

	Select * from @EmpTbl

end

GO

alter proc spGetEmpInfoByRFIDCode
@RFIDCode nvarchar(50)
as
begin
	Select EmployeeName,EmpCode,D.Designation,MobileNo,EmpPhoto 
	from tblEmployeeInfo EI Left Join tblDesignation D On EI.DesignationID=D.DesignationID
	Where RFIDCode=@RFIDCode
end

GO

-- exec spGetEmpInfoByRFIDCode '10100'

GO

alter proc spGetEmpListPayrollActive
as
begin
	SELECT EmployeeID, ISNULL(EmpCode,'N\A') + ' - ' + EmployeeName as 'EmployeeName'
	FROM [dbo].tblEmployeeInfo
	where isActive =1 And IncludedInPayroll=1 
	order by EmpCode,EmployeeName
end

-- exec spGetEmpListPayrollActive
GO

alter proc spGetEmpListBySectionID
@SectionID nvarchar(50)
as
begin
	Declare @SectionIDParam as nvarchar(50) Set @SectionIDParam = '';

	if @SectionID = 'ALL'
		Set @SectionIDParam = '%'
	else
		Set @SectionIDParam = '%'+ @SectionID +'%'
	
	SELECT EmployeeID, ISNULL(EmpCode,'N\A') + ' - ' + EmployeeName as 'EmployeeName'
	FROM [dbo].tblEmployeeInfo
	where isActive =1 And IncludedInPayroll=1 And SectionID like @SectionIDParam
	order by EmpCode,EmployeeName
end

GO

alter view vwEmployeeDetails
as
SELECT        EI.EmployeeID, EI.EmployeeName, EI.EmpCode, EI.FathersName, EI.MothersName, PD.DistrictName AS PreDist, PU.UpazilaName AS PreUpz, EI.PresentAddress, PRD.DistrictName AS PerDist, PRU.UpazilaName AS PerUpz, 
EI.PermanentAddress, EI.JoiningDate, EI.MobileNo, ISNULL(EI.AlternateMobileNo, N'') AS AlternateMobileNo, B.Block, S.Section, D.Designation, ISNULL(EI.BloodGroup, N'N\A') AS BloodGroup, ISNULL(EI.NationalID, N'') 
AS NationalID, ISNULL(EI.RFIDCode, N'N\A') AS RFIDCode, EI.IsActive, EI.InCludedInPayroll,EI.MachineNo,EI.CardNo,
EmpPhoto,EmpSignature
FROM 
dbo.tblEmployeeInfo AS EI LEFT OUTER JOIN
dbo.tblDistrict AS PD ON EI.PresentDistrictID = PD.DistrictID LEFT OUTER JOIN
dbo.tblUpazila AS PU ON EI.PresentUpazilaID = PU.UpazilaID LEFT OUTER JOIN
dbo.tblDistrict AS PRD ON EI.PermanentDistrictID = PRD.DistrictID LEFT OUTER JOIN
dbo.tblUpazila AS PRU ON EI.PermanentUpazilaID = PRU.UpazilaID LEFT OUTER JOIN
dbo.tblBlocks AS B ON EI.BlockID = B.BlockID LEFT OUTER JOIN
dbo.tblSection AS S ON EI.SectionID = S.SectionID LEFT OUTER JOIN
dbo.tblDesignation AS D ON EI.DesignationID = D.DesignationID

GO

alter proc spGetEmpInfoByID
@EmployeeID nvarchar(50)
as
begin
	Select EmployeeID,EmployeeName,EmpCode,Designation,Section,MobileNo,
	PermanentAddress + ', ' + PerUpz + ', ' + PerDist as PermanentAddress,
	PresentAddress + ', ' + PreUpz + ', ' + PreDist as PresentAddress,
	EmpPhoto
	from vwEmployeeDetails where EmployeeID = @EmployeeID
end

-- exec spGetEmpInfoByID 'EMP-00000012'

GO

alter proc spGetShiftingEmployee
as
begin
	select E.EmpCode + ' - ' + E.EmployeeName as EmployeeName,E.EmployeeID from 
	tblEmployeeInfo E where E.SectionID in (
	select s.SectionID from tblSection s where s.ShiftID is not null
	)
	order by E.EmployeeName
end

-- exec spGetShiftingEmployee