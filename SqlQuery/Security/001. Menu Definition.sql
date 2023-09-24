

Create table tblMenu(
MenuID nvarchar(50) primary key,
MenuValue nvarchar(50) unique(MenuValue),
MenuName nvarchar(200),
MenuOrder int,
MenuHyperlink nvarchar(200),
ParentMenu nvarchar(50) foreign key references tblMenu(MenuID),
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spInsertMenu
@MenuValue nvarchar(50),
@MenuName nvarchar(200),
@MenuOrder int,
@MenuHyperlink nvarchar(200),
@ParentMenu nvarchar(50),
@EntryBy nvarchar(50)
as
begin
	Declare @MenuID nvarchar(50)
	Declare @CurrentMenuID numeric(18,0)
	Declare @MenuIDPrefix as nvarchar(4)

	set @MenuIDPrefix='MNU-'

begin tran

	if @ParentMenu = 'N\A'
		Set @ParentMenu = NULL;
	
	select @CurrentMenuID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentMenuID'
	
	set @CurrentMenuID=isnull(@CurrentMenuID,0)+1
	Select @MenuID=dbo.generateID(@MenuIDPrefix,@CurrentMenuID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblMenu(MenuID,MenuValue,MenuName,MenuOrder,MenuHyperlink,ParentMenu,EntryBy)
	values(@MenuID,@MenuValue,@MenuName,@MenuOrder,@MenuHyperlink,@ParentMenu,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentMenuID where PropertyName='CurrentMenuID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

alter proc spUpdateMenu
@MenuID nvarchar(50),
@MenuValue nvarchar(50),
@MenuName nvarchar(200),
@MenuOrder int,
@MenuHyperlink nvarchar(200),
@ParentMenu nvarchar(50),
@EntryBy nvarchar(50)
as
begin
begin tran

	if @ParentMenu = 'N\A'
		Set @ParentMenu = NULL;

	update tblMenu Set MenuValue=@MenuValue,MenuName=@MenuName,MenuOrder=@MenuOrder,MenuHyperlink=@MenuHyperlink,
	ParentMenu=@ParentMenu Where MenuID = @MenuID
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

-- exec spGetAllMenuInfo
alter proc spGetAllMenuInfo
as
begin
	select MenuID,MenuValue,MenuName,MenuOrder,MenuHyperlink,ParentMenu,EntryBy,EntryDate from tblMenu
	order by MenuName
end

GO

alter proc spGetChildNodes
@ParentMenu nvarchar(50)
as
begin
	If @ParentMenu = 'N\A'
	begin
		Select MenuID,MenuName from tblMenu Where ParentMenu is NULL order by MenuName
	end
	else
		Select MenuID,MenuName from tblMenu Where ParentMenu = @ParentMenu order by MenuName
end

-- exec spGetChildNodes 'N\A'
-- exec spGetChildNodes 'MNU-00000001'

GO

alter proc spGetMenuInfoByID
@MenuID nvarchar(50)
as
begin
	select MenuID,MenuValue,MenuName,MenuOrder,MenuHyperlink,ISNULL(ParentMenu,'N\A') as ParentMenu
	from tblMenu Where MenuID=@MenuID
end

-- exec spGetMenuInfoByID 'MNU-00000005'

GO