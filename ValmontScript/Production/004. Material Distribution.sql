
Insert Into tblAppSettings(PropertyName,PropertyValue) Values('CurrentMaterialDistID',0);

GO

-- drop table tblMaterialDist
Create table tblMaterialDist(
MaterialDistID nvarchar(50) primary key,
DistNumber nvarchar(50) unique (DistNumber),
EmployeeID nvarchar(50) foreign key references tblEmployeeInfo(EmployeeID),
BuyerID nvarchar(50) foreign key references tblBuyer(BuyerID),
OrderID nvarchar(50) foreign key references tblOrder(OrderID),
StyleID nvarchar(50) foreign key references tblStyles(StyleID),
SizeID nvarchar(50) foreign key references tblSize(SizeID),
ColorID nvarchar(50) foreign key references tblColor(ColorID),
ComponentID nvarchar(50) foreign key references tblComponents(ComponentID),
Rate numeric(18,5),
IssueQuantity numeric(18,2),
IssuePiece numeric(18,2),
IssueDate datetime,
IssueRemarks nvarchar(200),
IssueBy nvarchar(50),
IsReceived bit default 0,
ReceiveQuantity numeric(18,2),
ReceiveDate datetime,
ReceiveRemarks nvarchar(200),
ReceiveBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

alter proc spGetMaterialDistList
as
begin
	Select R.MaterialDistID,R.DistNumber,R.EmployeeID,E.EmployeeName+ ' ('+E.EmpCode+')' as 'EmployeeName',R.BuyerID,
	B.BuyerName,R.OrderID,O.OrderNumber,R.StyleID,S.Style,R.SizeID,SZ.Size,R.ColorID,
	C.ColorName,R.ComponentID,CP.ComponentName,R.Rate,R.IssueQuantity,R.IssuePiece,R.IssueRemarks,
	R.IssueBy,Convert(nvarchar,R.IssueDate,106) as 'IssueDate'
	from tblMaterialDist R
	left outer join tblEmployeeInfo E ON R.EmployeeID = E.EmployeeID
	left outer join tblBuyer B ON R.BuyerID = B.BuyerID
	left outer join tblOrder O ON R.OrderID = O.OrderID
	left outer join tblStyles S ON R.StyleID = S.StyleID
	left outer join tblSize SZ ON R.SizeID = SZ.SizeID
	left outer join tblColor C ON R.ColorID = C.ColorID
	left outer join tblComponents CP ON R.ComponentID = CP.ComponentID
	order by R.EmployeeID,R.BuyerID,R.OrderID,R.StyleID,R.SizeID,R.ColorID,R.ComponentID
end

GO

alter proc spGetMaterialDistListPending
as
begin
	Select R.MaterialDistID,R.DistNumber,R.EmployeeID,E.EmployeeName+ ' ('+E.EmpCode+')' as 'EmployeeName',R.BuyerID,
	B.BuyerName,R.OrderID,O.OrderNumber,R.StyleID,S.Style,R.SizeID,SZ.Size,R.ColorID,
	C.ColorName,R.ComponentID,CP.ComponentName,R.Rate,R.IssueQuantity,R.IssuePiece,R.IssueRemarks,
	R.IssueBy,Convert(nvarchar,R.IssueDate,106) as 'IssueDate'
	from tblMaterialDist R
	left outer join tblEmployeeInfo E ON R.EmployeeID = E.EmployeeID
	left outer join tblBuyer B ON R.BuyerID = B.BuyerID
	left outer join tblOrder O ON R.OrderID = O.OrderID
	left outer join tblStyles S ON R.StyleID = S.StyleID
	left outer join tblSize SZ ON R.SizeID = SZ.SizeID
	left outer join tblColor C ON R.ColorID = C.ColorID
	left outer join tblComponents CP ON R.ComponentID = CP.ComponentID
	Where R.IsReceived = 0
	order by R.EmployeeID,R.BuyerID,R.OrderID,R.StyleID,R.SizeID,R.ColorID,R.ComponentID
end

GO

Create function dbo.fnGetRate(@BuyerID nvarchar(50),@OrderID nvarchar(50),@StyleID nvarchar(50),
@SizeID nvarchar(50),@ColorID nvarchar(50),@ComponentID nvarchar(50))
returns numeric(18,5)
as
begin
	Declare @Rate as numeric(18,5) Set @Rate = 0;

	select @Rate = ISNULL(Rate,0) from tblRateSetup 
	Where 
	BuyerID=@BuyerID 
	and OrderID=@OrderID
	and StyleID=@StyleID
	and SizeID=@SizeID
	and ColorID=@ColorID
	and ComponentID=@ComponentID;
	
	return ISNULL(@Rate,0)
end

--select * from tblRateSetup
--select  dbo.fnGetRate('B-00000013','O-00000043','STL-00000047','SZ-00000019','C-00000003','CMP-00000001')

GO
-- exec spGetRate 'B-00000013','O-00000043','STL-00000047','SZ-00000019','C-00000003','CMP-00000001'
Create proc spGetRate
@BuyerID nvarchar(50),
@OrderID nvarchar(50),
@StyleID nvarchar(50),
@SizeID nvarchar(50),
@ColorID nvarchar(50),
@ComponentID nvarchar(50)
as
begin
	Select dbo.fnGetRate(@BuyerID,@OrderID,@StyleID,@SizeID,@ColorID,@ComponentID) as 'Rate';
end

GO

-- drop proc spIssueMaterial
alter proc spIssueMaterial
@EmployeeID nvarchar(50),
@BuyerID nvarchar(50),
@OrderID nvarchar(50),
@StyleID nvarchar(50),
@SizeID nvarchar(50),
@ColorID nvarchar(50),
@ComponentID nvarchar(50),
@Rate numeric(18,5),
@IssueQuantity numeric(18,2),
@IssuePiece numeric(18,2),
@IssueDate datetime,
@IssueRemarks nvarchar(200),
@IssueBy nvarchar(50)
as
begin
	Declare @MaterialDistID nvarchar(50)
	Declare @CurrentMaterialDistID numeric(18,0)
	Declare @MaterialDistIDPrefix as nvarchar(5)

	set @MaterialDistIDPrefix='DIST-'

begin tran
	
	select @CurrentMaterialDistID = cast(PropertyValue as numeric(18,0)) from tblAppSettings where  PropertyName='CurrentMaterialDistID';
	
	set @CurrentMaterialDistID=isnull(@CurrentMaterialDistID,0)+1
	Select @MaterialDistID=dbo.generateID(@MaterialDistIDPrefix,@CurrentMaterialDistID,8)		
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

	Insert Into tblMaterialDist(MaterialDistID,DistNumber,EmployeeID,BuyerID,OrderID,StyleID,SizeID,ColorID,
	ComponentID,Rate,IssueQuantity,IssuePiece,IssueDate,IssueRemarks,IssueBy)
	Values(@MaterialDistID,RIGHT(@MaterialDistID,8),@EmployeeID,@BuyerID,@OrderID,@StyleID,@SizeID,@ColorID,
	@ComponentID,@Rate,@IssueQuantity,@IssuePiece,@IssueDate,@IssueRemarks,@IssueBy)
	
	update tblAppSettings set PropertyValue=@CurrentMaterialDistID where PropertyName='CurrentMaterialDistID'
	IF (@@ERROR <> 0) GOTO ERR_HANDLER

COMMIT TRAN
RETURN 0

ERR_HANDLER:
ROLLBACK TRAN
RETURN 1
end

select * from tblMaterialDist

GO

alter proc spReceiveMaterial
@MaterialDistID nvarchar(50),
@ReceiveQuantity numeric(18,2),
@ReceiveDate datetime,
@ReceiveRemarks nvarchar(200),
@ReceiveBy nvarchar(50)
as
begin
	Update tblMaterialDist Set IsReceived = 1, ReceiveQuantity = @ReceiveQuantity,
	ReceiveDate = @ReceiveDate, ReceiveRemarks = @ReceiveRemarks,ReceiveBy = @ReceiveBy
	Where MaterialDistID = @MaterialDistID
end

