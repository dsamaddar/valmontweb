
Create table tblBlocks(
BlockID nvarchar(50) primary key,
Block nvarchar(50) unique(Block),
BlockBangla nvarchar(50) unique(BlockBangla),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO


alter proc spInsertBlocks
@Block nvarchar(50),
@IsActive bit,
@EntryBy nvarchar(50)
as
begin
	Declare @BlockID nvarchar(50)
	Declare @CurrentBlockID numeric(18,0)
	Declare @BlockIDPrefix as nvarchar(4)

	set @BlockIDPrefix='BLC-'

begin tran
	
	select @CurrentBlockID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentBlockID'
	
	set @CurrentBlockID=isnull(@CurrentBlockID,0)+1
	Select @BlockID=dbo.generateID(@BlockIDPrefix,@CurrentBlockID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert into tblBlocks(BlockID,Block,IsActive,EntryBy) Values(@BlockID,@Block,@IsActive,@EntryBy)
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	update tblAppSettings set PropertyValue=@CurrentBlockID where PropertyName='CurrentBlockID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

GO

exec spInsertBlocks 'KNITTING WORKER-A',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-B',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-C',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-D',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-E',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-F',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-G',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-H',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-I',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-J',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-K',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-L',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-M',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-N',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-O',1,'dsamaddar'
exec spInsertBlocks 'KNITTING WORKER-P',1,'dsamaddar'

exec spInsertBlocks 'Cleaner ',1,'dsamaddar'
exec spInsertBlocks 'Electric',1,'dsamaddar'
exec spInsertBlocks 'Finishing (Staff)',1,'dsamaddar'
exec spInsertBlocks 'Helper (worker)',1,'dsamaddar'
exec spInsertBlocks 'Iron (Worker)',1,'dsamaddar'
exec spInsertBlocks 'Jaquerd',1,'dsamaddar'
exec spInsertBlocks 'Knitting (Staff)',1,'dsamaddar'
exec spInsertBlocks 'Light check(worker)',1,'dsamaddar'
exec spInsertBlocks 'Linking  (Worker)',1,'dsamaddar'
exec spInsertBlocks 'Linking (Staff)',1,'dsamaddar'
exec spInsertBlocks 'Loader',1,'dsamaddar'
exec spInsertBlocks 'Mending (Staff)',1,'dsamaddar'
exec spInsertBlocks 'Mending (worker)',1,'dsamaddar'
exec spInsertBlocks 'Office Staff',1,'dsamaddar'
exec spInsertBlocks 'Overlock (worker)',1,'dsamaddar'
exec spInsertBlocks 'Packing (Worker)',1,'dsamaddar'
exec spInsertBlocks 'PQC (Worker)',1,'dsamaddar'
exec spInsertBlocks 'Production (staff)',1,'dsamaddar'
exec spInsertBlocks 'Sample',1,'dsamaddar'
exec spInsertBlocks 'Sample Staff',1,'dsamaddar'
exec spInsertBlocks 'Security',1,'dsamaddar'
exec spInsertBlocks 'Sewing (Worker)',1,'dsamaddar'
exec spInsertBlocks 'Trimming (Staff)',1,'dsamaddar'
exec spInsertBlocks 'Trimming (worker)',1,'dsamaddar'
exec spInsertBlocks 'Wash (Worker)',1,'dsamaddar'
exec spInsertBlocks 'Winding (worker)',1,'dsamaddar'
exec spInsertBlocks 'Winding-Staff',1,'dsamaddar'

GO

alter proc spGetBlockList
as
begin

	Select BlockID,Block,BlockBangla from tblBlocks Where IsActive=1 ORder by Block

end

