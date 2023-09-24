
Partial Class Production_frmMaterialIssue
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim StyleData As New clsStyle()
    Dim BuyerData As New clsBuyer()
    Dim OrderData As New clsOrder()

    Dim SizeData As New clsSize()
    Dim ColorData As New clsColor()
    Dim ComponentData As New clsComponents()
    Dim MaterialDistData As New clsMaterialDistribution()

    Dim RateSetupData As New clsRateSetup()

    Protected Sub FormInitialization()
        GetMaterialDistList()
        ShowEmpList()
        GetBuyerInfo()
        GetSizeInfo()
        GetColorInfo()
        GetComponentInfo()
        If drpBuyerList.Items.Count > 0 Then
            GetStyleInfo(drpBuyerList.SelectedValue)
            GetOrderInfo(drpBuyerList.SelectedValue)
        End If

        txtIssueDate.Text = Now.Date.Date
        txtIssueRemarks.Text = "."
    End Sub

    Protected Sub ShowEmpList()
        drpEmpList.DataTextField = "EmployeeName"
        drpEmpList.DataValueField = "EmployeeID"
        drpEmpList.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpEmpList.DataBind()
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

    Protected Sub GetMaterialDistList()
        grdMaterialIssueList.DataSource = MaterialDistData.fnGetMaterialDistList()
        grdMaterialIssueList.DataBind()
    End Sub

    Protected Sub btnIssueMaterial_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnIssueMaterial.Click
        Try
            Dim MatDist As New clsMaterialDistribution()
            Dim result As New clsResult()

            MatDist.EmployeeID = drpEmpList.SelectedValue
            MatDist.BuyerID = drpBuyerList.SelectedValue
            MatDist.OrderID = drpOrderList.SelectedValue
            MatDist.StyleID = drpStyleList.SelectedValue
            MatDist.SizeID = drpSizeList.SelectedValue
            MatDist.ColorID = drpColorList.SelectedValue
            MatDist.ComponentID = drpComponentList.SelectedValue
            MatDist.Rate = txtRate.Text
            MatDist.IssueBy = Session("LoginUserID")
            MatDist.IssueDate = Convert.ToDateTime(txtIssueDate.Text)
            MatDist.IssueQuantity = Convert.ToDouble(txtIssueQuantity.Text)
            MatDist.IssuePiece = Convert.ToDouble(txtIssuePiece.Text)
            MatDist.IssueRemarks = txtIssueRemarks.Text

            result = MaterialDistData.fnIssueMaterial(MatDist)

            If result.Success = True Then
                GetMaterialDistList()
                ClearForm()
                MessageBox(result.Message)
            Else
                MessageBox(result.Message)
            End If

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtIssueQuantity.Text = ""
        txtIssueRemarks.Text = "."
        txtIssueDate.Text = Now.Date.Date
        grdMaterialIssueList.SelectedIndex = -1
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
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

    Protected Sub txtIssueQuantity_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtIssueQuantity.TextChanged
        Try
            Dim MatDist As New clsMaterialDistribution()

            MatDist.BuyerID = drpBuyerList.SelectedValue
            MatDist.OrderID = drpOrderList.SelectedValue
            MatDist.StyleID = drpStyleList.SelectedValue
            MatDist.SizeID = drpSizeList.SelectedValue
            MatDist.ColorID = drpColorList.SelectedValue
            MatDist.ComponentID = drpComponentList.SelectedValue

            MatDist = MaterialDistData.fnGetRate(MatDist)

            txtRate.Text = MatDist.Rate
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
