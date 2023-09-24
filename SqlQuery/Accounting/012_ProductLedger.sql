
-- drop table tblProductLedger
Create table tblProductLedger(
ProductID nvarchar(50) not null,
AccType nvarchar(50) not null,
LedgerID nvarchar(50) foreign key references tblChartOfAccounts(LedgerID),
primary key(ProductID,AccType)
);

GO

Insert into tblProductLedger(ProductID,AccType,LedgerID)Values('All','Payable','L-00000013')

GO

-- drop function fngetProductLedger
Create function fngetProductLedger(@ProductID nvarchar(50),@AccType nvarchar(50))
returns nvarchar(50)
as
begin
	declare @LedgerID as nvarchar(50)
	Declare @LedgerCode as nvarchar(50)
	Select @LedgerID=LedgerID from tblproductledger where ProductID=@ProductID and AccType=@AccType

	if isnull(@LedgerID,'')=''
		Select @LedgerID=LedgerID from tblproductledger where ProductID='All' and AccType=@AccType

	Select @LedgerCode=LedgerCode from tblChartOfAccounts Where LedgerID=@LedgerID
	return @LedgerCode
end

-- SElect dbo.fngetProductLedger('All','Payable')