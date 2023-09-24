Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsColor

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _ColorID, _ColorName, _EntryBy As String

    Public Property ColorID() As String
        Get
            Return _ColorID
        End Get
        Set(ByVal value As String)
            _ColorID = value
        End Set
    End Property

    Public Property ColorName() As String
        Get
            Return _ColorName
        End Get
        Set(ByVal value As String)
            _ColorName = value
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

#Region " Insert Color "

    Public Function fnInsertColor(ByVal Color As clsColor) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertColor", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ColorName", Color.ColorName)
            cmd.Parameters.AddWithValue("@IsActive", Color.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Color.EntryBy)
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

#Region " Update Color "

    Public Function fnUpdateColor(ByVal Color As clsColor) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateColor", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ColorID", Color.ColorID)
            cmd.Parameters.AddWithValue("@ColorName", Color.ColorName)
            cmd.Parameters.AddWithValue("@IsActive", Color.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Color.EntryBy)
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

#Region " Get Colors "

    Public Function fnGetColors() As DataSet
        Return fnCallDropDownLoader("spGetColors")
    End Function

#End Region

End Class
