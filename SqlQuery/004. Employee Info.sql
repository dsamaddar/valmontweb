
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
@JoiningDateBangla nvarchar(20)
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
	PermanentDistrictID,PermanentUpazilaID,PermanentAddress,JoiningDate,MobileNo,MachineNo,EmpPhoto,EmpSignature,BasicSalary,BlockID,
	SectionID,DesignationID,EmpStatus,IsActive,InCludedInPayroll,BloodGroup,NationalID,EntryBy,CardNo,CardNoBangla,EmployeeNameBangla,JoiningDateBangla
	)
	Values(@EmployeeID,@EmployeeName,@EmpCode,@FathersName,@MothersName,@PresentDistrictID,@PresentUpazilaID,@PresentAddress,@PermanentDistrictID,
	@PermanentUpazilaID,@PermanentAddress,@JoiningDate,@MobileNo,@MachineNo,@EmpPhoto,@EmpSignature,@BasicSalary,@BlockID,@SectionID,
	@DesignationID,@EmpStatus,@IsActive,@InCludedInPayroll,@BloodGroup,@NationalID,@EntryBy,@CardNo,@CardNoBangla,@EmployeeNameBangla,@JoiningDateBangla)
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
	EI.EmpPhoto,EI.EmpSignature,ISNULL(EI.BasicSalary,0) as 'BasicSalary',
	ISNULL(EI.BlockID,'N\A') as 'BlockID',B.Block,EI.SectionID,S.Section,EI.DesignationID,D.Designation,ISNULL(EI.BloodGroup,'N\A') as 'BloodGroup',ISNULL(EI.NationalID,'') as 'NationalID',
	EI.EmpStatus,
	Case When EI.IsActive = 1 Then 'YES' Else 'NO' End as 'Active',
	Case When EI.InCludedInPayroll = 1 Then 'YES' Else 'NO' End as 'InPayroll',
	ISNULL(EI.CardNo,'.') as 'CardNo',ISNULL(EI.CardNoBangla,'.') as 'CardNoBangla',ISNULL(EI.EmployeeNameBangla,'.') as 'EmployeeNameBangla',
	ISNULL(EI.JoiningDateBangla,'.') as 'JoiningDateBangla'
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
@JoiningDateBangla nvarchar(20)
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
	BasicSalary=@BasicSalary,BlockID=@BlockID,SectionID=@SectionID,DesignationID=@DesignationID,EmpStatus=@EmpStatus,IsActive=@IsActive,
	InCludedInPayroll=@InCludedInPayroll,BloodGroup=@BloodGroup,NationalID=@NationalID,EntryBy=@EntryBy,
	CardNo=@CardNo,CardNoBangla=@CardNoBangla,EmployeeNameBangla=@EmployeeNameBangla,JoiningDateBangla=@JoiningDateBangla
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
	(EmployeeName like '%'+ @NameorIDParam +'%' Or EmployeeName Is NULL) 
	--And (EmpCode like '%'+ @NameorIDParam +'%' Or EmpCode Is NULL)
	And (MobileNo like '%'+ @MobileNoParam +'%' Or MobileNo Is NULL)
	And (NationalID like '%'+ @NationalIDParam +'%' Or NationalID Is NULL)
end

exec spSearchEmployee 'zamin','',''


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
	ISNULL(BloodGroup,'N\A') as 'BloodGroup',EmpPhoto,MobileNo,NationalID,PermanentAddress,JoiningDateBangla,CardNoBangla
 	from tblEmployeeInfo EI Left Join tblDesignation D On EI.DesignationID = D.DesignationID 
	Left Join tblSection S On EI.SectionID = S.SectionID
	Where EmployeeName <> '' And EmpPhoto <> ''
	And CardNo >= Convert(int,@StartingCardNo) And CardNo <= Convert(int,@EndingCardNo)
	And EI.IsActive=1
	Order By EmployeeName
end

-- exec spPrintIDCardBangla '10001','10004'

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

Create proc spGetEmpListPayrollActive
as
begin
	SELECT EmployeeID,EmployeeName + ' ( ' + EmpCode + ' )' as 'EmployeeName'
	FROM [dbo].tblEmployeeInfo
	where isActive =1 And IncludedInPayroll=1 order by EmployeeName
end