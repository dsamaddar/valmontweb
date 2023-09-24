
Partial Class Administration_frmComponentEntry
    Inherits System.Web.UI.Page

    Dim ComponentData As New clsComponents()
    Dim SecData As New clsSection()

    Protected Sub btnInsertComponent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertComponent.Click
        Try
            Dim Component As New clsComponents()
            Dim result As New clsResult()

            Component.ComponentName = txtComponentName.Text

            If chkIsActive.Checked = True Then
                Component.IsActive = True
            Else
                Component.IsActive = False
            End If

            Component.EntryBy = Session("LoginUserID")

            result = ComponentData.fnInsertComponent(Component)

            If result.Success = True Then
                fnGetComponentList()
                ClearForm()
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtComponentName.Text = ""
        hdFldComponentID.Value = ""
        btnInsertComponent.Enabled = True
        btnUpdateComponent.Enabled = False
        chkIsActive.Checked = True
        grdComponentList.SelectedIndex = -1
    End Sub

    Protected Sub fnGetComponentList()
        grdComponentList.DataSource = ComponentData.fnGetComponentList()
        grdComponentList.DataBind()
    End Sub

    Protected Sub ShowSection()
        Try
            drpSection.DataTextField = "Section"
            drpSection.DataValueField = "SectionID"
            drpSection.DataSource = SecData.fnGetSectionList()
            drpSection.DataBind()

            Dim A As New ListItem
            A.Text = "ALL"
            A.Value = "ALL"

            drpSection.Items.Insert(0, A)
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
        If Not IsPostBack Then
            fnGetComponentList()
            ShowSection()
            btnInsertComponent.Enabled = True
            btnUpdateComponent.Enabled = False
            chkIsActive.Checked = True
        End If
    End Sub

    Protected Sub btnUpdateComponent_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateComponent.Click
        Try
            Dim Component As New clsComponents()
            Dim result As New clsResult()

            Dim lblComponentID As New Label
            lblComponentID = grdComponentList.SelectedRow.FindControl("lblComponentID")

            Component.ComponentID = lblComponentID.Text
            Component.ComponentName = txtComponentName.Text

            If chkIsActive.Checked = True Then
                Component.IsActive = True
            Else
                Component.IsActive = False
            End If

            Component.EntryBy = Session("LoginUserID")

            result = ComponentData.fnUpdateComponent(Component)

            If result.Success = True Then
                fnGetComponentList()
                ClearForm()
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub grdComponentList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdComponentList.SelectedIndexChanged
        Try
            Dim lblComponentID, lblComponentName, lblIsActive, lblEntryBy As New Label

            lblComponentID = grdComponentList.SelectedRow.FindControl("lblComponentID")
            lblComponentName = grdComponentList.SelectedRow.FindControl("lblComponentName")
            lblIsActive = grdComponentList.SelectedRow.FindControl("lblIsActive")


            txtComponentName.Text = lblComponentName.Text
            hdFldComponentID.Value = lblComponentID.Text

            chkIsActive.Checked = Convert.ToBoolean(lblIsActive.Text)

            btnInsertComponent.Enabled = False
            btnUpdateComponent.Enabled = True

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
