
Partial Class Accounting_frmJVApproval
    Inherits System.Web.UI.Page

    Dim VoucherData As New clsVoucher()
    Dim VoucherDetailsData As New clsVoucherDetails()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetPendingTransactions()
            btnApprove.Enabled = False
            btnReject.Enabled = False
        End If
    End Sub

    Protected Sub GetPendingTransactions()
        grdPendingTransactions.DataSource = VoucherData.fnGetPendingTransactions()
        grdPendingTransactions.DataBind()
    End Sub

    Protected Sub btnApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApprove.Click
        Try
            Dim Voucher As New clsVoucher()
            Dim lblVoucherID As Label

            lblVoucherID = grdPendingTransactions.SelectedRow.FindControl("lblVoucherID")
            Voucher.VoucherID = lblVoucherID.Text
            Voucher.EntryBy = Session("LoginUserID")
            Voucher.Narration = txtNarration.Text
            Voucher.VoucherStatus = "A"

            Dim result As clsResult = Voucher.fnAuthorizeTransaction(Voucher)

            If result.Success = True Then
                GetPendingTransactions()
                ClearForm()
            End If

            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        btnApprove.Enabled = False
        btnReject.Enabled = False

        grdTransactionDetails.DataSource = ""
        grdTransactionDetails.DataBind()
    End Sub

    Protected Sub btnReject_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReject.Click
        Try
            Dim Voucher As New clsVoucher()
            Dim lblVoucherID As Label

            lblVoucherID = grdPendingTransactions.SelectedRow.FindControl("lblVoucherID")
            Voucher.VoucherID = lblVoucherID.Text
            Voucher.EntryBy = Session("LoginUserID")
            Voucher.Narration = txtNarration.Text
            Voucher.VoucherStatus = "R"

            Dim result As clsResult = Voucher.fnAuthorizeTransaction(Voucher)

            If result.Success = True Then
                GetPendingTransactions()
                ClearForm()
            End If

            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub GetVoucherDetails(ByVal VoucherID As String)
        grdTransactionDetails.DataSource = VoucherDetailsData.fnGetTransactionDetails(VoucherID)
        grdTransactionDetails.DataBind()
    End Sub

    Protected Sub grdPendingTransactions_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdPendingTransactions.SelectedIndexChanged
        btnApprove.Enabled = True
        btnReject.Enabled = True
        Dim lblVoucherID As Label
        lblVoucherID = grdPendingTransactions.SelectedRow.FindControl("lblVoucherID")
        GetVoucherDetails(lblVoucherID.Text)
    End Sub

End Class
