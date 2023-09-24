
GO

Select V.VoucherNo,V.EventName,V.TransactionDate,V.Narration,LT.LedgerType,C.LedgerName,VD.TransactionType,VD.Debit,VD.Credit
	from tblVoucher V INNER JOIN tblVoucherDetails VD ON V.VoucherID = VD.VoucherID
	INNER JOIN tblChartOfAccounts C ON VD.LedgerID = C.LedgerID
	INNER JOIN tblLedgerType LT ON C.LedgerTypeID = LT.LedgerTypeID
	Where V.IsApproved=1 And V.TransactionDate >= @StartDate And V.TransactionDate <= @EndDate

GO

alter proc spRptBalanceSheet
@StartDate date,
@EndDate date
as
begin
	Select V.VoucherNo,V.EventName,V.TransactionDate,V.Narration,LT.LedgerType,C.LedgerName,VD.TransactionType,VD.Debit,VD.Credit
	from tblVoucher V INNER JOIN tblVoucherDetails VD ON V.VoucherID = VD.VoucherID
	INNER JOIN tblChartOfAccounts C ON VD.LedgerID = C.LedgerID
	INNER JOIN tblLedgerType LT ON C.LedgerTypeID = LT.LedgerTypeID
	Where V.IsApproved=1 And V.TransactionDate >= @StartDate And V.TransactionDate <= @EndDate
end

exec spRptBalanceSheet '1/1/2018','3/25/2018'