
Partial Class Administration_frmDesignation
    Inherits System.Web.UI.Page

    Dim DesignationData As New clsDesignation()

    Protected Sub btnInsertDesignation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertDesignation.Click
        Try
            Dim Designation As New clsDesignation()

            Designation.Designation = txtDesignationName.Text
            Designation.DesignationBangla = txtDesignationInBangla.Text
            Designation.DesignationLevel = ddlDesigLabel.SelectedValue
            Designation.DesignationType = rdoDesignationType.SelectedValue
            Designation.ShortCode = txtShortCode.Text
            Designation.IntOrder = Convert.ToInt32(txtOrder.Text)

            If chkIsDesigActive.Checked = True Then
                Designation.IsActive = True
            Else
                Designation.IsActive = False
            End If

            Designation.EntryBy = Session("LoginUserID")

            Dim result As clsResult = DesignationData.fnInsertDesignation(Designation)

            If result.Success = True Then
                ClearForm()
                GetAllDesignation()
                FormInitialize()
            End If

            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtDesignationInBangla.Text = ""
        txtDesignationName.Text = ""
        txtOrder.Text = ""
        txtShortCode.Text = ""
        ddlDesigLabel.SelectedIndex = -1
        rdoDesignationType.SelectedIndex = -1
        grdDesignationList.SelectedIndex = -1
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnUpdateDesignation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateDesignation.Click
        Try
            If hdFldDesignationID.Value = "" Then
                MessageBox("Select An Item First.")
                Exit Sub
            End If

            Dim Designation As New clsDesignation()

            Designation.DesignationID = hdFldDesignationID.Value
            Designation.Designation = txtDesignationName.Text
            Designation.DesignationBangla = txtDesignationInBangla.Text
            Designation.DesignationLevel = ddlDesigLabel.SelectedValue
            Designation.DesignationType = rdoDesignationType.SelectedValue
            Designation.ShortCode = txtShortCode.Text
            Designation.IntOrder = Convert.ToInt32(txtOrder.Text)

            If chkIsDesigActive.Checked = True Then
                Designation.IsActive = True
            Else
                Designation.IsActive = False
            End If

            Designation.EntryBy = Session("LoginUserID")

            Dim result As clsResult = DesignationData.fnUpdateDesignation(Designation)

            If result.Success = True Then
                ClearForm()
                GetAllDesignation()
                FormInitialize()
            End If

            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetAllDesignation()
        End If
    End Sub

    Protected Sub FormInitialize()
        btnInsertDesignation.Enabled = True
        btnUpdateDesignation.Enabled = False
    End Sub

    Protected Sub GetAllDesignation()
        grdDesignationList.DataSource = DesignationData.fnGetDesignationList()
        grdDesignationList.DataBind()
    End Sub

    Protected Sub grdDesignationList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdDesignationList.SelectedIndexChanged
        Try
            Dim lblDesignationID, lblDesignation, lblDesignationBangla, lblShortCode, lblDesignationLevel, lblDesignationType, _
            lblIntOrder, lblIsActive As New Label

            lblDesignationID = grdDesignationList.SelectedRow.FindControl("lblDesignationID")
            lblDesignation = grdDesignationList.SelectedRow.FindControl("lblDesignation")
            lblDesignationBangla = grdDesignationList.SelectedRow.FindControl("lblDesignationBangla")
            lblShortCode = grdDesignationList.SelectedRow.FindControl("lblShortCode")
            lblDesignationLevel = grdDesignationList.SelectedRow.FindControl("lblDesignationLevel")
            lblDesignationType = grdDesignationList.SelectedRow.FindControl("lblDesignationType")
            lblIntOrder = grdDesignationList.SelectedRow.FindControl("lblIntOrder")
            lblIsActive = grdDesignationList.SelectedRow.FindControl("lblIsActive")

            hdFldDesignationID.Value = lblDesignationID.Text
            txtDesignationName.Text = lblDesignation.Text
            txtDesignationInBangla.Text = lblDesignationBangla.Text
            txtShortCode.Text = lblShortCode.Text
            ddlDesigLabel.SelectedValue = lblDesignationLevel.Text
            txtOrder.Text = lblIntOrder.Text

            If lblDesignationType.Text = "Official" Then
                rdoDesignationType.SelectedValue = "Official"
            Else
                rdoDesignationType.SelectedValue = "Functional"
            End If

            If lblIsActive.Text = "YES" Then
                chkIsDesigActive.Checked = True
            Else
                chkIsDesigActive.Checked = False
            End If

            btnInsertDesignation.Enabled = False
            btnUpdateDesignation.Enabled = True

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
