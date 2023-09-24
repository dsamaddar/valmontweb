
Insert Into tblAppSettings(PropertyName,PropertyValue) Values('CurrentComponentID',0);
GO

-- drop table tblComponents
Create table tblComponents(
ComponentID nvarchar(50) primary key,
SectionID nvarchar(50) foreign key references tblSection(SectionID),
ComponentName nvarchar(100) unique(ComponentName),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

Create proc spGetComponentList
as
begin
	Select ComponentID,SectionID,ComponentName,IsActive,EntryBy,EntryDate
	from tblComponents order by ComponentName
end

GO

Create proc spInsertComponent
@SectionID nvarchar(50),
@ComponentName nvarchar(100),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @ComponentID nvarchar(50)
	Declare @CurrentComponentID numeric(18,0)
	Declare @ComponentIDPrefix as nvarchar(4)

	set @ComponentIDPrefix='CMP-'

begin tran
	
	select @CurrentComponentID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentComponentID'
	
	set @CurrentComponentID=isnull(@CurrentComponentID,0)+1
	Select @ComponentID=dbo.generateID(@ComponentIDPrefix,@CurrentComponentID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblComponents(ComponentID,SectionID,ComponentName,IsActive,EntryBy)
	Values(@ComponentID,@SectionID,@ComponentName,@IsActive,@EntryBy)

	update tblAppSettings set PropertyValue=@CurrentComponentID where PropertyName='CurrentComponentID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUpdateComponent
@ComponentID nvarchar(50),
@ComponentName nvarchar(100),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblComponents Set ComponentName=@ComponentName,IsActive=@IsActive, EntryBy=@EntryBy
	Where ComponentID=@ComponentID
end
