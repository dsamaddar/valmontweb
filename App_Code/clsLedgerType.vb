Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsLedgerType

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _LedgerTypeID, _LedgerType, _EntryBy As String

    Public Property LedgerTypeID() As String
        Get
            Return _LedgerTypeID
        End Get
        Set(ByVal value As String)
            _LedgerTypeID = value
        End Set
    End Property

    Public Property LedgerType() As String
        Get
            Return _LedgerType
        End Get
        Set(ByVal value As String)
            _LedgerType = value
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

#Region " Insert Ledger Type "

    Public Function fnInsertLedgerType(ByVal LedgerType As clsLedgerType) As clsResult
        Dim Result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertLedgerType", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@LedgerType", LedgerType.LedgerType)
            cmd.Parameters.AddWithValue("@EntryBy", LedgerType.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()

            Result.Success = True
            Result.Message = "Inserted Successfully."

            Return Result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Result.Success = False
            Result.Message = ex.Message
            Return Result
        End Try
    End Function

#End Region

#Region " Get Ledger Type List "

    Public Function fnGetLedgerTypeList() As DataSet

        Dim sp As String = "spGetLedgerTypeList"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                da.SelectCommand = cmd
                da.Fill(ds)
                con.Close()
                Return ds
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
