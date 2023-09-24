
Partial Class Administration_frmInventoryItems
    Inherits System.Web.UI.Page

    Dim UnitTypeData As New clsUnitType()
    Dim ItemData As New clsItem()
    Dim StyleData As New clsStyle()
    Dim BuyerData As New clsBuyer()
    Dim ColorData As New clsColor()

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub GetColorInfo()
        drpColor.DataTextField = "ColorName"
        drpColor.DataValueField = "ColorID"
        drpColor.DataSource = ColorData.fnGetColors()
        drpColor.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpColor.Items.Insert(0, A)
    End Sub

    Protected Sub GetStyleInfo(ByVal BuyerID As String)
        drpStyleNo.DataTextField = "Style"
        drpStyleNo.DataValueField = "StyleID"
        drpStyleNo.DataSource = StyleData.fnGetStyleInfo(BuyerID)
        drpStyleNo.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpStyleNo.Items.Insert(0, A)
    End Sub

    Protected Sub GetBuyerInfo()
        drpBuyer.DataTextField = "BuyerName"
        drpBuyer.DataValueField = "BuyerID"
        drpBuyer.DataSource = BuyerData.fnGetBuyerInfo()
        drpBuyer.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpBuyer.Items.Insert(0, A)
    End Sub

    Protected Sub ShowUnitTypeList()
        drpUnitType.DataTextField = "UnitType"
        drpUnitType.DataValueField = "UnitTypeID"
        drpUnitType.DataSource = UnitTypeData.fnGetUnitTypeList()
        drpUnitType.DataBind()
    End Sub

    Protected Sub GetInventoryItemDetails()
        grdAvailableItems.DataSource = ItemData.fnGetItemListDetails()
        grdAvailableItems.DataBind()
    End Sub

    Protected Sub btnCancelInputItemType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelInputItemType.Click
        ClearItemInput()
    End Sub

    Protected Sub ClearItemInput()
        txtItemCode.Text = ""
        txtItemName.Text = ""
        txtLowBalanceReport.Text = "5"
        txtMaxRequisition.Text = "10000"
        drpBuyer.SelectedIndex = -1
        drpColor.SelectedIndex = -1
        drpInventoryItems.SelectedIndex = -1
        drpStyleNo.SelectedIndex = -1
        drpUnitType.SelectedIndex = -1
        chkItemIsActive.Checked = False

        grdAvailableItems.SelectedIndex = -1

        btnAddItem.Visible = True
        btnUpdateInventoryItems.Visible = False
        hdFldItemID.Value = ""
        chkItemIsActive.Checked = True
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Dim MenuIDs As String

        'MenuIDs = Session("PermittedMenus")

        'If InStr(MenuIDs, "MngItm~") = 0 Then
        '    Response.Redirect("~\frmAILogin.aspx")
        'End If

        If Not IsPostBack Then
            FormInitialization()
        End If
    End Sub

    Protected Sub FormInitialization()
        ShowUnitTypeList()
        btnUpdateInventoryItems.Visible = False
        GetInventoryItemDetails()
        GetColorInfo()
        GetBuyerInfo()
        GetParentInventoryItems()
        chkItemIsActive.Checked = True
        txtLowBalanceReport.Text = "5"

        If drpBuyer.Items.Count > 0 Then
            GetStyleInfo(drpBuyer.SelectedValue)
        End If
    End Sub

    Protected Sub GetParentInventoryItems()
        drpInventoryItems.DataTextField = "ItemName"
        drpInventoryItems.DataValueField = "ItemID"
        drpInventoryItems.DataSource = ItemData.fnGetItemList()
        drpInventoryItems.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpInventoryItems.Items.Insert(0, A)
    End Sub

    Protected Sub btnUpdateInventoryItems_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateInventoryItems.Click

        Dim Items As New clsItem()
        Try
            Items.ItemID = hdFldItemID.Value
            Items.BuyerID = drpBuyer.SelectedValue
            Items.StyleID = drpStyleNo.SelectedValue
            Items.ColorID = drpColor.SelectedValue
            Items.ParentItemID = drpInventoryItems.SelectedValue
            Items.ItemName = txtItemName.Text
            Items.ItemCode = txtItemCode.Text
            Items.LowBalanceReport = txtLowBalanceReport.Text
            Items.MaxAllowableRequisition = txtMaxRequisition.Text
            Items.UnitTypeID = drpUnitType.SelectedValue
            If chkItemIsActive.Checked = True Then
                Items.IsActive = True
            Else
                Items.IsActive = False
            End If

            Items.EntryBy = "dsamaddar" 'Session("LoginUserID")

            Dim Check As Integer = ItemData.fnUpdateInventoryItems(Items)

            If Check = 1 Then
                MessageBox("Item Updated Successfully.")
                GetInventoryItemDetails()
                ClearItemInput()
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try

    End Sub

    Protected Sub grdAvailableItems_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdAvailableItems.SelectedIndexChanged

        grdAvailableItems.Focus()
        btnAddItem.Visible = False
        btnUpdateInventoryItems.Visible = True

        Dim lblItemID, lblItemName, lblItemCode, lblUnitTypeID, lblLowBalanceReport, lblMaxAllowableRequisition, lblIsActive, _
        lblBuyerID, lblStyleID, lblColorID, lblParentItemID As Label

        Try
            lblItemID = grdAvailableItems.SelectedRow.FindControl("lblItemID")
            lblItemName = grdAvailableItems.SelectedRow.FindControl("lblItemName")
            lblItemCode = grdAvailableItems.SelectedRow.FindControl("lblItemCode")
            lblUnitTypeID = grdAvailableItems.SelectedRow.FindControl("lblUnitTypeID")
            lblLowBalanceReport = grdAvailableItems.SelectedRow.FindControl("lblLowBalanceReport")
            lblMaxAllowableRequisition = grdAvailableItems.SelectedRow.FindControl("lblMaxAllowableRequisition")
            lblIsActive = grdAvailableItems.SelectedRow.FindControl("lblIsActive")

            lblBuyerID = grdAvailableItems.SelectedRow.FindControl("lblBuyerID")
            lblStyleID = grdAvailableItems.SelectedRow.FindControl("lblStyleID")
            lblColorID = grdAvailableItems.SelectedRow.FindControl("lblColorID")
            lblParentItemID = grdAvailableItems.SelectedRow.FindControl("lblParentItemID")

            hdFldItemID.Value = lblItemID.Text
            drpBuyer.SelectedValue = lblBuyerID.Text
            drpStyleNo.SelectedValue = lblStyleID.Text
            drpColor.SelectedValue = lblColorID.Text
            drpInventoryItems.SelectedValue = lblParentItemID.Text
            txtItemName.Text = lblItemName.Text
            txtItemCode.Text = lblItemCode.Text
            drpUnitType.SelectedValue = lblUnitTypeID.Text
            txtLowBalanceReport.Text = lblLowBalanceReport.Text
            txtMaxRequisition.Text = lblMaxAllowableRequisition.Text

            If lblIsActive.Text = "Active" Then
                chkItemIsActive.Checked = True
            Else
                chkItemIsActive.Checked = False
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnAddItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddItem.Click
        Dim Items As New clsItem()

        Try
            Items.BuyerID = drpBuyer.SelectedValue
            Items.StyleID = drpStyleNo.SelectedValue
            Items.ColorID = drpColor.SelectedValue
            Items.ParentItemID = drpInventoryItems.SelectedValue
            Items.ItemName = txtItemName.Text
            Items.ItemCode = txtItemCode.Text
            Items.LowBalanceReport = txtLowBalanceReport.Text
            Items.MaxAllowableRequisition = txtMaxRequisition.Text
            Items.UnitTypeID = drpUnitType.SelectedValue
            If chkItemIsActive.Checked = True Then
                Items.IsActive = True
            Else
                Items.IsActive = False
            End If

            Items.EntryBy = "dsamaddar" 'Session("LoginUserID")

            Dim Check As Integer = ItemData.fnInsertInventoryItems(Items)

            If Check = 1 Then
                MessageBox("Item Inserted Successfully.")
                GetInventoryItemDetails()
                GetParentInventoryItems()
                ClearItemInput()
            Else
                MessageBox("Error Found.")
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
       
    End Sub

    Protected Sub drpBuyer_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpBuyer.SelectedIndexChanged
        GetStyleInfo(drpBuyer.SelectedValue)
    End Sub

    Protected Sub imgBtnGenItemName_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgBtnGenItemName.Click
        Try
            Dim Item As New clsItem()
            Dim ItemName As String = ""
            Item.BuyerID = drpBuyer.SelectedValue
            Item.StyleID = drpStyleNo.SelectedValue
            Item.ColorID = drpColor.SelectedValue
            Item.ParentItemID = drpInventoryItems.SelectedValue

            ItemName = ItemData.fnGenerateItemName(Item)

            txtItemName.Text = ItemName
            txtItemCode.Text = ItemName

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub txtItemName_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtItemName.TextChanged
        txtItemCode.Text = txtItemName.Text
    End Sub
End Class
