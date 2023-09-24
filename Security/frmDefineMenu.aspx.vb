Imports System.Data

Partial Class Security_frmDefineMenu
    Inherits System.Web.UI.Page

    Dim MenuData As New clsMenu()

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click
        Try
            Dim Menu As New clsMenu()

            Menu.MenuValue = txtMenuValue.Text
            Menu.MenuName = txtMenuName.Text
            Menu.MenuOrder = Convert.ToInt32(txtMenuOrder.Text)
            Menu.MenuHyperlink = txtMenuHyperLink.Text
            Menu.ParentMenu = drpParentMenu.SelectedValue
            Menu.EntryBy = "dsamaddar"

            Dim result As clsResult = MenuData.fnInsertMenu(Menu)

            If result.Success = True Then
                GetParentMenuList()
                ClearForm()
                PopulateTreeView()
            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetParentMenuList()
        drpParentMenu.DataTextField = "MenuName"
        drpParentMenu.DataValueField = "MenuID"
        drpParentMenu.DataSource = MenuData.fnGetAllMenuInfo()
        drpParentMenu.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpParentMenu.Items.Insert(0, A)
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetParentMenuList()
            PopulateTreeView()
            btnInsert.Enabled = True
            btnUpdate.Enabled = False
        End If
    End Sub

    Protected Sub ClearForm()
        txtMenuHyperLink.Text = ""
        txtMenuName.Text = ""
        txtMenuOrder.Text = ""
        txtMenuValue.Text = ""
        drpParentMenu.SelectedIndex = -1
        hdFldMenuID.Value = ""

        trvwMenu.Nodes.Clear()

        btnInsert.Enabled = True
        btnUpdate.Enabled = False
    End Sub

    Protected Sub PopulateTreeView()
        trvwMenu.DataSource = Nothing
        trvwMenu.DataBind()

        Dim dt As New DataTable
        dt = MenuData.fnGetChildNodes("N\A").Tables(0)

        For Each dr As DataRow In dt.Rows
            Dim node As New TreeNode
            node.Value = dr.Item("MenuID").ToString()
            node.Text = dr.Item("MenuName").ToString()
            AddNodes(node)
            trvwMenu.Nodes.Add(node)
        Next

    End Sub

    Protected Sub AddNodes(ByRef node As TreeNode)
        Dim dt As New DataTable
        dt = MenuData.fnGetChildNodes(node.Value).Tables(0)

        For Each dr As DataRow In dt.Rows
            Dim cnode As New TreeNode
            cnode.Value = dr.Item("MenuID").ToString()
            cnode.Text = dr.Item("MenuName").ToString()
            AddNodes(cnode)
            node.ChildNodes.Add(cnode)
        Next
    End Sub

    Protected Sub trvwMenu_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles trvwMenu.SelectedNodeChanged
        Try
            Dim Menu As New clsMenu()
            Menu = MenuData.fnGetMenuInfoByID(trvwMenu.SelectedNode.Value)

            hdFldMenuID.Value = Menu.MenuID
            txtMenuName.Text = Menu.MenuName
            txtMenuValue.Text = Menu.MenuValue
            txtMenuOrder.Text = Menu.MenuOrder
            txtMenuHyperLink.Text = Menu.MenuHyperlink
            drpParentMenu.SelectedValue = Menu.ParentMenu

            btnInsert.Enabled = False
            btnUpdate.Enabled = True

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
        


    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Try
            Dim Menu As New clsMenu()

            If hdFldMenuID.Value = "" Then
                MessageBox("No Node is Selected.")
                Exit Sub
            End If

            Menu.MenuID = hdFldMenuID.Value
            Menu.MenuValue = txtMenuValue.Text
            Menu.MenuName = txtMenuName.Text
            Menu.MenuOrder = Convert.ToInt32(txtMenuOrder.Text)
            Menu.MenuHyperlink = txtMenuHyperLink.Text
            Menu.ParentMenu = drpParentMenu.SelectedValue
            Menu.EntryBy = "dsamaddar"

            Dim result As clsResult = MenuData.fnUpdateMenu(Menu)

            If result.Success = True Then
                GetParentMenuList()
                ClearForm()
                PopulateTreeView()
            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
