
Partial Class Administration_frmSalaryReversal
    Inherits System.Web.UI.Page

    Dim SalaryData As New clsSalarySetup()

    Protected Sub btnReverseSalary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReverseSalary.Click
        Try
            If drpEntryPoint.Items.Count = 0 Then
                MessageBox("No Entry Point to Reverse.")
                Exit Sub
            End If

            Dim result As New clsResult()
            result = SalaryData.fnReverseSalary(drpEntryPoint.SelectedValue)
            MessageBox(result.Message)

            If result.Success = True Then
                GetEntryPoints()
            End If

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            drpSalaryYear.SelectedValue = Now.Year.ToString()
            drpSalaryMonth.SelectedValue = Now.Month.ToString()
            GetEntryPoints()
        End If
    End Sub

    Protected Sub GetEntryPoints()
        Try
            drpEntryPoint.DataTextField = "value"
            drpEntryPoint.DataValueField = "id"
            drpEntryPoint.DataSource = SalaryData.fnGetEntryPoints(drpSalaryYear.SelectedValue, drpSalaryMonth.SelectedValue)
            drpEntryPoint.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub drpSalaryMonth_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSalaryMonth.SelectedIndexChanged
        GetEntryPoints()
    End Sub
End Class
