Imports System.Data

Partial Class Security_frmRoleWiseMenu
    Inherits System.Web.UI.Page

    Dim MenuData As New clsMenu()
    Dim RoleData As New clsRole()

    Protected Sub btnAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        Try
            Dim Role As New clsRole()
            Dim Menu As New clsMenu()
            Dim result As New clsResult()
            Dim checked As New List(Of TreeNode)
            Dim MenuList As String = ""
            Dim MenuValue As String = ""

            If hdFldRoleID.Value = "" Then
                Role.RoleName = txtRoleName.Text
                checked = GetCheckedNodes(trvwMenu)

                For i = 0 To checked.Count - 1
                    Menu = MenuData.fnGetMenuInfoByID(checked(i).Value)
                    MenuList &= "~" & Menu.MenuValue
                Next

                If chkIsActive.Checked = True Then
                    Role.IsActive = True
                Else
                    Role.IsActive = False
                End If

                Role.MenuList = MenuList
                Role.EntryBy = "dsamaddar"

                result = RoleData.fnInsertRole(Role)

                If result.Success = True Then
                    ClearForm()
                    GetRoleList()
                End If
                MessageBox(result.Message)
            Else
                '' Update Clause
                Role.RoleID = hdFldRoleID.Value
                Role.RoleName = txtRoleName.Text
                checked = GetCheckedNodes(trvwMenu)

                For i = 0 To checked.Count - 1
                    Menu = MenuData.fnGetMenuInfoByID(checked(i).Value)
                    MenuList &= "~" & Menu.MenuValue
                Next

                If chkIsActive.Checked = True Then
                    Role.IsActive = True
                Else
                    Role.IsActive = False
                End If

                Role.MenuList = MenuList
                Role.EntryBy = "dsamaddar"

                result = RoleData.fnUpdateRole(Role)

                If result.Success = True Then
                    ClearForm()
                    GetRoleList()
                End If
                MessageBox(result.Message)

            End If
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

    Private Function GetCheckedNodes(ByVal TV As TreeView) As List(Of TreeNode)
        Dim checked As New List(Of TreeNode)
        For Each node As TreeNode In trvwMenu.Nodes
            GetCheckedNodes(node, checked)
        Next
        Return checked
    End Function

    Private Sub GetCheckedNodes(ByVal tn As TreeNode, ByVal checked As List(Of TreeNode))
        If tn.Checked Then
            checked.Add(tn)
        End If
        For Each childNode As TreeNode In tn.ChildNodes
            GetCheckedNodes(childNode, checked)
        Next
    End Sub

    Private Sub GetCheckedNodes(ByVal tn As TreeNode, ByVal ClearSelection As Boolean)
        If tn.Checked Then
            tn.Checked = ClearSelection
        End If
        For Each childNode As TreeNode In tn.ChildNodes
            GetCheckedNodes(childNode, False)
        Next
    End Sub

    Private Sub GetCheckedNodes(ByVal tn As TreeNode, ByVal MenuList As String)
        Dim Menu As clsMenu = MenuData.fnGetMenuInfoByID(tn.Value)
        If MenuList.Contains(Menu.MenuValue) Then
            tn.Checked = True
        End If
        For Each childNode As TreeNode In tn.ChildNodes
            GetCheckedNodes(childNode, MenuList)
        Next
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            PopulateTreeView()
            GetRoleList()
        End If
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

    Protected Sub ClearForm()
        hdFldRoleID.Value = ""
        txtRoleName.Text = ""
        chkIsActive.Checked = False
        ClearNodeSelection()
    End Sub

    Protected Sub GetRoleList()
        drpRoleList.DataTextField = "RoleName"
        drpRoleList.DataValueField = "RoleID"
        drpRoleList.DataSource = RoleData.fnGetRoleInfo()
        drpRoleList.DataBind()
    End Sub

    Protected Sub ClearNodeSelection()
        For Each node As TreeNode In trvwMenu.Nodes
            GetCheckedNodes(node, False)
        Next
    End Sub

    Protected Sub drpRoleList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpRoleList.SelectedIndexChanged
        Try
            ClearNodeSelection()
            Dim Role As clsRole = RoleData.fnGetRoleInfoByID(drpRoleList.SelectedValue)

            hdFldRoleID.Value = Role.RoleID
            txtRoleName.Text = Role.RoleName
            If Role.IsActive = True Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

            For Each node As TreeNode In trvwMenu.Nodes
                GetCheckedNodes(node, Role.MenuList)
            Next

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
