Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsSize

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _SizeID, _Size, _EntryBy As String

    Public Property SizeID() As String
        Get
            Return _SizeID
        End Get
        Set(ByVal value As String)
            _SizeID = value
        End Set
    End Property

    Public Property Size() As String
        Get
            Return _Size
        End Get
        Set(ByVal value As String)
            _Size = value
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

#Region " Get Size List "

    Public Function fnGetSizeList() As DataSet
        Return fnCallDropDownLoader("spGetSizeList")
    End Function

#End Region

#Region " Insert Size "

    Public Function fnInsertSize(ByVal Size As clsSize) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertSize", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Size", Size.Size)
            cmd.Parameters.AddWithValue("@IsActive", Size.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Size.EntryBy)
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

#Region " Update Size "

    Public Function fnUpdateSize(ByVal Size As clsSize) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateSize", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SizeID", Size.SizeID)
            cmd.Parameters.AddWithValue("@Size", Size.Size)
            cmd.Parameters.AddWithValue("@IsActive", Size.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Size.EntryBy)
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
