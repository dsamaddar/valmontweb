
Partial Class Production_frmMaterialReceive
    Inherits System.Web.UI.Page

    Dim MaterialDistData As New clsMaterialDistribution()

    Protected Sub btnReceive_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReceive.Click
        Try
            Dim MatDist As New clsMaterialDistribution()
            Dim result As New clsResult()

            If hdFldMaterialDistID.Value = "" Then
                MessageBox("Select a Issue Material First.")
                Exit Sub
            End If

            MatDist.MaterialDistID = hdFldMaterialDistID.Value
            MatDist.ReceiveQuantity = Convert.ToDouble(txtReceiveQuantity.Text)
            MatDist.ReceiveDate = Convert.ToDateTime(txtReceiveDate.Text)
            MatDist.ReceiveBy = Session("LoginUserID")
            MatDist.ReceiveRemarks = txtReceiveRemarks.Text

            result = MaterialDistData.fnReceiveMaterial(MatDist)

            If result.Success = True Then
                fnGetMaterialDistListPending()
                ClearForm()
                MessageBox(result.Message)
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtReceiveDate.Text = Now.Date.Date
        txtReceiveQuantity.Text = ""
        txtReceiveRemarks.Text = "."
        grdMaterialIssueList.SelectedIndex = -1
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            fnGetMaterialDistListPending()
            txtReceiveDate.Text = Now.Date.Date
            txtReceiveRemarks.Text = "."
        End If
    End Sub

    Protected Sub fnGetMaterialDistListPending()
        grdMaterialIssueList.DataSource = MaterialDistData.fnGetMaterialDistListPending()
        grdMaterialIssueList.DataBind()
    End Sub

    Protected Sub grdMaterialIssueList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdMaterialIssueList.SelectedIndexChanged
        Try
            Dim lblMaterialDistID, lblIssueQuantity As New Label

            lblMaterialDistID = grdMaterialIssueList.SelectedRow.FindControl("lblMaterialDistID")
            lblIssueQuantity = grdMaterialIssueList.SelectedRow.FindControl("lblIssueQuantity")

            hdFldMaterialDistID.Value = lblMaterialDistID.Text
            txtReceiveQuantity.Text = lblIssueQuantity.Text
        Catch ex As Exception

        End Try
    End Sub
End Class
