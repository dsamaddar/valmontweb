
Partial Class frmLogin
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        Try
            Dim EmpInfo As New clsEmployee()

            EmpInfo.AccessModule = drpModule.SelectedValue
            EmpInfo.UserID = txtUserID.Text
            EmpInfo.UserPassword = txtUserPassword.Text

            EmpInfo = EmpData.fnLogin(EmpInfo)

            If EmpInfo.EmployeeName = "" Then
                MessageBox("Login Problem: Password Mismatch | Permission Denied")
                Exit Sub
            End If

            Session("LoginUserID") = EmpInfo.UserID
            Session("PermittedMenus") = EmpInfo.PermittedMenu
            Session("EmployeeName") = EmpInfo.EmployeeName
            Session("UniqueUserID") = EmpInfo.EmployeeID
            Session("EmployeeID") = EmpInfo.EmployeeID

            If drpModule.SelectedValue = "Administration" Then
                Response.Redirect("~\Administration\frmAdminDashBoard.aspx")
            ElseIf drpModule.SelectedValue = "Attendance" Then
                Response.Redirect("~\Attendance\frmAttendanceDashBoard.aspx")
            ElseIf drpModule.SelectedValue = "Inventory" Then
                Response.Redirect("~\Inventory\frmInventoryDashBoard.aspx")
            ElseIf drpModule.SelectedValue = "Security" Then
                If Session("LoginUserID") <> "mamun" Then
                    MessageBox("Not Permitted")
                    Exit Sub
                End If
                Response.Redirect("~\Security\frmSecurityDashBoard.aspx")
            ElseIf drpModule.SelectedValue = "Production" Then
                Response.Redirect("~\Production\frmProductionDashBoard.aspx")
            ElseIf drpModule.SelectedValue = "Accounting" Then
                Response.Redirect("~\Accounting\frmAccountingDashBoard.aspx")
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
