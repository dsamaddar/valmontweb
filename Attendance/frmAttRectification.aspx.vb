
Partial Class Attendance_frmAttRectification
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim AttData As New clsUserAttendance()

    Protected Sub btnRunRectification_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRunRectification.Click
        Try
            If rdbtnShiftType.SelectedIndex = -1 Then
                MessageBox("Select Shifting Type Morning/Evening")
                Exit Sub
            End If

            If drpEmployeeList.SelectedValue = "N/A" Then
                MessageBox("Select An Employee First.")
                Exit Sub
            End If

            Dim UsrAtt As New clsUserAttendance()
            UsrAtt.EmployeeID = drpEmployeeList.SelectedValue
            UsrAtt.DateFrom = Convert.ToDateTime(txtStartDate.Text)
            UsrAtt.DateTo = Convert.ToDateTime(txtEndDate.Text)
            UsrAtt.ShiftType = rdbtnShiftType.SelectedValue
            Dim check As Integer = AttData.fnMaintainShiftDuty(UsrAtt)

            If check = 1 Then
                MessageBox("Rectification Done.")
            Else
                MessageBox("Error Found.")
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
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_attRectification") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            GetEmployeeList()
        End If
    End Sub

    Protected Sub GetEmployeeList()
        drpEmployeeList.DataValueField = "EmployeeID"
        drpEmployeeList.DataTextField = "EmployeeName"
        drpEmployeeList.DataSource = EmpData.fnGetShiftingEmployee()
        drpEmployeeList.DataBind()

        Dim A As New ListItem
        A.Text = "N/A"
        A.Value = "N/A"
        drpEmployeeList.Items.Insert(0, A)
    End Sub

End Class
