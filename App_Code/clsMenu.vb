Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsMenu

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _MenuID, _MenuValue, _MenuName, _MenuHyperlink, _ParentMenu, _EntryBy As String

    Public Property MenuID() As String
        Get
            Return _MenuID
        End Get
        Set(ByVal value As String)
            _MenuID = value
        End Set
    End Property

    Public Property MenuValue() As String
        Get
            Return _MenuValue
        End Get
        Set(ByVal value As String)
            _MenuValue = value
        End Set
    End Property

    Public Property MenuName() As String
        Get
            Return _MenuName
        End Get
        Set(ByVal value As String)
            _MenuName = value
        End Set
    End Property

    Public Property MenuHyperlink() As String
        Get
            Return _MenuHyperlink
        End Get
        Set(ByVal value As String)
            _MenuHyperlink = value
        End Set
    End Property

    Public Property ParentMenu() As String
        Get
            Return _ParentMenu
        End Get
        Set(ByVal value As String)
            _ParentMenu = value
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

    Dim _MenuOrder As Integer

    Public Property MenuOrder() As Integer
        Get
            Return _MenuOrder
        End Get
        Set(ByVal value As Integer)
            _MenuOrder = value
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

#Region " Insert Menu "
    Public Function fnInsertMenu(ByVal Menu As clsMenu) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertMenu", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@MenuValue", Menu.MenuValue)
            cmd.Parameters.AddWithValue("@MenuName", Menu.MenuName)
            cmd.Parameters.AddWithValue("@MenuOrder", Menu.MenuOrder)
            cmd.Parameters.AddWithValue("@MenuHyperlink", Menu.MenuHyperlink)
            cmd.Parameters.AddWithValue("@ParentMenu", Menu.ParentMenu)
            cmd.Parameters.AddWithValue("@EntryBy", Menu.EntryBy)
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

#Region " Update Menu "
    Public Function fnUpdateMenu(ByVal Menu As clsMenu) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateMenu", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@MenuID", Menu.MenuID)
            cmd.Parameters.AddWithValue("@MenuValue", Menu.MenuValue)
            cmd.Parameters.AddWithValue("@MenuName", Menu.MenuName)
            cmd.Parameters.AddWithValue("@MenuOrder", Menu.MenuOrder)
            cmd.Parameters.AddWithValue("@MenuHyperlink", Menu.MenuHyperlink)
            cmd.Parameters.AddWithValue("@ParentMenu", Menu.ParentMenu)
            cmd.Parameters.AddWithValue("@EntryBy", Menu.EntryBy)
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

#Region " Get All Menu Info "

    Public Function fnGetAllMenuInfo() As DataSet
        Return fnCallDropDownLoader("spGetAllMenuInfo")
    End Function

#End Region

#Region " Get Child Nodes "

    Public Function fnGetChildNodes(ByVal ParameterValue As String) As DataSet
        Return fnCallDropDownLoader("spGetChildNodes", "@ParentMenu", ParameterValue)
    End Function

#End Region

#Region " Get Menu Info By ID "

    Public Function fnGetMenuInfoByID(ByVal MenuID As String) As clsMenu
        Dim sp As String = "spGetMenuInfoByID"
        Dim Menu As New clsMenu()
        Dim dr As SqlDataReader
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@MenuID", MenuID)
                dr = cmd.ExecuteReader()
                While dr.Read()
                    Menu.MenuID = dr.Item("MenuID")
                    Menu.MenuValue = dr.Item("MenuValue")
                    Menu.MenuName = dr.Item("MenuName")
                    Menu.MenuOrder = dr.Item("MenuOrder")
                    Menu.MenuHyperlink = dr.Item("MenuHyperlink")
                    Menu.ParentMenu = dr.Item("ParentMenu")
                End While
                con.Close()
                Return Menu
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
