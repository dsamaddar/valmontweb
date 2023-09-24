
/* Invoice Approval Ledger */

Create proc spInvAppTransaction
@InvoiceID nvarchar(50)
as
begin

	Declare @SupplierID nvarchar(50)
	Select @SupplierID=SupplierID  from tblInvoices where InvoiceID='INV-00000018'
	
	Select LedgerID from tblSupplier Where SupplierID =@SupplierID 

end