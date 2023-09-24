
Partial Class Production_Production
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
                Dim mnu As New Menu
                Dim MenuIDs As String

                mnu = Me.FindControl("mnuProduction")
                MenuIDs = Session("PermittedMenus")

                mnu.Items(0).Enabled = IIf(InStr(MenuIDs, "~prod_issuematerial"), True, False)
                mnu.Items(1).Enabled = IIf(InStr(MenuIDs, "~prod_receivemateiral"), True, False)
                mnu.Items(2).Enabled = IIf(InStr(MenuIDs, "~prod_reports"), True, False)
                mnu.Items(2).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~prod_materialreport"), True, False)
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

