
Partial Class Administration_frmColorEntry
    Inherits System.Web.UI.Page

    Dim ColorData As New clsColor()

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub ClearForm()
        txtColorName.Text = ""
        chkIsActive.Checked = False
        hdFldColorID.Value = ""
    End Sub

    Protected Sub GetColors()
        grdColors.DataSource = ColorData.fnGetColors()
        grdColors.DataBind()
    End Sub

    Protected Sub btnAddColor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddColor.Click
        Try
            Dim Color As New clsColor()
            Dim result As clsResult
            Color.ColorID = hdFldColorID.Value
            Color.ColorName = txtColorName.Text
            Color.EntryBy = "dsamaddar"

            If chkIsActive.Checked = True Then
                Color.IsActive = True
            Else
                Color.IsActive = False
            End If

            If hdFldColorID.Value = "" Then
                result = ColorData.fnInsertColor(Color)
            Else
                result = ColorData.fnUpdateColor(Color)
            End If

            If result.Success = True Then
                ClearForm()
                GetColors()
            End If
            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetColors()
        End If
    End Sub

    Protected Sub grdColors_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdColors.SelectedIndexChanged
        Try
            Dim lblColorID, lblColorName, lblIsActive As Label
            lblColorID = grdColors.SelectedRow.FindControl("lblColorID")
            lblColorName = grdColors.SelectedRow.FindControl("lblColorName")
            lblIsActive = grdColors.SelectedRow.FindControl("lblIsActive")

            hdFldColorID.Value = lblColorID.Text
            txtColorName.Text = lblColorName.Text

            If lblIsActive.Text = "YES" Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
