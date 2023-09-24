Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsVoucherDetails

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _VoucherDetailsID, _VoucherID, _LedgerID, _LedgerName, _TransactionType, _Reference, _ReferenceType As String

    Public Property VoucherDetailsID() As String
        Get
            Return _VoucherDetailsID
        End Get
        Set(ByVal value As String)
            _VoucherDetailsID = value
        End Set
    End Property

    Public Property VoucherID() As String
        Get
            Return _VoucherID
        End Get
        Set(ByVal value As String)
            _VoucherID = value
        End Set
    End Property

    Public Property LedgerID() As String
        Get
            Return _LedgerID
        End Get
        Set(ByVal value As String)
            _LedgerID = value
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

    Public Property TransactionType() As String
        Get
            Return _TransactionType
        End Get
        Set(ByVal value As String)
            _TransactionType = value
        End Set
    End Property

    Public Property Reference() As String
        Get
            Return _Reference
        End Get
        Set(ByVal value As String)
            _Reference = value
        End Set
    End Property

    Public Property ReferenceType() As String
        Get
            Return _ReferenceType
        End Get
        Set(ByVal value As String)
            _ReferenceType = value
        End Set
    End Property

    Dim _Debit, _Credit As Double

    Public Property Debit() As Double
        Get
            Return _Debit
        End Get
        Set(ByVal value As Double)
            _Debit = value
        End Set
    End Property

    Public Property Credit() As Double
        Get
            Return _Credit
        End Get
        Set(ByVal value As Double)
            _Credit = value
        End Set
    End Property

    Dim _EntryNo As Integer

    Public Property EntryNo() As Integer
        Get
            Return _EntryNo
        End Get
        Set(ByVal value As Integer)
            _EntryNo = value
        End Set
    End Property

#Region " Get Transaction Details "

    Public Function fnGetTransactionDetails(ByVal VoucherID As String) As DataSet

        Dim sp As String = "spGetTransactionDetails"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@VoucherID", VoucherID)
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
