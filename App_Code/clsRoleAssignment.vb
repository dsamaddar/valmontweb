Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsRoleAssignment

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _RoleAssignID, _EmployeeID, _RoleID, _RoleList, _EntryBy As String

    Public Property RoleAssignID() As String
        Get
            Return _RoleAssignID
        End Get
        Set(ByVal value As String)
            _RoleAssignID = value
        End Set
    End Property

    Public Property EmployeeID() As String
        Get
            Return _EmployeeID
        End Get
        Set(ByVal value As String)
            _EmployeeID = value
        End Set
    End Property

    Public Property RoleID() As String
        Get
            Return _RoleID
        End Get
        Set(ByVal value As String)
            _RoleID = value
        End Set
    End Property

    Public Property RoleList() As String
        Get
            Return _RoleList
        End Get
        Set(ByVal value As String)
            _RoleList = value
        End Set
    End Property

    Public Property EntryBy() As String
        Get
            Return _EntryBy
        End Get
        Set(ByVal value As String)
            _EntryBy = value
        End Set
    End Property

    Dim _EntryDate As DateTime

    Public Property EntryDate() As DateTime
        Get
            Return _EntryDate
        End Get
        Set(ByVal value As DateTime)
            _EntryDate = value
        End Set
    End Property

#Region " Insert Role Assignment List "
    Public Function fnInsertRoleAssignmentList(ByVal RoleAssign As clsRoleAssignment) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertRoleAssignmentList", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", RoleAssign.EmployeeID)
            cmd.Parameters.AddWithValue("@RoleList", RoleAssign.RoleList)
            cmd.Parameters.AddWithValue("@EntryBy", RoleAssign.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Inserted."
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = "Error Found : " & ex.Message
            Return result
        End Try
    End Function
#End Region

#Region " Get Assigned Role By Employee "

    Public Function fnGetAssignedRoleByEmployee(ByVal EmployeeID As String) As DataSet
        Return fnCallDropDownLoader("spGetAssignedRoleByEmployee", "EmployeeID", EmployeeID)
    End Function

#End Region

End Class
