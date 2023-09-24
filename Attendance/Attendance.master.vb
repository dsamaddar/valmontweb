
Partial Class Attendance_Attendance
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

                mnu = Me.FindControl("mnuAttendance")
                MenuIDs = Session("PermittedMenus")

                mnu.Items(0).Enabled = IIf(InStr(MenuIDs, "~att_dashboard"), True, False)
                mnu.Items(0).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~att_holidaySettings"), True, False)
                mnu.Items(0).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~att_nodeSettings"), True, False)
                mnu.Items(0).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~att_manualAtt"), True, False)
                mnu.Items(0).ChildItems(3).Enabled = IIf(InStr(MenuIDs, "~att_delAttRecord"), True, False)
                mnu.Items(0).ChildItems(4).Enabled = IIf(InStr(MenuIDs, "~att_attRectification"), True, False)
                mnu.Items(0).ChildItems(5).Enabled = IIf(InStr(MenuIDs, "~att_manLeaveApp"), True, False)
                mnu.Items(0).ChildItems(6).Enabled = IIf(InStr(MenuIDs, "~att_manLeaveAppMul"), True, False)
                mnu.Items(0).ChildItems(7).Enabled = IIf(InStr(MenuIDs, "~att_noWorkDay"), True, False)

                mnu.Items(1).Enabled = IIf(InStr(MenuIDs, "~att_retAttLog"), True, False)
                mnu.Items(2).Enabled = IIf(InStr(MenuIDs, "~att_attReport"), True, False)
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

