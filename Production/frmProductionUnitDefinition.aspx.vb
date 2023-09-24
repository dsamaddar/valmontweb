
Partial Class frmProductionUnitDefinition
    Inherits System.Web.UI.Page

    Dim StyleData As New clsStyle()
    Dim ProcessData As New clsProcess()
    Dim SizeData As New clsSize()
    Dim ProductionUnitData As New clsProductionUnit()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetStyleList()
            GetProcessList()
            GetSizeList()
            GetProductionUnitDetails()
            Initialization()
        End If
    End Sub

    Protected Sub Initialization()
        txtOvertimeRate.Text = "0"
        txtRegularRate.Text = "0"
        chkIsActive.Checked = True
        btnInsert.Enabled = True
        btnUpdate.Enabled = False
    End Sub

    Protected Sub GetProcessList()
        drpProcessList.DataTextField = "Process"
        drpProcessList.DataValueField = "ProcessID"
        drpProcessList.DataSource = ProcessData.fnGetProcessList()
        drpProcessList.DataBind()
    End Sub

    Protected Sub GetStyleList()
        drpStyleList.DataTextField = "Style"
        drpStyleList.DataValueField = "StyleID"
        drpStyleList.DataSource = StyleData.fnGetStyleInfo()
        drpStyleList.DataBind()
    End Sub

    Protected Sub GetSizeList()
        drpSizeList.DataTextField = "Size"
        drpSizeList.DataValueField = "SizeID"
        drpSizeList.DataSource = SizeData.fnGetSizeList()
        drpSizeList.DataBind()
    End Sub

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click
        Dim ProdUnit As New clsProductionUnit()
        Try
            ProdUnit.ProductionUnit = txtProductionUnit.Text
            ProdUnit.StyleID = drpStyleList.SelectedValue
            ProdUnit.ProcessID = drpProcessList.SelectedValue
            ProdUnit.SizeID = drpSizeList.SelectedValue
            ProdUnit.RegularRate = Convert.ToDouble(txtRegularRate.Text)
            ProdUnit.OvertimeRate = Convert.ToDouble(txtOvertimeRate.Text)

            If chkIsActive.Checked = True Then
                ProdUnit.IsActive = True
            Else
                ProdUnit.IsActive = False
            End If

            ProdUnit.EntryBy = "dsamaddar"

            Dim result As clsResult = ProdUnit.fnInsertProductionUnit(ProdUnit)

            If result.Success = True Then
                ClearForm()
                GetProductionUnitDetails()
            End If

            MessageBox(result.Message)
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

    Protected Sub ClearForm()
        txtOvertimeRate.Text = "0"
        txtProductionUnit.Text = ""
        txtRegularRate.Text = "0"
        chkIsActive.Checked = False
        drpProcessList.SelectedIndex = -1
        drpSizeList.SelectedIndex = -1
        drpStyleList.SelectedIndex = -1
        btnInsert.Enabled = True
        btnUpdate.Enabled = False
        grdProductionUnitDetails.SelectedIndex = -1
    End Sub

    Protected Sub GetProductionUnitDetails()
        grdProductionUnitDetails.DataSource = ProductionUnitData.fnGetProductionUnitDetails()
        grdProductionUnitDetails.DataBind()
    End Sub

    Protected Sub grdProductionUnitDetails_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdProductionUnitDetails.SelectedIndexChanged
        Dim lblProductionUnitID, lblProductionUnit, lblStyleID, lblProcessID, lblSizeID, lblRegularRate, lblOvertimeRate, lblIsActive As New Label

        Try
            lblProductionUnitID = grdProductionUnitDetails.SelectedRow.FindControl("lblProductionUnitID")
            lblProductionUnit = grdProductionUnitDetails.SelectedRow.FindControl("lblProductionUnit")
            lblStyleID = grdProductionUnitDetails.SelectedRow.FindControl("lblStyleID")

            lblProcessID = grdProductionUnitDetails.SelectedRow.FindControl("lblProcessID")
            lblSizeID = grdProductionUnitDetails.SelectedRow.FindControl("lblSizeID")
            lblRegularRate = grdProductionUnitDetails.SelectedRow.FindControl("lblRegularRate")
            lblOvertimeRate = grdProductionUnitDetails.SelectedRow.FindControl("lblOvertimeRate")
            lblIsActive = grdProductionUnitDetails.SelectedRow.FindControl("lblIsActive")

            hdFldProductionUnitID.Value = lblProductionUnitID.Text
            txtProductionUnit.Text = lblProductionUnit.Text
            drpStyleList.SelectedValue = lblStyleID.Text
            drpProcessList.SelectedValue = lblProcessID.Text
            drpSizeList.SelectedValue = lblSizeID.Text

            txtRegularRate.Text = Convert.ToDouble(lblRegularRate.Text)
            txtOvertimeRate.Text = Convert.ToDouble(lblOvertimeRate.Text)

            If lblIsActive.Text = "YES" Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

            btnInsert.Enabled = False
            btnUpdate.Enabled = True

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Dim ProdUnit As New clsProductionUnit()
        Try
            If hdFldProductionUnitID.Value = "" Then
                MessageBox("Select A Production Unit First.")
                Exit Sub
            End If
            ProdUnit.ProductionUnitID = hdFldProductionUnitID.Value
            ProdUnit.ProductionUnit = txtProductionUnit.Text
            ProdUnit.StyleID = drpStyleList.SelectedValue
            ProdUnit.ProcessID = drpProcessList.SelectedValue
            ProdUnit.SizeID = drpSizeList.SelectedValue
            ProdUnit.RegularRate = Convert.ToDouble(txtRegularRate.Text)
            ProdUnit.OvertimeRate = Convert.ToDouble(txtOvertimeRate.Text)

            If chkIsActive.Checked = True Then
                ProdUnit.IsActive = True
            Else
                ProdUnit.IsActive = False
            End If

            ProdUnit.EntryBy = "dsamaddar"

            Dim result As clsResult = ProdUnit.fnUpdateProductionUnit(ProdUnit)

            If result.Success = True Then
                ClearForm()
                GetProductionUnitDetails()
            End If

            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
