Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsInvoiceItem

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _InvoiceItemID, _InvoiceID, _ItemID, _ItemName, _InvoiceItemList, _EntryBy As String

    Public Property InvoiceItemID() As String
        Get
            Return _InvoiceItemID
        End Get
        Set(ByVal value As String)
            _InvoiceItemID = value
        End Set
    End Property

    Public Property InvoiceID() As String
        Get
            Return _InvoiceID
        End Get
        Set(ByVal value As String)
            _InvoiceID = value
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

    Public Property ItemName() As String
        Get
            Return _ItemName
        End Get
        Set(ByVal value As String)
            _ItemName = value
        End Set
    End Property

    Public Property InvoiceItemList() As String
        Get
            Return _InvoiceItemList
        End Get
        Set(ByVal value As String)
            _InvoiceItemList = value
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

    Dim _Quantity As Integer

    Public Property Quantity() As Integer
        Get
            Return _Quantity
        End Get
        Set(ByVal value As Integer)
            _Quantity = value
        End Set
    End Property

    Dim _UnitPrice As Double

    Public Property UnitPrice() As Double
        Get
            Return _UnitPrice
        End Get
        Set(ByVal value As Double)
            _UnitPrice = value
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

#Region " Insert Multiple Invoice Items "

    Public Function fnInsertMultipleInvoiceItems(ByVal InvoiceItems As clsInvoiceItem) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertMultipleInvoiceItems", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@InvoiceID", InvoiceItems.InvoiceID)
            cmd.Parameters.AddWithValue("@InvoiceItemList", InvoiceItems.InvoiceItemList)
            cmd.Parameters.AddWithValue("@EntryBy", InvoiceItems.EntryBy)

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

#Region " Get Items By Invoice At Approval "

    Public Function fnGetItemsByInvoiceAtApp(ByVal InvoiceID As String) As DataSet

        Dim sp As String = "spGetItemsByInvoiceAtApp"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", InvoiceID)
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

#Region " Get Items By Invoice "

    Public Function fnGetItemsByInvoice(ByVal InvoiceID As String) As DataSet

        Dim sp As String = "spGetItemsByInvoice"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@InvoiceID", InvoiceID)
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

#Region " Get Item Invoice Quantity "

    Public Function fnGetItemInvoiceQuantity(ByVal InvoiceItems As clsInvoiceItem) As Integer
        Try
            Dim ItemQuantity As Integer = 0
            Dim dr As SqlDataReader
            Dim cmd As SqlCommand = New SqlCommand("spGetItemInvoiceQuantity", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@InvoiceID", InvoiceItems.InvoiceID)
            cmd.Parameters.AddWithValue("@ItemID", InvoiceItems.ItemID)

            dr = cmd.ExecuteReader()
            While dr.Read()
                ItemQuantity = dr.Item("Quantity")
            End While
            con.Close()

            Return ItemQuantity
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Get Procurement Info By Item "

    Public Function fnGetProcurementInfoByItem(ByVal ItemID As String) As DataSet

        Dim sp As String = "spGetProcurementInfoByItem"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ItemID", ItemID)
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
