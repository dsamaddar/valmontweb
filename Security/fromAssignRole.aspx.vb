
Partial Class Security_fromAssignRole
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim RoleData As New clsRole()
    Dim RoleAssignmentData As New clsRoleAssignment()

    Protected Sub btnRightAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRightAll.Click
        Dim Exists As Boolean = False
        For Each A As ListItem In lstBxAvailableRole.Items
            For Each B As ListItem In lstBxAssignedRole.Items
                If B.Value = A.Value Then
                    Exists = True
                    Exit For
                End If
            Next

            If Exists = False Then
                lstBxAssignedRole.Items.Add(A)
            End If
        Next
    End Sub

    Protected Sub btnRight_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRight.Click
        Try
            If lstBxAvailableRole.SelectedIndex = -1 Then
                MessageBox("No Role Selected.")
                Exit Sub
            End If

            Dim Exists As Boolean = False
            For Each B As ListItem In lstBxAssignedRole.Items
                If B.Value = lstBxAvailableRole.SelectedValue Then
                    Exists = True
                    Exit For
                End If
            Next

            If Exists = False Then
                lstBxAssignedRole.Items.Add(lstBxAvailableRole.SelectedItem)
                lstBxAssignedRole.DataBind()
            End If

            lstBxAvailableRole.SelectedIndex = -1
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

    Protected Sub btnLeft_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLeft.Click
        Try
            If lstBxAssignedRole.SelectedIndex = -1 Then
                MessageBox("No Role Selected.")
                Exit Sub
            End If
            lstBxAssignedRole.Items.Remove(lstBxAssignedRole.SelectedItem)
            lstBxAssignedRole.DataBind()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetEmployeeList()
            GetRoleList()

            If drpUserList.Items.Count > 0 Then
                GetAssignedRoles(drpUserList.SelectedValue)
            End If
        End If
    End Sub

    Protected Sub GetEmployeeList()
        drpUserList.DataTextField = "EmployeeName"
        drpUserList.DataValueField = "EmployeeID"
        drpUserList.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpUserList.DataBind()
    End Sub

    Protected Sub GetRoleList()
        lstBxAvailableRole.DataTextField = "RoleName"
        lstBxAvailableRole.DataValueField = "RoleID"
        lstBxAvailableRole.DataSource = RoleData.fnGetRoleInfo()
        lstBxAvailableRole.DataBind()
    End Sub

    Protected Sub drpUserList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpUserList.SelectedIndexChanged
        Try
            lstBxAssignedRole.Items.Clear()
            GetAssignedRoles(drpUserList.SelectedValue)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetAssignedRoles(ByVal EmployeeID As String)
        lstBxAssignedRole.DataTextField = "RoleName"
        lstBxAssignedRole.DataValueField = "RoleID"
        lstBxAssignedRole.DataSource = RoleAssignmentData.fnGetAssignedRoleByEmployee(EmployeeID)
        lstBxAssignedRole.DataBind()
    End Sub

    Protected Sub btnAssignRole_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAssignRole.Click
        Try
            Dim RoleAssignment As New clsRoleAssignment()
            Dim result As New clsResult()

            Dim RoleList As String = ""

            For Each item As ListItem In lstBxAssignedRole.Items
                RoleList &= item.Value & ","
            Next


            If RoleList.Length > 0 Then
                RoleList = RoleList.Substring(0, RoleList.Length - 1)
            End If

            RoleAssignment.EmployeeID = drpUserList.SelectedValue
            RoleAssignment.RoleList = RoleList
            RoleAssignment.EntryBy = "dsamaddar"

            result = RoleAssignmentData.fnInsertRoleAssignmentList(RoleAssignment)

            If result.Success = True Then

            End If

            MessageBox(result.Message)

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
