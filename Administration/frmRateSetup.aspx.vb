
Partial Class Administration_frmRateSetup
    Inherits System.Web.UI.Page

    Dim StyleData As New clsStyle()
    Dim BuyerData As New clsBuyer()
    Dim OrderData As New clsOrder()

    Dim SizeData As New clsSize()
    Dim ColorData As New clsColor()
    Dim ComponentData As New clsComponents()

    Dim RateSetupData As New clsRateSetup()

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        Try
            Dim RateSetup As New clsRateSetup()
            Dim result As New clsResult()

            RateSetup.RateSetupID = hdFldRateSetupID.Value
            RateSetup.BuyerID = drpBuyerList.SelectedValue
            RateSetup.OrderID = drpOrderList.SelectedValue
            RateSetup.StyleID = drpStyleList.SelectedValue
            RateSetup.SizeID = drpSizeList.SelectedValue
            RateSetup.ColorID = drpColorList.SelectedValue
            RateSetup.ComponentID = drpComponentList.SelectedValue
            RateSetup.Rate = Convert.ToDouble(txtRate.Text)
            RateSetup.EntryBy = Session("LoginUserID")

            If hdFldRateSetupID.Value = "" Then
                result = RateSetupData.fnInsertRateSetup(RateSetup)
            Else
                result = RateSetupData.fnUpdateRateSetup(RateSetup)
            End If

            If result.Success = True Then
                GetRateSetupList()
                ClearForm()
            End If
            MessageBox(result.Message)


        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtRate.Text = ""
        grdRateSetupList.SelectedIndex = -1
    End Sub

    Protected Sub FormInitialization()
        GetBuyerInfo()
        GetSizeInfo()
        GetColorInfo()
        GetComponentInfo()
        If drpBuyerList.Items.Count > 0 Then
            GetStyleInfo(drpBuyerList.SelectedValue)
            GetOrderInfo(drpBuyerList.SelectedValue)
        End If
    End Sub

    Protected Sub GetBuyerInfo()
        drpBuyerList.DataTextField = "BuyerName"
        drpBuyerList.DataValueField = "BuyerID"
        drpBuyerList.DataSource = BuyerData.fnGetBuyerInfo()
        drpBuyerList.DataBind()
    End Sub

    Protected Sub GetStyleInfo(ByVal BuyerID As String)
        drpStyleList.DataTextField = "Style"
        drpStyleList.DataValueField = "StyleID"
        drpStyleList.DataSource = StyleData.fnGetStyleInfo(BuyerID)
        drpStyleList.DataBind()
    End Sub

    Protected Sub GetOrderInfo(ByVal BuyerID As String)
        drpOrderList.DataTextField = "OrderNumber"
        drpOrderList.DataValueField = "OrderID"
        drpOrderList.DataSource = OrderData.fnGetOrderInfo(BuyerID)
        drpOrderList.DataBind()
    End Sub

    Protected Sub GetSizeInfo()
        drpSizeList.DataTextField = "Size"
        drpSizeList.DataValueField = "SizeID"
        drpSizeList.DataSource = SizeData.fnGetSizeList()
        drpSizeList.DataBind()
    End Sub

    Protected Sub GetColorInfo()
        drpColorList.DataTextField = "ColorName"
        drpColorList.DataValueField = "ColorID"
        drpColorList.DataSource = ColorData.fnGetColors()
        drpColorList.DataBind()
    End Sub

    Protected Sub GetComponentInfo()
        drpComponentList.DataTextField = "ComponentName"
        drpComponentList.DataValueField = "ComponentID"
        drpComponentList.DataSource = ComponentData.fnGetComponentList()
        drpComponentList.DataBind()
    End Sub

    Protected Sub GetRateSetupList()
        grdRateSetupList.DataSource = RateSetupData.fnGetRateSetupList()
        grdRateSetupList.DataBind()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetRateSetupList()
            FormInitialization()
        End If
    End Sub

    Protected Sub drpBuyerList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpBuyerList.SelectedIndexChanged
        Try
            GetStyleInfo(drpBuyerList.SelectedValue)
            GetOrderInfo(drpBuyerList.SelectedValue)
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

    Protected Sub grdRateSetupList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdRateSetupList.SelectedIndexChanged
        Try
            Dim lblRateSetupID, lblBuyerID, lblOrderID, lblStyleID, lblSizeID, lblColorID, lblComponentID, lblRate As New Label

            lblRateSetupID = grdRateSetupList.SelectedRow.FindControl("lblRateSetupID")
            lblBuyerID = grdRateSetupList.SelectedRow.FindControl("lblBuyerID")
            lblOrderID = grdRateSetupList.SelectedRow.FindControl("lblOrderID")
            lblStyleID = grdRateSetupList.SelectedRow.FindControl("lblStyleID")
            lblSizeID = grdRateSetupList.SelectedRow.FindControl("lblSizeID")
            lblColorID = grdRateSetupList.SelectedRow.FindControl("lblColorID")
            lblComponentID = grdRateSetupList.SelectedRow.FindControl("lblComponentID")
            lblRate = grdRateSetupList.SelectedRow.FindControl("lblRate")


            hdFldRateSetupID.Value = lblRateSetupID.Text
            drpBuyerList.SelectedValue = lblBuyerID.Text
            If drpBuyerList.Items.Count > 0 Then
                GetStyleInfo(drpBuyerList.SelectedValue)
                GetOrderInfo(drpBuyerList.SelectedValue)
                drpOrderList.SelectedValue = lblOrderID.Text
                drpStyleList.SelectedValue = lblStyleID.Text
            End If

            drpSizeList.SelectedValue = lblSizeID.Text
            drpColorList.SelectedValue = lblColorID.Text
            drpComponentList.SelectedValue = lblComponentID.Text
            txtRate.Text = lblRate.Text

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class

