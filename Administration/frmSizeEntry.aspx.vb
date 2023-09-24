
Partial Class Administration_frmSizeEntry
    Inherits System.Web.UI.Page

    Dim SizeData As New clsSize()

    Protected Sub btnInsertSize_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertSize.Click
        Try
            Dim Size As New clsSize()
            Dim result As New clsResult()

            Size.Size = txtSize.Text

            If chkIsActive.Checked = True Then
                Size.IsActive = True
            Else
                Size.IsActive = False
            End If

            Size.EntryBy = Session("LoginUserID")

            result = SizeData.fnInsertSize(Size)

            If result.Success = True Then
                fnGetSizeList()
                ClearForm()
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtSize.Text = ""
        hdFldSizeID.Value = ""
        btnInsertSize.Enabled = True
        btnUpdateSize.Enabled = False
        chkIsActive.Checked = True
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            fnGetSizeList()
            btnInsertSize.Enabled = True
            btnUpdateSize.Enabled = False
            chkIsActive.Checked = True
            grdSizeList.SelectedIndex = -1
        End If
    End Sub

    Protected Sub btnUpdateSize_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateSize.Click
        Try
            Dim Size As New clsSize()
            Dim result As New clsResult()

            Dim lblSizeID As New Label
            lblSizeID = grdSizeList.SelectedRow.FindControl("lblSizeID")

            Size.SizeID = lblSizeID.Text
            Size.Size = txtSize.Text

            If chkIsActive.Checked = True Then
                Size.IsActive = True
            Else
                Size.IsActive = False
            End If

            Size.EntryBy = Session("LoginUserID")

            result = SizeData.fnUpdateSize(Size)

            If result.Success = True Then
                fnGetSizeList()
                ClearForm()
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub fnGetSizeList()
        grdSizeList.DataSource = SizeData.fnGetSizeList()
        grdSizeList.DataBind()
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub grdSizeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdSizeList.SelectedIndexChanged
        Try
            Dim lblSizeID, lblSize, lblIsActive, lblEntryBy As New Label

            lblSizeID = grdSizeList.SelectedRow.FindControl("lblSizeID")
            lblSize = grdSizeList.SelectedRow.FindControl("lblSize")
            lblIsActive = grdSizeList.SelectedRow.FindControl("lblIsActive")


            txtSize.Text = lblSize.Text
            hdFldSizeID.Value = lblSizeID.Text

            chkIsActive.Checked = Convert.ToBoolean(lblIsActive.Text)

            btnInsertSize.Enabled = False
            btnUpdateSize.Enabled = True

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
