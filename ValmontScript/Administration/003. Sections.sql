
CREATE TABLE tblSection(
SectionID nvarchar(50) Primary Key,
Section nvarchar(50) unique(Section),
SectionInBangla nvarchar(50),
IdealLoginTime nvarchar(20),
IdealLogoutTime nvarchar(20),
SpecialLogoutTime nvarchar(20),
IsSpecial bit default 0,
IsActive bit default 0,
EntryBy nvarchar(50),
EntryDate datetime default getdate(),
);

GO


alter proc spInsertSection
@Section nvarchar(50),
@SectionInBangla nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @SectionID nvarchar(50)
	Declare @CurrentSectionID numeric(18,0)
	Declare @SectionIDPrefix as nvarchar(4)

	set @SectionIDPrefix='SEC-'

begin tran
	
	select @CurrentSectionID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentSectionID'
	
	set @CurrentSectionID=isnull(@CurrentSectionID,0)+1
	Select @SectionID=dbo.generateID(@SectionIDPrefix,@CurrentSectionID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblSection(SectionID,Section,SectionInBangla,IdealLoginTime,IdealLogout,IdealLogoutTime,IdealLogoutStandard,SpecialLogoutTime,ShiftID,IsSpecial,IsActive,EntryBy) 
	Values(@SectionID,@Section,@SectionInBangla,'08:00:00 AM','05:00:00 PM','07:00:00 PM','05:00:00 PM',NULL,NULL,0,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentSectionID where PropertyName='CurrentSectionID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end


GO

Create proc spUpdateSection
@SectionID nvarchar(50),
@Section nvarchar(50),
@SectionInBangla nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	update tblSection set Section=@Section,SectionInBangla=@SectionInBangla,IsActive=@IsActive,
	EntryBy=@EntryBy
	where SectionID = @SectionID
end

GO

alter proc spGetSectionList
as
begin
	Select SectionID,Section,SectionInBangla,
	CASE IsActive WHEN 1 THEN 'YES' ELSE 'NO' END as 'IsActive',
	EntryBy,Convert(nvarchar,EntryDate,106) as 'EntryDate'
	from tblSection Where IsActive=1
	order By Section
end

-- exec spGetSectionList

GO

--select * from tblSection
/*
exec spInsertSection 'CLEANING',1,'dsamaddar'
exec spInsertSection 'OFFICE STAFF',1,'dsamaddar'
*/

