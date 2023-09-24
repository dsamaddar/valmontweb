
Partial Class Accounting_Accounting
    Inherits System.Web.UI.MasterPage

    Protected Sub lnkBtnLogOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBtnLogOut.Click
        Session("UniqueUserID") = ""
        Session("EmployeeName") = ""
        Session("LoginUserID") = ""
        Session("PermittedMenus") = ""
        Response.Redirect("~\frmLogin.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                lblLoggedInUser.Text = "Welcome " + Session("EmployeeName")
            Catch ex As Exception
                MessageBox(ex.Message)
            End Try
        End If
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

End Class

