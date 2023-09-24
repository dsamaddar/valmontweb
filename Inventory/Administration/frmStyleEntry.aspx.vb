
Partial Class Inventory_Administration_frmStyleEntry
    Inherits System.Web.UI.Page

    Dim StyleData As New clsStyle()
    Dim BuyerData As New clsBuyer()

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnStyleEntry_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnStyleEntry.Click
        Try
            Dim Style As New clsStyle()
            Dim result As New clsResult()

            Style.StyleID = hdFldStyleID.Value
            Style.BuyerID = drpBuyerList.SelectedValue
            Style.Style = txtStyleNo.Text
            Style.Code = txtStyleCode.Text
            Style.StyleDescription = txtStyleDescription.Text

            If chkIsActive.Checked = True Then
                Style.IsActive = True
            Else
                Style.IsActive = False
            End If

            Style.EntryBy = "dsamaddar"

            If hdFldStyleID.Value = "" Then
                result = StyleData.fnInsertStyle(Style)
            Else
                result = StyleData.fnUpdateStyle(Style)
            End If

            If result.Success = True Then
                ClearForm()
                If drpBuyerList.SelectedIndex <> -1 Then
                    GetStyleInfo(drpBuyerList.SelectedValue)
                Else
                    GetStyleInfo()
                End If
            End If
            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtStyleCode.Text = ""
        txtStyleDescription.Text = "."
        txtStyleNo.Text = ""
        hdFldStyleID.Value = ""

        chkIsActive.Checked = True

        If grdStyleInfo.Rows.Count > 0 Then
            grdStyleInfo.SelectedIndex = -1
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            chkIsActive.Checked = True
            txtStyleDescription.Text = "."
            GetStyleInfo()
            GetBuyerInfo()
        End If
    End Sub

    Protected Sub GetBuyerInfo()
        drpBuyerList.DataTextField = "BuyerName"
        drpBuyerList.DataValueField = "BuyerID"
        drpBuyerList.DataSource = BuyerData.fnGetBuyerInfo()
        drpBuyerList.DataBind()
    End Sub

    Protected Sub GetStyleInfo()
        grdStyleInfo.DataSource = StyleData.fnGetStyleInfo()
        grdStyleInfo.DataBind()
    End Sub

    Protected Sub GetStyleInfo(ByVal BuyerID As String)
        grdStyleInfo.DataSource = StyleData.fnGetStyleInfo(BuyerID)
        grdStyleInfo.DataBind()
    End Sub

    Protected Sub grdStyleInfo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdStyleInfo.SelectedIndexChanged
        Try
            Dim lblStyleID, lblBuyerID, lblStyle, lblCode, lblStyleDescription, lblIsActive As Label

            lblStyleID = grdStyleInfo.SelectedRow.FindControl("lblStyleID")
            lblBuyerID = grdStyleInfo.SelectedRow.FindControl("lblBuyerID")
            lblStyle = grdStyleInfo.SelectedRow.FindControl("lblStyle")
            lblCode = grdStyleInfo.SelectedRow.FindControl("lblCode")
            lblStyleDescription = grdStyleInfo.SelectedRow.FindControl("lblStyleDescription")
            lblIsActive = grdStyleInfo.SelectedRow.FindControl("lblIsActive")

            hdFldStyleID.Value = lblStyleID.Text
            txtStyleCode.Text = lblCode.Text
            txtStyleDescription.Text = lblStyleDescription.Text
            txtStyleNo.Text = lblStyle.Text
            drpBuyerList.SelectedValue = lblBuyerID.Text

            If lblIsActive.Text = "YES" Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub drpBuyerList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpBuyerList.SelectedIndexChanged
        Try
            GetStyleInfo(drpBuyerList.SelectedValue)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
