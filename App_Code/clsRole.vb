Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsRole

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _RoleID, _RoleName, _MenuList, _EntryBy As String

    Public Property RoleID() As String
        Get
            Return _RoleID
        End Get
        Set(ByVal value As String)
            _RoleID = value
        End Set
    End Property

    Public Property RoleName() As String
        Get
            Return _RoleName
        End Get
        Set(ByVal value As String)
            _RoleName = value
        End Set
    End Property

    Public Property MenuList() As String
        Get
            Return _MenuList
        End Get
        Set(ByVal value As String)
            _MenuList = value
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

    Dim _IsActive As Boolean

    Public Property IsActive() As Boolean
        Get
            Return _IsActive
        End Get
        Set(ByVal value As Boolean)
            _IsActive = value
        End Set
    End Property

#Region " Insert Role "
    Public Function fnInsertRole(ByVal Role As clsRole) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertRole", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@RoleName", Role.RoleName)
            cmd.Parameters.AddWithValue("@MenuList", Role.MenuList)
            cmd.Parameters.AddWithValue("@IsActive", Role.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Role.EntryBy)
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

#Region " Update Role "
    Public Function fnUpdateRole(ByVal Role As clsRole) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateRole", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@RoleID", Role.RoleID)
            cmd.Parameters.AddWithValue("@RoleName", Role.RoleName)
            cmd.Parameters.AddWithValue("@MenuList", Role.MenuList)
            cmd.Parameters.AddWithValue("@IsActive", Role.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Role.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Updated."
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

#Region " Get Role Info "

    Public Function fnGetRoleInfo() As DataSet
        Return fnCallDropDownLoader("spGetRoleInfo")
    End Function

#End Region

#Region " Get Role Info By ID "

    Public Function fnGetRoleInfoByID(ByVal RoleID As String) As clsRole
        Dim sp As String = "spGetRoleInfoByID"
        Dim Role As New clsRole()
        Dim dr As SqlDataReader
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@RoleID", RoleID)
                dr = cmd.ExecuteReader()
                While dr.Read()
                    Role.RoleID = dr.Item("RoleID")
                    Role.RoleName = dr.Item("RoleName")
                    Role.MenuList = dr.Item("MenuList")
                    Role.IsActive = dr.Item("IsActive")
                    Role.EntryBy = dr.Item("EntryBy")
                    Role.EntryDate = dr.Item("EntryDate")
                End While
                con.Close()
                Return Role
            End Using
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return Nothing
        End Try
    End Function

#End Region

End Class
