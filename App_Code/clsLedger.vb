Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsLedger

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _LedgerID, _LedgerTypeID, _LedgerName, _LedgerCode, _ParentLedgerID, _BalanceType, _EntryBy As String

    Public Property LedgerID() As String
        Get
            Return _LedgerID
        End Get
        Set(ByVal value As String)
            _LedgerID = value
        End Set
    End Property

    Public Property LedgerTypeID() As String
        Get
            Return _LedgerTypeID
        End Get
        Set(ByVal value As String)
            _LedgerTypeID = value
        End Set
    End Property

    Public Property LedgerName() As String
        Get
            Return _LedgerName
        End Get
        Set(ByVal value As String)
            _LedgerName = value
        End Set
    End Property

    Public Property LedgerCode() As String
        Get
            Return _LedgerCode
        End Get
        Set(ByVal value As String)
            _LedgerCode = value
        End Set
    End Property

    Public Property ParentLedgerID() As String
        Get
            Return _ParentLedgerID
        End Get
        Set(ByVal value As String)
            _ParentLedgerID = value
        End Set
    End Property

    Public Property BalanceType() As String
        Get
            Return _BalanceType
        End Get
        Set(ByVal value As String)
            _BalanceType = value
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

    Dim _IsBankAccount As Boolean

    Public Property IsBankAccount() As Boolean
        Get
            Return _IsBankAccount
        End Get
        Set(ByVal value As Boolean)
            _IsBankAccount = value
        End Set
    End Property

#Region " Insert Ledger "

    Public Function fnInsertLedger(ByVal Ledger As clsLedger) As clsResult

        Dim Result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertLedger", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@LedgerTypeID", Ledger.LedgerTypeID)
            cmd.Parameters.AddWithValue("@LedgerName", Ledger.LedgerName)
            cmd.Parameters.AddWithValue("@ParentLedgerID", Ledger.ParentLedgerID)
            cmd.Parameters.AddWithValue("@LedgerCode", Ledger.LedgerCode)
            cmd.Parameters.AddWithValue("@IsBankAccount", Ledger.IsBankAccount)
            cmd.Parameters.AddWithValue("@BalanceType", Ledger.BalanceType)
            cmd.Parameters.AddWithValue("@EntryBy", Ledger.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()

            Result.Success = True
            Result.Message = "Successfully Inserted."
            Return Result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Result.Success = False
            Result.Message = "Error:" & ex.Message.ToString()
            Return Result
        End Try
    End Function

#End Region

#Region " Get Ledger Head List "

    Public Function fnGetLedgerHeadList() As DataSet

        Dim sp As String = "spGetLedgerHeadList"
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
