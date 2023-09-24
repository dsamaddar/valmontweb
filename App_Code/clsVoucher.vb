Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsVoucher

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _VoucherID, _VoucherNo, _VoucherDetails, _EventName, _Narration, _ApprovedBy, _ApproverRemarks, _RejectedBy, _RejectionRemarks, _VoucherStatus, _EntryBy As String

    Public Property VoucherID() As String
        Get
            Return _VoucherID
        End Get
        Set(ByVal value As String)
            _VoucherID = value
        End Set
    End Property

    Public Property VoucherNo() As String
        Get
            Return _VoucherNo
        End Get
        Set(ByVal value As String)
            _VoucherNo = value
        End Set
    End Property

    Public Property VoucherDetails() As String
        Get
            Return _VoucherDetails
        End Get
        Set(ByVal value As String)
            _VoucherDetails = value
        End Set
    End Property

    Public Property EventName() As String
        Get
            Return _EventName
        End Get
        Set(ByVal value As String)
            _EventName = value
        End Set
    End Property

    Public Property Narration() As String
        Get
            Return _Narration
        End Get
        Set(ByVal value As String)
            _Narration = value
        End Set
    End Property

    Public Property ApprovedBy() As String
        Get
            Return _ApprovedBy
        End Get
        Set(ByVal value As String)
            _ApprovedBy = value
        End Set
    End Property

    Public Property ApproverRemarks() As String
        Get
            Return _ApproverRemarks
        End Get
        Set(ByVal value As String)
            _ApproverRemarks = value
        End Set
    End Property

    Public Property RejectedBy() As String
        Get
            Return _RejectedBy
        End Get
        Set(ByVal value As String)
            _RejectedBy = value
        End Set
    End Property

    Public Property RejectionRemarks() As String
        Get
            Return _RejectionRemarks
        End Get
        Set(ByVal value As String)
            _RejectionRemarks = value
        End Set
    End Property

    Public Property VoucherStatus() As String
        Get
            Return _VoucherStatus
        End Get
        Set(ByVal value As String)
            _VoucherStatus = value
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

    Dim _TransactionDate, _SystemDate, _ApprovalDate, _RejectionDate, _EntryDate As DateTime

    Public Property TransactionDate() As DateTime
        Get
            Return _TransactionDate
        End Get
        Set(ByVal value As DateTime)
            _TransactionDate = value
        End Set
    End Property

    Public Property SystemDate() As DateTime
        Get
            Return _SystemDate
        End Get
        Set(ByVal value As DateTime)
            _SystemDate = value
        End Set
    End Property

    Public Property ApprovalDate() As DateTime
        Get
            Return _ApprovalDate
        End Get
        Set(ByVal value As DateTime)
            _ApprovalDate = value
        End Set
    End Property

    Public Property RejectionDate() As DateTime
        Get
            Return _RejectionDate
        End Get
        Set(ByVal value As DateTime)
            _RejectionDate = value
        End Set
    End Property

    Public Property EntryDate() As DateTime
        Get
            Return _EntryDate
        End Get
        Set(ByVal value As DateTime)
            _EntryDate = value
        End Set
    End Property

    Dim _IsPosted, _IsApproved, _IsRejected As Boolean

    Public Property IsPosted() As Boolean
        Get
            Return _IsPosted
        End Get
        Set(ByVal value As Boolean)
            _IsPosted = value
        End Set
    End Property

    Public Property IsApproved() As Boolean
        Get
            Return _IsApproved
        End Get
        Set(ByVal value As Boolean)
            _IsApproved = value
        End Set
    End Property

    Public Property IsRejected() As Boolean
        Get
            Return _IsRejected
        End Get
        Set(ByVal value As Boolean)
            _IsRejected = value
        End Set
    End Property

#Region " Insert Voucher "

    Public Function fnInsertVoucher(ByVal Voucher As clsVoucher) As clsResult
        Dim result As New clsResult()
        Try

            Dim cmd As SqlCommand = New SqlCommand("spInsertVoucher", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@VoucherNo", Voucher.VoucherNo)
            cmd.Parameters.AddWithValue("@EventName", Voucher.EventName)
            cmd.Parameters.AddWithValue("@TransactionDate", Voucher.TransactionDate)
            cmd.Parameters.AddWithValue("@SystemDate", Voucher.SystemDate)
            cmd.Parameters.AddWithValue("@Narration", Voucher.Narration)
            cmd.Parameters.AddWithValue("@VoucherDetails", Voucher.VoucherDetails)
            cmd.Parameters.AddWithValue("@EntryBy", Voucher.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Submitted Successfully."
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = ex.Message
            Return result
        End Try
    End Function

#End Region

#Region " Get Current VoucherNo "

    Public Function fnGetCurrentVoucherNo() As Double
        Try
            Dim CurrentVoucherNo As Double = 0
            Dim dr As SqlDataReader
            Dim cmd As SqlCommand = New SqlCommand("spGetCurrentVoucherNo", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            dr = cmd.ExecuteReader()
            While dr.Read()
                CurrentVoucherNo = dr.Item("CurrentVoucherNo")
            End While
            con.Close()

            Return CurrentVoucherNo
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Get Pending Transactions "

    Public Function fnGetPendingTransactions() As DataSet

        Dim sp As String = "spGetPendingTransactions"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
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

#Region " Authorize Transaction "

    Public Function fnAuthorizeTransaction(ByVal Voucher As clsVoucher) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spAuthorizeTransaction", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@VoucherID", Voucher.VoucherID)
            cmd.Parameters.AddWithValue("@VoucherStatus", Voucher.VoucherStatus)
            cmd.Parameters.AddWithValue("@Narration", Voucher.Narration)
            cmd.Parameters.AddWithValue("@EntryBy", Voucher.EntryBy)

            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Authorization Successful."
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = ex.Message
            Return result
        End Try
    End Function

#End Region

End Class
