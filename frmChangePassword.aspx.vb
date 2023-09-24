
Partial Class frmChangePassword
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()

    Protected Sub btnChangePassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChangePassword.Click
        Try
            Dim EmpInfo As New clsEmployee()
            Dim result As New clsResult()

            If txtUserID.Text = "" Or txtCurrentPassword.Text = "" Or txtNewPassword.Text = "" Or txtNewPasswordConfirm.Text = "" Then
                MessageBox("All Fields are Mandatory")
                Exit Sub
            End If

            If txtNewPassword.Text <> txtNewPasswordConfirm.Text Then
                MessageBox("New Password & Confirm Password Should be Same")
                Exit Sub
            End If

            EmpInfo.UserID = txtUserID.Text
            EmpInfo.UserPassword = txtCurrentPassword.Text
            EmpInfo.NewPassword = txtNewPassword.Text

            result = EmpData.fnChangePassword(EmpInfo)

            MessageBox(result.Message)
            If result.Success = True Then
                Response.Redirect("frmLogin.aspx")
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

End Class
