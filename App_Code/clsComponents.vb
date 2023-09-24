Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsComponents

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _ComponentID, _ComponentName, _EntryBy As String

    Public Property ComponentID() As String
        Get
            Return _ComponentID
        End Get
        Set(ByVal value As String)
            _ComponentID = value
        End Set
    End Property

    Public Property ComponentName() As String
        Get
            Return _ComponentName
        End Get
        Set(ByVal value As String)
            _ComponentName = value
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

    Dim _IsActive As Boolean

    Public Property IsActive() As Boolean
        Get
            Return _IsActive
        End Get
        Set(ByVal value As Boolean)
            _IsActive = value
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

#Region " Get Component List "

    Public Function fnGetComponentList() As DataSet
        Return fnCallDropDownLoader("spGetComponentList")
    End Function

#End Region


#Region " Insert Component "

    Public Function fnInsertComponent(ByVal Component As clsComponents) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertComponent", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ComponentName", Component.ComponentName)
            cmd.Parameters.AddWithValue("@IsActive", Component.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Component.EntryBy)
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
            result.Message = "Error: " & ex.Message
            Return result
        End Try
    End Function

#End Region


#Region " Update Component "

    Public Function fnUpdateComponent(ByVal component As clsComponents) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateComponent", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ComponentID", component.ComponentID)
            cmd.Parameters.AddWithValue("@ComponentName", component.ComponentName)
            cmd.Parameters.AddWithValue("@IsActive", component.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", component.EntryBy)
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
            result.Message = "Error: " & ex.Message
            Return result
        End Try
    End Function

#End Region

End Class
