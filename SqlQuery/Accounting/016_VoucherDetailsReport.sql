
GO

Select * from tblInvoicePaymentHistory 

Select * from tblSupplier

GO

Select * from tblInvoices 

GO

alter proc spGetUnPrintedInvVoucher
as
begin
	Select Distinct IP.InvPmntHistoryID,IP.InvoiceID,I.InvoiceNo,(Select SupplierName from tblSupplier S Where S.SupplierID=I.SupplierID ) as 'Supplier',
	Convert(nvarchar,PaymentDate,106) as 'PaymentDate',IP.PaymentAmount,IP.PaymentMode,IP.VoucherNo
	from tblInvoicePaymentHistory IP Inner Join tblInvoices I On I.InvoiceID=IP.InvoiceID
	Where IsVoucherPrinted=0
end

GO

exec spGetUnPrintedInvVoucher

GO

alter proc spInvVoucherPrint
@VoucherNo nvarchar(50)
as
begin

	Update tblInvoicePaymentHistory Set IsVoucherPrinted=1 Where VoucherNo=@VoucherNo

	Select Convert(nvarchar,V.TransactionDate,106) as 'TransactionDate',V.Event,VD.VoucherNo,VD.EntryNo,VD.AccountCode,COA.LedgerName,VD.Debit,VD.Credit 
	from tblVoucherDetails VD Left Join tblChartOfAccounts COA 
	On VD.AccountCode=COA.LedgerCode Left Join tblVoucher V On V.VoucherNo=VD.VoucherNo
	Where VD.VoucherNo=@VoucherNo
end

-- exec spInvVoucherPrint '2013080600000014'

GO

alter proc spRptInvoiceTrans
@InvoiceID nvarchar(50)
as
begin
	Select Convert(nvarchar,V.TransactionDate,106) as 'TransactionDate',V.Event,VD.VoucherNo,VD.EntryNo,VD.AccountCode,COA.LedgerName,VD.Debit,VD.Credit 
	from tblVoucherDetails VD Left Join tblChartOfAccounts COA 
	On VD.AccountCode=COA.LedgerCode Left Join tblVoucher V On V.VoucherNo=VD.VoucherNo
	And VD.Reference=@InvoiceID
end

GO

exec spRptInvoiceTrans 'INV-00000009'

GO


