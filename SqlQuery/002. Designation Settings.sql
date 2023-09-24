
GO

Create table tblDesignation(
DesignationID nvarchar(50) primary key,
Designation nvarchar(50) unique(Designation),
DesignationBangla nvarchar(50) unique(DesignationBangla),
ShortCode nvarchar(50) unique(ShortCode),
DesignationLevel nvarchar(50),
DesignationType nvarchar(50),
IntOrder int,
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spUpdateDesignation
@DesignationID nvarchar(50),
@Designation nvarchar(50),
@DesignationBangla nvarchar(50),
@ShortCode nvarchar(50),
@DesignationLevel nvarchar(50),
@DesignationType nvarchar(50),
@IntOrder int,
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblDesignation Set Designation=@Designation,DesignationBangla=@DesignationBangla,ShortCode=@ShortCode,
	DesignationLevel=@DesignationLevel,DesignationType=@DesignationType,IntOrder=@IntOrder,
	IsActive=@IsActive,EntryBy=@EntryBy,EntryDate=GETDATE()
	Where DesignationID=@DesignationID
end

GO

alter proc spInsertDesignation
@Designation nvarchar(50),
@DesignationBangla nvarchar(50),
@ShortCode nvarchar(50),
@DesignationLevel nvarchar(50),
@DesignationType nvarchar(50),
@IntOrder int,
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @DesignationID nvarchar(50)
	Declare @CurrentDesignationID numeric(18,0)
	Declare @DesignationIDPrefix as nvarchar(6)

	set @DesignationIDPrefix='DESIG-'

begin tran
	
	select @CurrentDesignationID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentDesignationID'
	
	set @CurrentDesignationID=isnull(@CurrentDesignationID,0)+1
	Select @DesignationID=dbo.generateID(@DesignationIDPrefix,@CurrentDesignationID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblDesignation(DesignationID,Designation,DesignationBangla,ShortCode,DesignationLevel,DesignationType,IntOrder,IsActive,EntryBy)
	Values(@DesignationID,@Designation,@DesignationBangla,@ShortCode,@DesignationLevel,@DesignationType,@IntOrder,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentDesignationID where PropertyName='CurrentDesignationID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO
exec spInsertDesignation 'COMMERCIAL','COMMERCIAL','Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'MERCHANDISER','MERCHANDISER','Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'ACCOUNTS','ACCOUNTS','Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'P.M','P.M','Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'COMPLIANCE MANAGER','COMPLIANCE MANAGER','Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'WELFARE OFFICER','WELFARE OFFICER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'DESIGNER','DESIGNER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'STORE INCHARGE','STORE INCHARGE','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'STORE ASSISTANT','STORE ASSISTANT','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'NURSE','NURSE','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TIME KEEPER','TIME KEEPER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'ELECTRICIAN','ELECTRICIAN','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SECURITY INCHAGE','SECURITY INCHAGE','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SECURITY SUPERVISIOR','SECURITY SUPERVISIOR','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SECURITY','SECURITY','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PURCHASE MANAGER','PURCHASE MANAGER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'YARN CONTROLLER','YARN CONTROLLER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'FACTORY QC','FACTORY QC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'OPERATOR','OPERATOR','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LOADER','LOADER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'HELPER','HELPER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SUPERVISIOR','SUPERVISIOR','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TRAINER','TRAINER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SAMPLE MAN','SAMPLE MAN','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PQC MENDING','PQC MENDING','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'CHACKER','CHACKER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'CLEANER','CLEANER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SWEEPER','SWEEPER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'INCHARGE','INCHARGE','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'DISTRIBUTOR','DISTRIBUTOR','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'INSPECTION','INSPECTION','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING MENDING','KNITTING MENDING','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'JAQUERD OPERATOR','JAQUERD OPERATOR','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TECHNICIAN','TECHNICIAN','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'A.P.M','A.P.M','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'FINISHING INCHARGE','FINISHING INCHARGE','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'KNITTING OPERATOR','KO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING HELPER','KH','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING JACQUARD','KJ','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING SUPERVISOR','KS','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING INSPECTOR','KI','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING DISTRIBUTOR','KD','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING SAMPLE MAN','KSM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'KNITTING INCHARGE','KINCHARGE','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'LINKING OPERATOR','LO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LINKING SAMPLE MAN','LSM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LINKING INSPECTOR','LI','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LINKING SUPERVISOR','LS','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LINKING DISTRIBUTOR','LD','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'TRIMMING OPERATOR','TO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TRIMMING TRAINER','TT','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TRIMMING DISTRIBUTOR','TD','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TRIMMING SUPERVISOR','TS','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'MENDING OPERATOR','MO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'MENDING SUPERVISOR','MS','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'MENDING SAMPLE MAN','MSM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'MENDING HELPER','MH','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'WINDING OPERATOR','WO','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'WASH OPERATOR','WASHO','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'SEWING OPERATOR','SO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SEWING HELPER','SH','Non-Management','Official',0,1,'dsamaddar'


exec spInsertDesignation 'STORE ASSITANT','SA','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'PACKING HELPER','PH','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PACKING SUPERVISOR','PS','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PACKING OPERATOR','PO','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'PQC OPERATOR','PQCO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PQC HELPER','PQCH','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PQC SUPERVISOR','PQCS','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'IRON OPERATOR','IO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'IRON QC','IQC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'IRON SUPERVISOR','IS','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'IRON SAMPLE MAN','ISM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'IRON HELPER','IH','Non-Management','Official',0,1,'dsamaddar'

exec spInsertDesignation 'OVERLOCK OPERATOR','OVOP','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LIGHT CHECKER','LC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'DRIVER','DRIVER','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'QC','QC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'ASSISTANT PRODUCTION MANAGER','APM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'SENIOR ELECTRICIAN','SELEC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'NEEDLE MAN','NM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'INSPECTION SAMPLE MAN','INSSM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'COMMERCIAL EXECUTIVE','CE','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LADY CHECKER','LDYC','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'DOCTOR','DCT','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'OFFICE ASSISTANT','OA','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'LINKING TECHNITIAN','LT','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'PRODUCTION MANAGER','PM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'COMMERCIAL OFFICER','CO','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'ACCOUNTS MANAGER','AM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'TRAINEE MERCHANDISER','TM','Non-Management','Official',0,1,'dsamaddar'
exec spInsertDesignation 'CHIEF ACCOUNTANT','CA','Non-Management','Official',0,1,'dsamaddar'


GO

alter proc spGetDesignationList
as
begin
	Select DesignationID,Designation,DesignationBangla,ShortCode,DesignationLevel,DesignationType,
	IntOrder,case IsActive when 1 then 'YES' else 'NO' end as 'IsActive',
	EntryBy,Convert(nvarchar,EntryDate,106) as 'EntryDate'
	from tblDesignation Where IsActive=1 
	order by Designation
end

exec spGetDesignationList

GO