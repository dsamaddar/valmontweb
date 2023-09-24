
Partial Class Administration_frmReactivateEmployee
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        ClearSelection()
        Dim EmpInfo As New clsEmployee()
        Try
            EmpInfo.NameorID = txtNameorCode.Text
            EmpInfo.MobileNo = txtMobileNo.Text
            EmpInfo.NationalID = txtNationalID.Text

            grdEmpList.DataSource = EmpData.fnSearchInActiveEmployee(EmpInfo)
            grdEmpList.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'btnUpload.Enabled = False
        End If
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub ClearSelection()
        If grdEmpList.Rows.Count > 0 Then
            grdEmpList.SelectedIndex = -1
        End If

        grdEmpList.DataSource = ""
        grdEmpList.DataBind()

    End Sub

    Protected Sub btnApplyChanges_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApplyChanges.Click
        Try
            Dim lblEmployeeID As New Label
            Dim result As New clsResult()

            lblEmployeeID = grdEmpList.SelectedRow.FindControl("lblEmployeeID")

            result = EmpData.fnActivateEmployee(lblEmployeeID.Text)

            If result.Success = True Then
                MessageBox(result.Message)
                ClearSelection()
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
