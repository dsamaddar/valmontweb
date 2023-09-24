Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsRateSetup

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _RateSetupID, _BuyerID, _OrderID, _StyleID, _SizeID, _ColorID, _ComponentID, _EntryBy As String

    Public Property RateSetupID() As String
        Get
            Return _RateSetupID
        End Get
        Set(ByVal value As String)
            _RateSetupID = value
        End Set
    End Property

    Public Property BuyerID() As String
        Get
            Return _BuyerID
        End Get
        Set(ByVal value As String)
            _BuyerID = value
        End Set
    End Property

    Public Property OrderID() As String
        Get
            Return _OrderID
        End Get
        Set(ByVal value As String)
            _OrderID = value
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

    Public Property SizeID() As String
        Get
            Return _SizeID
        End Get
        Set(ByVal value As String)
            _SizeID = value
        End Set
    End Property

    Public Property ColorID() As String
        Get
            Return _ColorID
        End Get
        Set(ByVal value As String)
            _ColorID = value
        End Set
    End Property

    Public Property ComponentID() As String
        Get
            Return _ComponentID
        End Get
        Set(ByVal value As String)
            _ComponentID = value
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

    Dim _Rate As Double

    Public Property Rate() As Double
        Get
            Return _Rate
        End Get
        Set(ByVal value As Double)
            _Rate = value
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

#Region " Insert Rate Setup "

    Public Function fnInsertRateSetup(ByVal RateSetup As clsRateSetup) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertRateSetup", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", RateSetup.BuyerID)
            cmd.Parameters.AddWithValue("@OrderID", RateSetup.OrderID)
            cmd.Parameters.AddWithValue("@StyleID", RateSetup.StyleID)
            cmd.Parameters.AddWithValue("@SizeID", RateSetup.SizeID)
            cmd.Parameters.AddWithValue("@ColorID", RateSetup.ColorID)
            cmd.Parameters.AddWithValue("@ComponentID", RateSetup.ComponentID)
            cmd.Parameters.AddWithValue("@Rate", RateSetup.Rate)
            cmd.Parameters.AddWithValue("@EntryBy", RateSetup.EntryBy)
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

#Region " Update Rate Setup "

    Public Function fnUpdateRateSetup(ByVal RateSetup As clsRateSetup) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateRateSetup", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@RateSetupID", RateSetup.RateSetupID)
            cmd.Parameters.AddWithValue("@BuyerID", RateSetup.BuyerID)
            cmd.Parameters.AddWithValue("@OrderID", RateSetup.OrderID)
            cmd.Parameters.AddWithValue("@StyleID", RateSetup.StyleID)
            cmd.Parameters.AddWithValue("@SizeID", RateSetup.SizeID)
            cmd.Parameters.AddWithValue("@ColorID", RateSetup.ColorID)
            cmd.Parameters.AddWithValue("@ComponentID", RateSetup.ComponentID)
            cmd.Parameters.AddWithValue("@Rate", RateSetup.Rate)
            cmd.Parameters.AddWithValue("@EntryBy", RateSetup.EntryBy)
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

#Region " Get Rate Setup List "

    Public Function fnGetRateSetupList() As DataSet
        Return fnCallDropDownLoader("spGetRateSetupList")
    End Function

#End Region

End Class
