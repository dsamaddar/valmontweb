Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsInvoice

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _InvoiceID, _InvoiceNo, _SupplierID, _SubmittedBy, _ApproverID, _ApprovedBy, _RejectedBy, _EntryBy, _ItemID As String

    Public Property InvoiceID() As String
        Get
            Return _InvoiceID
        End Get
        Set(ByVal value As String)
            _InvoiceID = value
        End Set
    End Property

    Public Property InvoiceNo() As String
        Get
            Return _InvoiceNo
        End Get
        Set(ByVal value As String)
            _InvoiceNo = value
        End Set
    End Property

    Public Property SupplierID() As String
        Get
            Return _SupplierID
        End Get
        Set(ByVal value As String)
            _SupplierID = value
        End Set
    End Property

    Public Property SubmittedBy() As String
        Get
            Return _SubmittedBy
        End Get
        Set(ByVal value As String)
            _SubmittedBy = value
        End Set
    End Property

    Public Property ApproverID() As String
        Get
            Return _ApproverID
        End Get
        Set(ByVal value As String)
            _ApproverID = value
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

    Public Property RejectedBy() As String
        Get
            Return _RejectedBy
        End Get
        Set(ByVal value As String)
            _RejectedBy = value
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

    Public Property ItemID() As String
        Get
            Return _ItemID
        End Get
        Set(ByVal value As String)
            _ItemID = value
        End Set
    End Property

    Dim _InvoiceDate, _SubmissionDate, _ApprovalDate, _RejectionDate, _EntryDate, _PurchaseDateFrom, _PurchaseDateTo As DateTime

    Public Property InvoiceDate() As DateTime
        Get
            Return _InvoiceDate
        End Get
        Set(ByVal value As DateTime)
            _InvoiceDate = value
        End Set
    End Property

    Public Property SubmissionDate() As DateTime
        Get
            Return _SubmissionDate
        End Get
        Set(ByVal value As DateTime)
            _SubmissionDate = value
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

    Public Property PurchaseDateFrom() As DateTime
        Get
            Return _PurchaseDateFrom
        End Get
        Set(ByVal value As DateTime)
            _PurchaseDateFrom = value
        End Set
    End Property

    Public Property PurchaseDateTo() As DateTime
        Get
            Return _PurchaseDateTo
        End Get
        Set(ByVal value As DateTime)
            _PurchaseDateTo = value
        End Set
    End Property

    Dim _IsSubmitted, _IsApproved, _IsRejected As Boolean

    Public Property IsSubmitted() As Boolean
        Get
            Return _IsSubmitted
        End Get
        Set(ByVal value As Boolean)
            _IsSubmitted = value
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

    Dim _InvoiceCost As Double

    Public Property InvoiceCost() As Double
        Get
            Return _InvoiceCost
        End Get
        Set(ByVal value As Double)
            _InvoiceCost = value
        End Set
    End Property

#Region " Insert Invoice "

    Public Function fnInsertInvoice(ByVal Invoice As clsInvoice) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertInvoice", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@InvoiceNo", Invoice.InvoiceNo)
            cmd.Parameters.AddWithValue("@SupplierID", Invoice.SupplierID)
            cmd.Parameters.AddWithValue("@InvoiceDate", Invoice.InvoiceDate)
            cmd.Parameters.AddWithValue("@InvoiceCost", Invoice.InvoiceCost)
            cmd.Parameters.AddWithValue("@ApproverID", Invoice.ApproverID)
            cmd.Parameters.AddWithValue("@EntryBy", Invoice.EntryBy)

            cmd.ExecuteNonQuery()
            con.Close()
            Return 1
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Approve Invoice "

    Public Function fnApproveInvoice(ByVal Invoice As clsInvoice) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spApproveInvoice", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@InvoiceID", Invoice.InvoiceID)
            cmd.Parameters.AddWithValue("@ApprovedBy", Invoice.ApprovedBy)

            cmd.ExecuteNonQuery()
            con.Close()
            Return 1
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Reject Invoice "

    Public Function fnRejectInvoice(ByVal Invoice As clsInvoice) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spRejectInvoice", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@InvoiceID", Invoice.InvoiceID)
            cmd.Parameters.AddWithValue("@RejectedBy", Invoice.RejectedBy)

            cmd.ExecuteNonQuery()
            con.Close()
            Return 1
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Get Details Invoice List "

    Public Function fnGetDetailsInvoiceList() As DataSet

        Dim sp As String = "spGetDetailsInvoiceList"
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

#Region " Get Details Invoice List To Approve "

    Public Function fnGetDetailsInvLstToApprove(ByVal ApproverID As String) As DataSet

        Dim sp As String = "spGetDetailsInvLstToApprove"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ApproverID", ApproverID)
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

#Region " Get Approved Invoice Un Allocated "

    Public Function fnGetApprovedInvoiceUnAllocated() As DataSet

        Dim sp As String = "spGetApprovedInvoiceUnAllocated"
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

#Region " Show Procurement Report "

    Public Function fnShowProcurementReport(ByVal InvoiceInfo As clsInvoice) As DataSet

        Dim sp As String = "spShowProcurementReport"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceNo", InvoiceInfo.InvoiceNo)
                cmd.Parameters.AddWithValue("@PurchaseDateFrom", InvoiceInfo.PurchaseDateFrom)
                cmd.Parameters.AddWithValue("@PurchaseDateTo", InvoiceInfo.PurchaseDateTo)
                cmd.Parameters.AddWithValue("@ItemID", InvoiceInfo.ItemID)
                cmd.Parameters.AddWithValue("@SupplierID", InvoiceInfo.SupplierID)
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
