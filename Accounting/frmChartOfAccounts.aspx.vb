
Partial Class Accounting_frmChartOfAccounts
    Inherits System.Web.UI.Page

    Dim LedgerTypeData As New clsLedgerType()
    Dim LedgerData As New clsLedger()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Dim MenuIDs As String

        'MenuIDs = Session("PermittedMenus")

        'If InStr(MenuIDs, "COA~") = 0 Then
        '    Response.Redirect("~\frmAILogin.aspx")
        'End If


        If Not IsPostBack Then
            GetAvailableLedgerType()
            Session("LoginUserID") = "dsamaddar"
            GetLedgerHeadList()
        End If
    End Sub

    Protected Sub ClearLedgerType()
        txtLedgerType.Text = ""
        drpAvailableLedgerType.SelectedIndex = -1
    End Sub

    Protected Sub GetAvailableLedgerType()
        drpAvailableLedgerType.DataTextField = "LedgerType"
        drpAvailableLedgerType.DataValueField = "LedgerTypeID"
        drpAvailableLedgerType.DataSource = LedgerTypeData.fnGetLedgerTypeList()
        drpAvailableLedgerType.DataBind()

        drpSelectLedgerType.DataTextField = "LedgerType"
        drpSelectLedgerType.DataValueField = "LedgerTypeID"
        drpSelectLedgerType.DataSource = LedgerTypeData.fnGetLedgerTypeList()
        drpSelectLedgerType.DataBind()

    End Sub

    Protected Sub GetLedgerHeadList()
        drpParentLedger.DataTextField = "LedgerName"
        drpParentLedger.DataValueField = "LedgerID"
        drpParentLedger.DataSource = LedgerData.fnGetLedgerHeadList()
        drpParentLedger.DataBind()

        Dim A As New ListItem()
        A.Text = "N\A"
        A.Value = "N\A"

        drpParentLedger.Items.Insert(0, A)

    End Sub

    Protected Sub btnInsertLedgerType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertLedgerType.Click
        Dim LedgerType As New clsLedgerType()

        LedgerType.LedgerType = txtLedgerType.Text
        LedgerType.EntryBy = Session("LoginUserID")

        Dim Result As clsResult = LedgerTypeData.fnInsertLedgerType(LedgerType)

        If Result.Success = True Then
            MessageBox(Result.Message)
            GetAvailableLedgerType()
            ClearLedgerType()
            GetLedgerHeadList()
        Else
            MessageBox(Result.Message)
        End If

    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnCancelLedgerType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelLedgerType.Click

    End Sub

    Protected Sub btnInsertLedgerName_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertLedgerName.Click

        Dim Ledger As New clsLedger()

        Ledger.LedgerTypeID = drpSelectLedgerType.SelectedValue
        Ledger.LedgerName = txtLedgerName.Text
        Ledger.ParentLedgerID = drpParentLedger.SelectedValue
        Ledger.LedgerCode = txtLedgerCode.Text
        Ledger.IsBankAccount = IIf(chkIsBankAccount.Checked = True, True, False)
        Ledger.BalanceType = drpBalanceType.SelectedValue
        Ledger.EntryBy = Session("LoginUserID")
        Dim Result As clsResult = LedgerData.fnInsertLedger(Ledger)

        If Result.Success = True Then
            ClearForm()
            GetLedgerHeadList()
        End If

        MessageBox(Result.Message)


    End Sub

    Protected Sub ClearForm()
        txtLedgerName.Text = ""
        txtLedgerCode.Text = ""
        drpBalanceType.SelectedIndex = -1
        drpParentLedger.SelectedIndex = -1
        drpSelectLedgerType.SelectedIndex = -1
    End Sub

    Protected Sub btnCancelLedgerName_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelLedgerName.Click

    End Sub
End Class
