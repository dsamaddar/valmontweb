Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsStyle

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _BuyerID, _StyleID, _Style, _Code, _StyleDescription, _EntryBy As String

    Public Property BuyerID() As String
        Get
            Return _BuyerID
        End Get
        Set(ByVal value As String)
            _BuyerID = value
        End Set
    End Property

    Public Property StyleID() As String
        Get
            Return _StyleID
        End Get
        Set(ByVal value As String)
            _StyleID = value
        End Set
    End Property

    Public Property Style() As String
        Get
            Return _Style
        End Get
        Set(ByVal value As String)
            _Style = value
        End Set
    End Property

    Public Property Code() As String
        Get
            Return _Code
        End Get
        Set(ByVal value As String)
            _Code = value
        End Set
    End Property

    Public Property StyleDescription() As String
        Get
            Return _StyleDescription
        End Get
        Set(ByVal value As String)
            _StyleDescription = value
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

#Region " Insert Style "

    Public Function fnInsertStyle(ByVal Style As clsStyle) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertStyle", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", Style.BuyerID)
            cmd.Parameters.AddWithValue("@Style", Style.Style)
            cmd.Parameters.AddWithValue("@Code", Style.Code)
            cmd.Parameters.AddWithValue("@StyleDescription", Style.StyleDescription)
            cmd.Parameters.AddWithValue("@IsActive", Style.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Style.EntryBy)
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

#Region " Update Style "

    Public Function fnUpdateStyle(ByVal Style As clsStyle) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateStyle", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@StyleID", Style.StyleID)
            cmd.Parameters.AddWithValue("@BuyerID", Style.BuyerID)
            cmd.Parameters.AddWithValue("@Style", Style.Style)
            cmd.Parameters.AddWithValue("@Code", Style.Code)
            cmd.Parameters.AddWithValue("@StyleDescription", Style.StyleDescription)
            cmd.Parameters.AddWithValue("@IsActive", Style.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Style.EntryBy)
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

#Region " Get Style Info "

    Public Function fnGetStyleInfo() As DataSet
        Return fnCallDropDownLoader("spGetStyleInfo")
    End Function

#End Region

#Region " Get Style Info By Buyer "

    Public Function fnGetStyleInfo(ByVal BuyerID As String) As DataSet
        Return fnCallDropDownLoader("spGetStyleInfoByBuyer", "BuyerID", BuyerID)
    End Function

#End Region

End Class
