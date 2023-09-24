
Partial Class Administration_frmOrderEntry
    Inherits System.Web.UI.Page

    Dim StyleData As New clsStyle()
    Dim BuyerData As New clsBuyer()
    Dim OrderData As New clsOrder()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            FormInitialization()
            txtDeliverDate.Text = Now.Date.Date
            txtOrderDate.Text = Now.Date.Date
            txtOrderDetails.Text = "."
            GetOrderInfo()
        End If
    End Sub

    Protected Sub FormInitialization()
        GetBuyerInfo()
        If drpBuyerList.Items.Count > 0 Then
            GetStyleInfo(drpBuyerList.SelectedValue)
        End If
    End Sub

    Protected Sub GetStyleInfo(ByVal BuyerID As String)
        drpStyleInfo.DataTextField = "Style"
        drpStyleInfo.DataValueField = "StyleID"
        drpStyleInfo.DataSource = StyleData.fnGetStyleInfo(BuyerID)
        drpStyleInfo.DataBind()
    End Sub

    Protected Sub GetBuyerInfo()
        drpBuyerList.DataTextField = "BuyerName"
        drpBuyerList.DataValueField = "BuyerID"
        drpBuyerList.DataSource = BuyerData.fnGetBuyerInfo()
        drpBuyerList.DataBind()
    End Sub

    Protected Sub drpBuyerList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpBuyerList.SelectedIndexChanged
        GetStyleInfo(drpBuyerList.SelectedValue)
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub ClearForm()
        txtOrderNumber.Text = ""
        txtDeliverDate.Text = ""
        txtOrderDate.Text = ""
        txtOrderDetails.Text = ""
        txtOrderQuantity.Text = ""
        hdFldOrderID.Value = ""

        txtDeliverDate.Text = Now.Date.Date
        txtOrderDate.Text = Now.Date.Date
        txtOrderDetails.Text = "."
    End Sub

    Protected Sub btnAddOrder_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddOrder.Click
        Try
            Dim Order As New clsOrder()
            Dim result As New clsResult()

            Order.OrderID = hdFldOrderID.Value
            Order.BuyerID = drpBuyerList.SelectedValue
            Order.StyleID = drpStyleInfo.SelectedValue
            Order.OrderNumber = txtOrderNumber.Text
            Order.OrderDetails = txtOrderDetails.Text
            Order.OrderQuantity = Convert.ToInt32(txtOrderQuantity.Text)
            Order.OrderDate = Convert.ToDateTime(txtOrderDate.Text)
            Order.DeliveryDate = Convert.ToDateTime(txtDeliverDate.Text)
            Order.EntryBy = Session("LoginUserID")

            If hdFldOrderID.Value = "" Then
                result = OrderData.fnInsertOrder(Order)
            Else
                result = OrderData.fnUpdateOrder(Order)
            End If

            If result.Success = True Then
                GetOrderInfo()
                ClearForm()
            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetOrderInfo()
        Try
            grdOrderList.DataSource = OrderData.fnGetOrderInfo()
            grdOrderList.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub grdOrderList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdOrderList.SelectedIndexChanged
        Dim lblOrderID, lblBuyerID, lblStyleID, lblOrderNumber, lblOrderQuantity, lblOrderDate, lblDeliveryDate, lblOrderDetails As Label
        Try
            lblOrderID = grdOrderList.SelectedRow.FindControl("lblOrderID")
            lblBuyerID = grdOrderList.SelectedRow.FindControl("lblBuyerID")
            lblStyleID = grdOrderList.SelectedRow.FindControl("lblStyleID")
            lblOrderNumber = grdOrderList.SelectedRow.FindControl("lblOrderNumber")
            lblOrderQuantity = grdOrderList.SelectedRow.FindControl("lblOrderQuantity")
            lblOrderDate = grdOrderList.SelectedRow.FindControl("lblOrderDate")
            lblDeliveryDate = grdOrderList.SelectedRow.FindControl("lblDeliveryDate")
            lblOrderDetails = grdOrderList.SelectedRow.FindControl("lblOrderDetails")

            hdFldOrderID.Value = lblOrderID.Text
            drpBuyerList.SelectedValue = lblBuyerID.Text
            GetStyleInfo(drpBuyerList.SelectedValue)
            drpStyleInfo.SelectedValue = lblStyleID.Text
            txtOrderNumber.Text = lblOrderNumber.Text
            txtOrderQuantity.Text = lblOrderQuantity.Text
            txtOrderDetails.Text = lblOrderDetails.Text
            txtOrderDate.Text = Convert.ToDateTime(lblOrderDate.Text)
            txtDeliverDate.Text = Convert.ToDateTime(lblDeliveryDate.Text)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
