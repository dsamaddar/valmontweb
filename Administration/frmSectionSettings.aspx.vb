
Partial Class Administration_frmSectionSettings
    Inherits System.Web.UI.Page

    Dim SectionData As New clsSection()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetSectionDetails()
            btnUpdate.Visible = False
            btnInsertDepartment.Visible = True
        End If
    End Sub

    Protected Sub GetSectionDetails()
        Try
            grdDeptInfo.DataSource = SectionData.fnGetSectionList()
            grdDeptInfo.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Try
            If hdFldDepartmentID.Value = "" Then
                MessageBox("Select The Department First.")
                Exit Sub
            End If

            Dim Section As New clsSection()

            Section.SectionID = hdFldDepartmentID.Value
            Section.Section = txtDepartmentName.Text
            Section.SectionInBangla = txtDeptNameBangla.Text

            If chkIsActive.Checked = True Then
                Section.IsActive = True
            Else
                Section.IsActive = False
            End If

            Section.EntryBy = Session("LoginUserID")
            Dim check As Integer = SectionData.fnUpdateSection(Section)

            If check = 1 Then
                ClearDeptForm()
                GetSectionDetails()
                MessageBox("Updated Successfully.")
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
        
    End Sub

    Protected Sub btnInsertDepartment_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertDepartment.Click
        Try
            Dim Section As New clsSection()
            Section.Section = txtDepartmentName.Text
            Section.SectionInBangla = txtDeptNameBangla.Text

            If chkIsActive.Checked = True Then
                Section.IsActive = True
            Else
                Section.IsActive = False
            End If

            Section.EntryBy = Session("LoginUserID")
            Dim check As Integer = SectionData.fnInsertSection(Section)

            If check = 1 Then
                ClearDeptForm()
                GetSectionDetails()
                MessageBox("Updated Successfully.")
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearDeptForm()
        txtDepartmentName.Text = ""
        chkIsActive.Checked = False
        btnUpdate.Visible = False
        btnInsertDepartment.Visible = True
        grdDeptInfo.SelectedIndex = -1
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnCancelSelection_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelSelection.Click

    End Sub

    Protected Sub grdDeptInfo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdDeptInfo.SelectedIndexChanged
        Try
            Dim lblSectionID, lblIsActive, lblSection, lblSectionInBangla As New Label()

            lblSectionID = grdDeptInfo.SelectedRow.FindControl("lblSectionID")
            lblIsActive = grdDeptInfo.SelectedRow.FindControl("lblIsActive")
            lblSection = grdDeptInfo.SelectedRow.FindControl("lblSection")
            lblSectionInBangla = grdDeptInfo.SelectedRow.FindControl("lblSectionInBangla")

            If lblIsActive.Text = "YES" Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

            txtDepartmentName.Text = lblSection.Text
            txtDeptNameBangla.Text = lblSectionInBangla.Text
            hdFldDepartmentID.Value = lblSectionID.Text

            btnUpdate.Visible = True
            btnInsertDepartment.Visible = False
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
