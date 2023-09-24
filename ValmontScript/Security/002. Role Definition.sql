
GO

Insert Into tblAppSettings(PropertyName,PropertyValue) Values('CurrentRoleID',0)

GO
-- drop table tblRole
Create table tblRole(
RoleID nvarchar(50) primary key,
RoleName nvarchar(200) unique(RoleName),
MenuList nvarchar(MAX),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO


alter proc spInsertRole
@RoleName nvarchar(200),
@MenuList nvarchar(MAX),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @RoleID nvarchar(50)
	Declare @CurrentRoleID numeric(18,0)
	Declare @RoleIDPrefix as nvarchar(3)

	set @RoleIDPrefix='RL-'

begin tran

	select @CurrentRoleID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentRoleID'
	
	set @CurrentRoleID=isnull(@CurrentRoleID,0)+1
	Select @RoleID=dbo.generateID(@RoleIDPrefix,@CurrentRoleID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblRole(RoleID,RoleName,MenuList,IsActive,EntryBy)
	Values(@RoleID,@RoleName,@MenuList,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentRoleID where PropertyName='CurrentRoleID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

Create proc spUpdateRole
@RoleID nvarchar(50),
@RoleName nvarchar(200),
@MenuList nvarchar(MAX),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Update tblRole Set RoleName=@RoleName,MenuList=@MenuList,IsActive=@IsActive,EntryBy=@EntryBy
	Where RoleID=@RoleID
end

GO

Create proc spGetRoleInfo
as
begin
	Select * from tblRole Where IsActive = 1
	Order By RoleName
end

-- exec spGetRoleInfo

GO

alter proc spGetRoleInfoByID
@RoleID nvarchar(50)
as
begin
	Select RoleID,RoleName,MenuList,IsActive,EntryBy,EntryDate from tblRole Where RoleID=@RoleID
	Order By RoleName
end