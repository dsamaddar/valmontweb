
Partial Class Attendance_frmLeaveException
    Inherits System.Web.UI.Page

    Dim LeaveExpData As New clsLeaveException()
    Dim ComLeaveData As New clsCompensatoryLeave()

    Protected Sub GetLeaveExceptionList()
        grdLeaveExceptionList.DataSource = LeaveExpData.fnGetLeaveExceptionList()
        grdLeaveExceptionList.DataBind()
    End Sub

    Protected Sub GetCompensatoryLeaveList()
        grdCompensatoryLeaveList.DataSource = ComLeaveData.fnGetCompensatoryLeaveList()
        grdCompensatoryLeaveList.DataBind()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        ClearLeaveException()
    End Sub

    Protected Sub ClearLeaveException()
        txtLeaveExpDate.Text = ""
        txtPurpose.Text = ""
    End Sub

    Protected Sub ClearCompensatoryLeave()
        txtCompLeavePurpose.Text = ""
        txtComLeaveDt.Text = ""
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

        If InStr(MenuIDs, "~att_holidaySettings") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            GetLeaveExceptionList()
            GetCompensatoryLeaveList()
        End If
    End Sub

    Protected Sub grdLeaveExceptionList_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdLeaveExceptionList.RowDeleting
        Dim lblExceptionID As New Label
        lblExceptionID = grdLeaveExceptionList.Rows(e.RowIndex).FindControl("lblExceptionID")

        Dim Check As Integer = LeaveExpData.fnDeleteLeaveException(lblExceptionID.Text)

        If Check = 1 Then
            MessageBox("Leave Exception Deleted.")
            GetLeaveExceptionList()
        Else
            MessageBox("Error Found.")
        End If

    End Sub


    Protected Sub btnInputExp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInputExp.Click
        Try

            Dim exp As New clsLeaveException()

            exp.ExceptionDate = txtLeaveExpDate.Text

            exp.Remarks = txtPurpose.Text

            Dim Check As Integer = LeaveExpData.fnInsertExceptions(exp)
            If Check = 1 Then
                MessageBox("Leave Exception Inserted.")
                ClearLeaveException()
                GetLeaveExceptionList()
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnInsertCompLeave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertCompLeave.Click
        Try

            Dim com As New clsCompensatoryLeave()

            com.CompensatoryDate = txtComLeaveDt.Text

            com.Remarks = txtCompLeavePurpose.Text

            Dim Check As Integer = ComLeaveData.fnInsertCompensatoryLeave(com)
            If Check = 1 Then
                MessageBox("Compensatory Leave Inserted.")
                ClearCompensatoryLeave()
                GetCompensatoryLeaveList()
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub grdCompensatoryLeaveList_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdCompensatoryLeaveList.RowDeleting
        Dim lblCompensatoryLeaveID As New Label
        lblCompensatoryLeaveID = grdCompensatoryLeaveList.Rows(e.RowIndex).FindControl("lblCompensatoryLeaveID")

        Dim Check As Integer = ComLeaveData.fnDeleteCompensatoryLeave(lblCompensatoryLeaveID.Text)

        If Check = 1 Then
            MessageBox("Compensatory Leave Deleted.")
            GetCompensatoryLeaveList()
        Else
            MessageBox("Error Found.")
        End If

    End Sub
End Class
