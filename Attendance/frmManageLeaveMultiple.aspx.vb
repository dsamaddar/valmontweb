
Partial Class Attendance_frmManageLeaveMultiple
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim LDData As New clsLeaveDetails()
    Dim SecData As New clsSection()


    Protected Sub ShowSectionList()
        Try
            drpSections.DataTextField = "Section"
            drpSections.DataValueField = "SectionID"
            drpSections.DataSource = SecData.fnGetSectionList()
            drpSections.DataBind()

            Dim A As New ListItem
            A.Text = "ALL"
            A.Value = "ALL"

            drpSections.Items.Insert(0, A)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub chkSelectAll_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim chkSelectAll, chkItems As CheckBox

        Try
            chkSelectAll = grdEmpList.HeaderRow.FindControl("chkSelectAll")

            If chkSelectAll.Checked = True Then
                For Each row As GridViewRow In grdEmpList.Rows
                    chkItems = row.FindControl("chkItems")
                    chkItems.Checked = True
                Next
            Else
                For Each row As GridViewRow In grdEmpList.Rows
                    chkItems = row.FindControl("chkItems")
                    chkItems.Checked = False
                Next
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim LD As New clsLeaveDetails()
        Dim chkItems As CheckBox
        Dim ErrorMessage As String = ""
        Dim lblEmployeeID As New Label
        Try
            For Each row As GridViewRow In grdEmpList.Rows
                chkItems = row.FindControl("chkItems")
                If chkItems.Checked = True Then
                    lblEmployeeID = row.FindControl("lblEmployeeID")
                    LD.EmployeeID = lblEmployeeID.Text
                    LD.LeaveStartDate = Convert.ToDateTime(txtLeaveStarts.Text)
                    LD.LeaveEndDate = Convert.ToDateTime(txtLeaveEnds.Text)

                    Dim result As clsResult = LDData.fnInsertLeaveDetails(LD)

                    If result.Success = False Then
                        ErrorMessage &= result.Message
                    End If
                End If
            Next
            MessageBox(ErrorMessage)
            ClearForm()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_manLeaveAppMul") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            ShowSectionList()
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

    Protected Sub ClearForm()
        txtLeaveStarts.Text = ""
        txtLeaveEnds.Text = ""
    End Sub

    Protected Sub drpSections_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSections.SelectedIndexChanged
        Try
            grdEmpList.DataSource = EmpData.fnGetEmpListBySectionID(drpSections.SelectedValue)
            grdEmpList.DataBind()
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
