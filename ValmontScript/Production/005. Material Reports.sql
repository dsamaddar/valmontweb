
go

alter proc spRptMaterialIssue
@IssueDateFrom date,
@IssueDateTo date
as
begin
	Declare @IssueDateStart as datetime
	Declare @IssueDateEnds as datetime
	
	SET @IssueDateStart = convert(datetime, convert(nvarchar,@IssueDateFrom,106) + ' 12:00:00 AM')
	SET @IssueDateEnds = convert(datetime,convert(nvarchar,@IssueDateTo,106) + ' 11:59:59 PM')

	select d.DistNumber,e.EmployeeName as employee,b.BuyerName as buyer,
	o.OrderNumber,s.Style,z.Size,c.ColorName as color,co.ComponentName as component,
	d.rate,d.IssueQuantity,d.IssuePiece,d.IssueDate,d.IssueBy
	from tblMaterialDist d
	inner join tblEmployeeInfo e on d.EmployeeID = e.EmployeeID
	inner join tblBuyer b on d.BuyerID = b.BuyerID
	inner join tblOrder o on d.OrderID = o.OrderID
	inner join tblStyles s on d.StyleID = s.StyleID
	inner join tblSize z on d.SizeID = z.SizeID
	inner join tblColor c on d.ColorID = c.ColorID
	inner join tblComponents co on d.ComponentID = co.ComponentID
	Where d.IssueDate between @IssueDateStart and @IssueDateEnds
end

go

-- exec spRptMaterialIssue '07/07/2019','07/31/2019'

go

alter proc spRptMaterialReceive
@ReceiveDateFrom datetime,
@ReceiveDateTo datetime
as
begin
	Declare @ReceiveDateStart as datetime
	Declare @ReceiveDateEnds as datetime

	SET @ReceiveDateStart = convert(datetime, convert(nvarchar,@ReceiveDateFrom,106) + ' 12:00:00 AM')
	SET @ReceiveDateEnds = convert(datetime,convert(nvarchar,@ReceiveDateTo,106) + ' 11:59:59 PM')

	select d.DistNumber,e.EmployeeName as employee,b.BuyerName as buyer,
	o.OrderNumber,s.Style,z.Size,c.ColorName as color,co.ComponentName as component,
	d.rate,d.IssueQuantity,d.IssueDate,d.ReceiveQuantity,d.ReceiveDate,d.ReceiveBy
	from tblMaterialDist d
	inner join tblEmployeeInfo e on d.EmployeeID = e.EmployeeID
	inner join tblBuyer b on d.BuyerID = b.BuyerID
	inner join tblOrder o on d.OrderID = o.OrderID
	inner join tblStyles s on d.StyleID = s.StyleID
	inner join tblSize z on d.SizeID = z.SizeID
	inner join tblColor c on d.ColorID = c.ColorID
	inner join tblComponents co on d.ComponentID = co.ComponentID
	Where d.ReceiveDate between @ReceiveDateStart and @ReceiveDateEnds
end

-- exec spRptMaterialReceive '12/13/2019','12/13/2019'
