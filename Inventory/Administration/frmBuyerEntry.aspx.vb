
Partial Class Inventory_Administration_frmBuyerEntry
    Inherits System.Web.UI.Page

    Dim BuyerData As New clsBuyer()
    Dim EmpData As New clsEmployee()

    Protected Sub ClearForm()
        txtAddress.Text = ""
        txtBuyerName.Text = ""
        txtContactNo.Text = ""
        txtContactPerson.Text = ""
        txtEmailAddress.Text = ""
        txtFax.Text = ""
        drpCountry.SelectedIndex = -1
        drpMerchandizer.SelectedIndex = -1
    End Sub

    Protected Sub btnAddBuyer_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddBuyer.Click
        Try
            Dim Buyer As New clsBuyer()
            Dim result As New clsResult()

            Buyer.BuyerID = hdFldBuyerID.Value
            Buyer.BuyerName = txtBuyerName.Text
            Buyer.Country = drpCountry.SelectedValue
            Buyer.BuyerAddress = txtAddress.Text
            Buyer.ContactNo = txtContactNo.Text
            Buyer.ContactPerson = txtContactPerson.Text

            Buyer.EmailAddress = txtEmailAddress.Text
            Buyer.Fax = txtFax.Text
            Buyer.MerchandizerID = drpMerchandizer.SelectedValue
            Buyer.EntryBy = "dsamaddar"

            If hdFldBuyerID.Value = "" Then
                result = BuyerData.fnInsertBuyer(Buyer)
            Else
                result = BuyerData.fnUpdateBuyer(Buyer)
            End If

            If result.Success = True Then
                ClearForm()
                GetBuyerInfo()
            End If

            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetMerchandizerList()
        drpMerchandizer.DataTextField = "EmployeeName"
        drpMerchandizer.DataValueField = "EmployeeID"
        drpMerchandizer.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpMerchandizer.DataBind()
    End Sub

    Protected Sub GetBuyerInfo()
        grdBuyerList.DataSource = BuyerData.fnGetBuyerInfo()
        grdBuyerList.DataBind()
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetMerchandizerList()
            GetBuyerInfo()
        End If
    End Sub

    Protected Sub grdBuyerList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdBuyerList.SelectedIndexChanged
        Try
            Dim lblBuyerID, lblBuyerName, lblCountry, lblBuyerAddress, lblContactPerson, lblContactNo, lblEmailAddress, lblFax, lblMerchandizerID As Label

            lblBuyerID = grdBuyerList.SelectedRow.FindControl("lblBuyerID")
            lblBuyerName = grdBuyerList.SelectedRow.FindControl("lblBuyerName")
            lblCountry = grdBuyerList.SelectedRow.FindControl("lblCountry")
            lblBuyerAddress = grdBuyerList.SelectedRow.FindControl("lblBuyerAddress")
            lblContactPerson = grdBuyerList.SelectedRow.FindControl("lblContactPerson")
            lblContactNo = grdBuyerList.SelectedRow.FindControl("lblContactNo")
            lblEmailAddress = grdBuyerList.SelectedRow.FindControl("lblEmailAddress")
            lblFax = grdBuyerList.SelectedRow.FindControl("lblFax")
            lblMerchandizerID = grdBuyerList.SelectedRow.FindControl("lblMerchandizerID")

            drpCountry.SelectedValue = lblCountry.Text
            drpMerchandizer.SelectedValue = lblMerchandizerID.Text
            txtBuyerName.Text = lblBuyerName.Text
            hdFldBuyerID.Value = lblBuyerID.Text
            txtContactNo.Text = lblContactNo.Text
            txtAddress.Text = lblBuyerAddress.Text
            txtContactPerson.Text = lblContactPerson.Text
            txtEmailAddress.Text = lblEmailAddress.Text
            txtFax.Text = lblFax.Text

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
