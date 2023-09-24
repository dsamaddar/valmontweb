﻿Imports System.IO
Imports System.IO.StreamWriter

Partial Class Report_frmReportProcurement
    Inherits System.Web.UI.Page

    Dim SupplierData As New clsSupplier()
    Dim ItemData As New clsItem()
    Dim InvoiceData As New clsInvoice()

    Protected Sub btnShowReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnShowReport.Click

        Dim InvoiceInfo As New clsInvoice()
        If txtPurchaseDateFrom.Text <> "" And txtPurchaseDateTo.Text = "" Then
            MessageBox("Date To Cann't Be Empty.")
            Exit Sub
        End If

        If txtPurchaseDateFrom.Text = "" And txtPurchaseDateTo.Text <> "" Then
            MessageBox("Date From Cann't Be Empty.")
            Exit Sub
        End If

        If txtPurchaseDateFrom.Text = "" Or txtPurchaseDateTo.Text = "" Then
            InvoiceInfo.PurchaseDateFrom = "1/1/1900"
            InvoiceInfo.PurchaseDateTo = "1/1/2099"
        End If

        If txtPurchaseDateFrom.Text <> "" And txtPurchaseDateTo.Text <> "" Then
            If Convert.ToDateTime(txtPurchaseDateFrom.Text) > Convert.ToDateTime(txtPurchaseDateTo.Text) Then
                MessageBox("Invalid Date Parameter. From must be lower Than To Date")
                Exit Sub
            End If
            InvoiceInfo.PurchaseDateFrom = Convert.ToDateTime(txtPurchaseDateFrom.Text)
            InvoiceInfo.PurchaseDateTo = Convert.ToDateTime(txtPurchaseDateTo.Text)
        Else
            
        End If

        InvoiceInfo.InvoiceNo = txtInvoiceNumber.Text
        InvoiceInfo.ItemID = drpInventoryItems.SelectedValue
        InvoiceInfo.SupplierID = drpSupplier.SelectedValue

        grdQueryResult.DataSource = InvoiceData.fnShowProcurementReport(InvoiceInfo)
        grdQueryResult.DataBind()


    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Dim MenuIDs As String

        'MenuIDs = Session("PermittedMenus")

        'If InStr(MenuIDs, "RptProcurement~") = 0 Then
        '    Response.Redirect("~\frmAILogin.aspx")
        'End If

        If Not IsPostBack Then
            ShowSupplierInfo()
            ShowItemList()
        End If
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        ClearForm()
    End Sub

    Protected Sub ClearForm()
        txtInvoiceNumber.Text = ""
        txtPurchaseDateFrom.Text = ""
        txtPurchaseDateTo.Text = ""
        drpInventoryItems.SelectedIndex = -1
        drpSupplier.SelectedIndex = -1

        grdQueryResult.DataSource = ""
        grdQueryResult.DataBind()

    End Sub

    Protected Sub btnExportReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnExportReport.Click
        ExportToExcel(grdQueryResult)
    End Sub

    Protected Sub ExportToExcel(ByVal gridview As System.Web.UI.WebControls.GridView)
        Try
            Dim sw As New StringWriter()
            Dim hw As New System.Web.UI.HtmlTextWriter(sw)
            Dim frm As HtmlForm = New HtmlForm()

            Page.Response.AddHeader("content-disposition", "attachment;ProcurementReport.xls")
            Page.Response.ContentType = "application/ms-excel"
            Page.Response.Charset = ""
            Page.EnableViewState = False
            frm.Attributes("runat") = "server"
            Controls.Add(frm)
            frm.Controls.Add(grdQueryResult)
            frm.RenderControl(hw)
            Response.Write(sw.ToString())
            Response.End()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
      
    End Sub

    Public Shared Sub ExportToExel(ByVal grdvw As GridView, ByVal rptname As String)

        Dim attachment As String = "attachment; filename=" & rptname & ".xls"
        HttpContext.Current.Response.ClearContent()
        HttpContext.Current.Response.AddHeader("content-disposition", attachment)
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        Dim sw As New StringWriter()
        Dim htw As New HtmlTextWriter(sw)

        grdvw.AllowSorting = False
        grdvw.AllowPaging = False
        grdvw.AutoGenerateSelectButton = False
        grdvw.AutoGenerateEditButton = False
        grdvw.AutoGenerateDeleteButton = False
        grdvw.DataBind()

        ' Create a form to contain the grid
        Dim frm As New HtmlForm()
        grdvw.Parent.Controls.Add(frm)
        frm.Attributes("runat") = "server"
        frm.Controls.Add(grdvw)

        frm.RenderControl(htw)
        'grdvw.RenderControl(htw)
        HttpContext.Current.Response.Write(sw.ToString())
        HttpContext.Current.Response.[End]()

    End Sub

    Protected Sub ShowSupplierInfo()
        drpSupplier.DataValueField = "SupplierID"
        drpSupplier.DataTextField = "SupplierName"
        drpSupplier.DataSource = SupplierData.fnGetSupplier()
        drpSupplier.DataBind()

        Dim A As New ListItem

        A.Text = "N\A"
        A.Value = "N\A"
        drpSupplier.Items.Insert(0, A)

    End Sub

    Protected Sub ShowItemList()
        drpInventoryItems.DataTextField = "ItemName"
        drpInventoryItems.DataValueField = "ItemID"
        drpInventoryItems.DataSource = ItemData.fnGetItemList()
        drpInventoryItems.DataBind()

        Dim A As New ListItem

        A.Text = "N\A"
        A.Value = "N\A"

        drpInventoryItems.Items.Insert(0, A)

    End Sub

End Class
