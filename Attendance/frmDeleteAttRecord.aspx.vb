
Partial Class Attendance_frmDeleteAttRecord
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim AttData As New clsUserAttendance()

    Protected Sub grdAttRecord_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdAttRecord.RowDeleting
        Try
            Dim lblUserAttendanceID As New Label
            lblUserAttendanceID = grdAttRecord.Rows(e.RowIndex).FindControl("lblUserAttendanceID")

            Dim check As Integer = AttData.fnDeleteAttRecord(lblUserAttendanceID.Text)

            If check = 1 Then
                MessageBox("Marked as Deleted.")
                GetAttRecordByEmp(drpEmployeeList.SelectedValue)
            Else
                MessageBox("Error Found.")
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_delAttRecord") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            GetEmployeeList()
        End If
    End Sub

    Protected Sub GetEmployeeList()
        drpEmployeeList.DataValueField = "EmployeeID"
        drpEmployeeList.DataTextField = "EmployeeName"
        drpEmployeeList.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpEmployeeList.DataBind()

        Dim A As New ListItem
        A.Text = "ALL"
        A.Value = "ALL"

        drpEmployeeList.Items.Insert(0, A)
    End Sub

    Protected Sub GetAttRecordByEmp(ByVal EmployeeID As String)
        Try
            grdAttRecord.DataSource = AttData.fnGetAttRecordByEmpID(EmployeeID)
            grdAttRecord.DataBind()
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

    Protected Sub drpEmployeeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpEmployeeList.SelectedIndexChanged
        Try
            GetAttRecordByEmp(drpEmployeeList.SelectedValue)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub grdAttRecord_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles grdAttRecord.RowUpdating
        Try
            Dim lblUserAttendanceID As New Label
            lblUserAttendanceID = grdAttRecord.Rows(e.RowIndex).FindControl("lblUserAttendanceID")

            Dim check As Integer = AttData.fnActivateAttRecord(lblUserAttendanceID.Text)

            If check = 1 Then
                MessageBox("Marked as Deleted.")
                GetAttRecordByEmp(drpEmployeeList.SelectedValue)
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
