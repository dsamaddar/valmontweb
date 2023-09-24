
Partial Class Attendance_frmManageLeave
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim LDData As New clsLeaveDetails()

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

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim LD As New clsLeaveDetails()

        Try
            LD.EmployeeID = drpEmployeeList.SelectedValue
            LD.LeaveStartDate = Convert.ToDateTime(txtLeaveStarts.Text)
            LD.LeaveEndDate = Convert.ToDateTime(txtLeaveEnds.Text)

            Dim result As clsResult = LDData.fnInsertLeaveDetails(LD)

            If result.Success = True Then
                ClearForm()
            End If

            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_manLeaveApp") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            GetEmployeeList()
        End If
    End Sub

    Protected Sub drpEmployeeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpEmployeeList.SelectedIndexChanged
        GetLeaveDetails(drpEmployeeList.SelectedValue)
    End Sub

    Protected Sub GetLeaveDetails(ByVal EmployeeID As String)
        grdLeaveDetails.DataSource = LDData.fnGetLeaveDetails(EmployeeID)
        grdLeaveDetails.DataBind()
    End Sub

    Protected Sub grdLeaveDetails_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdLeaveDetails.RowDeleting
        Dim lblLeaveDetailID As New Label
        lblLeaveDetailID = grdLeaveDetails.Rows(e.RowIndex).FindControl("lblLeaveDetailID")

        Dim Check As Integer = LDData.fnDeleteLeaveDetails(lblLeaveDetailID.Text)

        If Check = 1 Then
            MessageBox("Holiday Deleted.")
            GetLeaveDetails(drpEmployeeList.SelectedValue)
        Else
            MessageBox("Error Found.")
        End If
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub ClearForm()
        txtLeaveStarts.Text = ""
        txtLeaveEnds.Text = ""
    End Sub

End Class
