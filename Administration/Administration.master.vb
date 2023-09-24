
Partial Class Valmont
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

                mnu = Me.FindControl("mnuAdmin")
                MenuIDs = Session("PermittedMenus")

                mnu.Items(0).Enabled = IIf(InStr(MenuIDs, "~adm_dashboard"), True, False)
                mnu.Items(0).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~adm_empinfo"), True, False)
                mnu.Items(0).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~adm_empreactivate"), True, False)
                mnu.Items(0).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~adm_secsettings"), True, False)
                mnu.Items(0).ChildItems(3).Enabled = IIf(InStr(MenuIDs, "~adm_designationsett"), True, False)
                mnu.Items(1).Enabled = IIf(InStr(MenuIDs, "~adm_printidcard"), True, False)
                mnu.Items(2).Enabled = IIf(InStr(MenuIDs, "~adm_updocuments"), True, False)

                mnu.Items(3).Enabled = IIf(InStr(MenuIDs, "~adm_productionmgt"), True, False)
                mnu.Items(3).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~adm_ratesetup"), True, False)
                mnu.Items(3).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~adm_buyerentry"), True, False)
                mnu.Items(3).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~adm_styleentry"), True, False)
                mnu.Items(3).ChildItems(3).Enabled = IIf(InStr(MenuIDs, "~adm_sizeentry"), True, False)
                mnu.Items(3).ChildItems(4).Enabled = IIf(InStr(MenuIDs, "~adm_colorentry"), True, False)
                mnu.Items(3).ChildItems(5).Enabled = IIf(InStr(MenuIDs, "~adm_componententry"), True, False)
                mnu.Items(3).ChildItems(6).Enabled = IIf(InStr(MenuIDs, "~adm_orderentry"), True, False)

                mnu.Items(4).Enabled = IIf(InStr(MenuIDs, "~adm_salarymgt"), True, False)
                mnu.Items(4).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~adm_salarysetup"), True, False)
                mnu.Items(4).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~adm_salaryprocess"), True, False)
                mnu.Items(4).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~adm_salaryreport"), True, False)
               
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

