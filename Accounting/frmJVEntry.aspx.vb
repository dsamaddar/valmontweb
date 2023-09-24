Imports System.Data

Partial Class Accounting_frmJVEntry
    Inherits System.Web.UI.Page

    Dim LedgerData As New clsLedger()
    Dim VoucherData As New clsVoucher()

    Protected Function FormatVoucherDetails() As DataTable
        Dim dt As DataTable = New DataTable()
        dt.Columns.Add("LedgerID", System.Type.GetType("System.String"))
        dt.Columns.Add("LedgerName", System.Type.GetType("System.String"))
        dt.Columns.Add("TransactionType", System.Type.GetType("System.String"))
        dt.Columns.Add("Debit", System.Type.GetType("System.Double"))
        dt.Columns.Add("Credit", System.Type.GetType("System.Double"))
        dt.Columns.Add("Reference", System.Type.GetType("System.String"))
        dt.Columns.Add("ReferenceType", System.Type.GetType("System.String"))
        Return dt
    End Function

    Protected Function AddVoucherDetails(ByVal VoucherDetails As clsVoucherDetails) As DataTable

        Dim dtVoucherDetails As DataTable = New DataTable()
        dtVoucherDetails = Session("dtVoucherDetails")

        '' Chq If Item Already Exists
        If ChqItemAlreadyExists(VoucherDetails.LedgerID) = 1 Then
            MessageBox("Ledger Already Exists In The List.")
            Return dtVoucherDetails
        End If

        Dim dr As DataRow
        dr = dtVoucherDetails.NewRow()
        dr("LedgerID") = VoucherDetails.LedgerID
        dr("LedgerName") = VoucherDetails.LedgerName
        dr("TransactionType") = VoucherDetails.TransactionType
        dr("Debit") = VoucherDetails.Debit
        dr("Credit") = VoucherDetails.Credit
        dr("Reference") = VoucherDetails.Reference
        dr("ReferenceType") = VoucherDetails.ReferenceType

        dtVoucherDetails.Rows.Add(dr)
        dtVoucherDetails.AcceptChanges()
        btnSubmit.Enabled = True
        Return dtVoucherDetails
    End Function

    Protected Function ChqItemAlreadyExists(ByVal LedgerID As String) As Integer

        Dim dtVoucherDetails As DataTable = New DataTable()
        dtVoucherDetails = Session("dtVoucherDetails")

        Dim IsExists As Boolean = False
        Dim ExistingItemID As String = ""

        For Each rw As DataRow In dtVoucherDetails.Rows
            ExistingItemID = rw.Item("LedgerID")

            If ExistingItemID = LedgerID Then
                IsExists = True
                Exit For
            End If
        Next

        If IsExists = True Then
            Return 1
        Else
            Return 0
        End If

    End Function

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnAddTransaction_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTransaction.Click
        Try
            If drpLedger.SelectedValue = "N\A" Then
                MessageBox("Select Proper Ledger First.")
                Exit Sub
            End If

            Dim VoucherDetails As New clsVoucherDetails()

            VoucherDetails.LedgerID = drpLedger.SelectedValue
            VoucherDetails.LedgerName = drpLedger.SelectedItem.ToString()

            If drpTransactionType.SelectedValue = "D" Then
                VoucherDetails.Debit = Convert.ToDouble(txtAmount.Text)
                VoucherDetails.Credit = 0
            Else
                VoucherDetails.Debit = 0
                VoucherDetails.Credit = Convert.ToDouble(txtAmount.Text)
            End If

            VoucherDetails.TransactionType = drpTransactionType.SelectedValue
            VoucherDetails.Reference = txtReference.Text
            VoucherDetails.ReferenceType = "Manual"

            Dim dtVoucherDetails As DataTable = New DataTable()
            dtVoucherDetails = AddVoucherDetails(VoucherDetails)
            Session("dtVoucherDetails") = dtVoucherDetails

            grdJVDetails.DataSource = dtVoucherDetails
            grdJVDetails.DataBind()
            GetGridSummary()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Session("dtVoucherDetails") = ""
            btnSubmit.Enabled = False

            Dim dtVoucherDetails As DataTable = New DataTable()
            dtVoucherDetails = FormatVoucherDetails()
            Session("dtVoucherDetails") = dtVoucherDetails

            txtVoucherDate.Text = Now.Date
            GetLedgerHeadList()
            txtVoucherNo.Text = VoucherData.fnGetCurrentVoucherNo()
        End If
    End Sub

    Protected Sub GetLedgerHeadList()
        drpLedger.DataTextField = "LedgerName"
        drpLedger.DataValueField = "LedgerID"
        drpLedger.DataSource = LedgerData.fnGetLedgerHeadList()
        drpLedger.DataBind()

        Dim A As New ListItem()
        A.Text = "N\A"
        A.Value = "N\A"

        drpLedger.Items.Insert(0, A)

    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Try
            Dim Voucher As New clsVoucher()

            Dim VoucherDetails As String = ""

            Dim lblLedgerID, lblTransactionType, lblDebit, lblCredit, lblReference As New System.Web.UI.WebControls.Label()
            For Each rw As GridViewRow In grdJVDetails.Rows
                lblLedgerID = rw.FindControl("lblLedgerID")
                lblTransactionType = rw.FindControl("lblTransactionType")
                lblDebit = rw.FindControl("lblDebit")
                lblCredit = rw.FindControl("lblCredit")
                lblReference = rw.FindControl("lblReference")

                VoucherDetails += lblLedgerID.Text & "~" & lblTransactionType.Text & "~" & Convert.ToDouble(lblDebit.Text) & "~" & Convert.ToDouble(lblCredit.Text) & "~" & lblReference.Text & "~|"
            Next

            Voucher.VoucherNo = txtVoucherNo.Text
            Voucher.EventName = "Manual Voucher"
            Voucher.Narration = txtNarration.Text
            Voucher.TransactionDate = Convert.ToDateTime(txtVoucherDate.Text)
            Voucher.SystemDate = Convert.ToDateTime(Now.Date)
            Voucher.VoucherDetails = VoucherDetails
            Voucher.EntryBy = Session("LoginUserID")

            Dim result As clsResult = Voucher.fnInsertVoucher(Voucher)

            If result.Success = True Then
                ClearForm()
            End If
            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        Session("dtVoucherDetails") = ""
        grdJVDetails.DataSource = ""
        grdJVDetails.DataBind()

        txtAmount.Text = ""
        txtNarration.Text = ""
        drpLedger.SelectedIndex = -1
        drpTransactionType.SelectedIndex = -1
    End Sub

    Protected Sub grdJVDetails_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdJVDetails.RowDeleting
        Dim i As Integer
        Dim dtVoucherDetails As DataTable = New DataTable()
        Try
            dtVoucherDetails = Session("dtVoucherDetails")

            i = e.RowIndex

            dtVoucherDetails.Rows(i).Delete()
            dtVoucherDetails.AcceptChanges()

            Session("dtVoucherDetails") = dtVoucherDetails

            grdJVDetails.DataSource = dtVoucherDetails
            grdJVDetails.DataBind()

            GetGridSummary()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetGridSummary()
        Dim lblDebit, lblCredit As Label
        Dim Debit As Double = 0
        Dim Credit As Double = 0

        Try
            For Each row As GridViewRow In grdJVDetails.Rows
                lblDebit = row.FindControl("lblDebit")
                lblCredit = row.FindControl("lblCredit")
                Debit += Convert.ToDouble(lblDebit.Text)
                Credit += Convert.ToDouble(lblCredit.Text)
            Next

            grdJVDetails.FooterRow.Cells(1).Text = "Total : "
            grdJVDetails.FooterRow.Cells(3).Text = Debit.ToString()
            grdJVDetails.FooterRow.Cells(4).Text = Credit.ToString()

            If Debit = Credit Then
                btnSubmit.Enabled = True
            Else
                btnSubmit.Enabled = False
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
