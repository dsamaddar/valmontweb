
Partial Class AIMaster
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Try
                lblLoggedInUser.Text = "Welcome " + Session("EmployeeName")

                Dim mnu As New Menu
                Dim MenuIDs As String

                mnu = Me.FindControl("mnuControl")
                MenuIDs = Session("PermittedMenus")

                mnu.Items(0).Enabled = IIf(InStr(MenuIDs, "~inv_requisition"), True, False)
                mnu.Items(0).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_genrequisition"), True, False)
                mnu.Items(0).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_ondemandrequisition"), True, False)
                mnu.Items(0).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~inv_requisitionapproval"), True, False)

                mnu.Items(1).Enabled = IIf(InStr(MenuIDs, "~inv_requisitionctrl"), True, False)
                mnu.Items(1).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_acceptrequisitionS"), True, False)
                mnu.Items(1).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_acceptrequisitionM"), True, False)
                mnu.Items(1).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~inv_deliverrequisition"), True, False)

                mnu.Items(2).Enabled = IIf(InStr(MenuIDs, "~inv_procurement"), True, False)
                mnu.Items(2).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_invoiceentry"), True, False)
                mnu.Items(2).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_procurementdetails"), True, False)
                mnu.Items(2).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~inv_procurementapproval"), True, False)

                mnu.Items(3).Enabled = IIf(InStr(MenuIDs, "~inv_itembalancemgt"), True, False)
                mnu.Items(3).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_proctoware"), True, False)
                mnu.Items(3).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_waretoware"), True, False)

                mnu.Items(4).Enabled = IIf(InStr(MenuIDs, "~inv_reports"), True, False)
                mnu.Items(4).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_rptreqhistory"), True, False)
                mnu.Items(4).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_rptdeliveredreq"), True, False)
                mnu.Items(4).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~inv_rptprocurement"), True, False)
                mnu.Items(4).ChildItems(3).Enabled = IIf(InStr(MenuIDs, "~inv_rptrequisition"), True, False)
                mnu.Items(4).ChildItems(4).Enabled = IIf(InStr(MenuIDs, "~inv_rptlowbalance"), True, False)
                mnu.Items(4).ChildItems(5).Enabled = IIf(InStr(MenuIDs, "~inv_warebalance"), True, False)
                mnu.Items(4).ChildItems(6).Enabled = IIf(InStr(MenuIDs, "~inv_tembalancestat"), True, False)

                mnu.Items(5).Enabled = IIf(InStr(MenuIDs, "~inv_administration"), True, False)
                mnu.Items(5).ChildItems(0).Enabled = IIf(InStr(MenuIDs, "~inv_waremgt"), True, False)
                mnu.Items(5).ChildItems(1).Enabled = IIf(InStr(MenuIDs, "~inv_itemmgt"), True, False)
                mnu.Items(5).ChildItems(2).Enabled = IIf(InStr(MenuIDs, "~inv_unitmgt"), True, False)
                mnu.Items(5).ChildItems(3).Enabled = IIf(InStr(MenuIDs, "~inv_suppliermgt"), True, False)
                mnu.Items(5).ChildItems(4).Enabled = IIf(InStr(MenuIDs, "~inv_buyermgt"), True, False)
                mnu.Items(5).ChildItems(5).Enabled = IIf(InStr(MenuIDs, "~inv_colormgt"), True, False)
                mnu.Items(5).ChildItems(6).Enabled = IIf(InStr(MenuIDs, "~inv_stylemgt"), True, False)
                mnu.Items(5).ChildItems(7).Enabled = IIf(InStr(MenuIDs, "~inv_ordermgt"), True, False)
            Catch ex As Exception
                MessageBox(ex.Message)
            End Try
        End If
    End Sub



    Protected Sub lnkBtnLogOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBtnLogOut.Click
        Session("UniqueUserID") = ""
        Session("EmployeeName") = ""
        Session("LoginUserID") = ""
        Session("PermittedMenus") = ""
        Response.Redirect("~\frmLogin.aspx")
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

End Class

