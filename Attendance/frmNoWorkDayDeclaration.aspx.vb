
Partial Class Attendance_frmNoWorkDayDeclaration
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim LDData As New clsLeaveDetails()
    Dim SecData As New clsSection()
    Dim NoWorkDayData As New clsNoWorkDay()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_noWorkDay") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            ShowSectionList()
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

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub drpSections_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSections.SelectedIndexChanged
        Try
            grdEmpList.DataSource = EmpData.fnGetEmpListBySectionID(drpSections.SelectedValue)
            grdEmpList.DataBind()
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
        Dim NoWorkDay As New clsNoWorkDay()
        Dim chkItems As CheckBox
        Dim ErrorMessage As String = ""
        Dim lblEmployeeID As New Label
        Try
            For Each row As GridViewRow In grdEmpList.Rows
                chkItems = row.FindControl("chkItems")
                If chkItems.Checked = True Then
                    lblEmployeeID = row.FindControl("lblEmployeeID")
                    NoWorkDay.EmployeeID = lblEmployeeID.Text
                    NoWorkDay.NoWorkDayStartDate = Convert.ToDateTime(txtLeaveStarts.Text)
                    NoWorkDay.NoWorkDayEndDate = Convert.ToDateTime(txtLeaveEnds.Text)

                    Dim result As clsResult = NoWorkDayData.fnInsertNoWorkDays(NoWorkDay)

                    If result.Success = False Then
                        ErrorMessage &= result.Message
                    End If
                End If
            Next
            MessageBox(ErrorMessage)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetNoWorkDayDetails(ByVal EmployeeID As String)
        Try
            grdNoWorkDays.DataSource = NoWorkDayData.fnGetNoWorkDayByEmpID(EmployeeID)
            grdNoWorkDays.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub grdNoWorkDays_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdNoWorkDays.RowDeleting
        Dim lblNoWorkDayID As New Label
        lblNoWorkDayID = grdNoWorkDays.Rows(e.RowIndex).FindControl("lblNoWorkDayID")

        Dim Check As Integer = NoWorkDayData.fnDeleteNoWorkDay(lblNoWorkDayID.Text)

        If Check = 1 Then
            MessageBox("No Work Day Deleted.")
            GetNoWorkDayDetails(drpEmployeeList.SelectedValue)
        Else
            MessageBox("Error Found.")
        End If
    End Sub

    Protected Sub drpEmployeeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpEmployeeList.SelectedIndexChanged
        GetNoWorkDayDetails(drpEmployeeList.SelectedValue)
    End Sub

End Class
