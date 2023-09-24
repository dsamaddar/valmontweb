Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsWarehouseItem

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _WarehouseItemID, _WarehouseID, _WarehouseName, _InvoiceID, _ItemID, _ItemName, _EntryBy, _WarehouseItemList As String

    Public Property WarehouseItemID() As String
        Get
            Return _WarehouseItemID
        End Get
        Set(ByVal value As String)
            _WarehouseItemID = value
        End Set
    End Property

    Public Property WarehouseID() As String
        Get
            Return _WarehouseID
        End Get
        Set(ByVal value As String)
            _WarehouseID = value
        End Set
    End Property

    Public Property WarehouseName() As String
        Get
            Return _WarehouseName
        End Get
        Set(ByVal value As String)
            _WarehouseName = value
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

    Public Property EntryBy() As String
        Get
            Return _EntryBy
        End Get
        Set(ByVal value As String)
            _EntryBy = value
        End Set
    End Property

    Public Property WarehouseItemList() As String
        Get
            Return _WarehouseItemList
        End Get
        Set(ByVal value As String)
            _WarehouseItemList = value
        End Set
    End Property

    Dim _ItemBalance, _AdjustedBalance As Integer

    Public Property ItemBalance() As Integer
        Get
            Return _ItemBalance
        End Get
        Set(ByVal value As Integer)
            _ItemBalance = value
        End Set
    End Property

    Public Property AdjustedBalance() As Integer
        Get
            Return _AdjustedBalance
        End Get
        Set(ByVal value As Integer)
            _AdjustedBalance = value
        End Set
    End Property

    Dim _AdjustmentDate, _EntryDate As DateTime

    Public Property AdjustmentDate() As DateTime
        Get
            Return _AdjustmentDate
        End Get
        Set(ByVal value As DateTime)
            _AdjustmentDate = value
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

    Dim _IsAdjusted As Boolean

    Public Property IsAdjusted() As Boolean
        Get
            Return _IsAdjusted
        End Get
        Set(ByVal value As Boolean)
            _IsAdjusted = value
        End Set
    End Property

#Region " Insert Multiple Warehouse Items "

    Public Function fnInsertMultipleWareHItems(ByVal WarehouseItems As clsWarehouseItem) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertMultipleWareHItems", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@InvoiceID", WarehouseItems.InvoiceID)
            cmd.Parameters.AddWithValue("@WarehouseItemList", WarehouseItems.WarehouseItemList)
            cmd.Parameters.AddWithValue("@EntryBy", WarehouseItems.EntryBy)

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

#Region " Get Warehouse Item Balance "

    Public Function fnGetWarehouseItemBalance(ByVal WarehouseID As String) As DataSet

        Dim sp As String = "spGetWarehouseItemBalance"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@WarehouseID", WarehouseID)
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

#Region " Get Warehouse Item Balance By Item "

    Public Function fnGetWarehouseItemBalByItem(ByVal WarehouseID As String, ByVal ItemID As String) As Integer

        Dim sp As String = "spGetWarehouseItemBalByItem"
        Dim dr As SqlDataReader
        Dim Balance As Integer = 0
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@WarehouseID", WarehouseID)
                cmd.Parameters.AddWithValue("@ItemID", ItemID)
                dr = cmd.ExecuteReader()
                While dr.Read()
                    Balance = dr.Item("Balance")
                End While
                con.Close()
                Return Balance
            End Using
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Ware To Ware Balance Transfer List "

    Public Function fnWareToWareBalTransferList(ByVal WTWBalTrans As clsWareToWareBalTransfer) As Integer

        Dim sp As String = "spWareToWareBalTransferList"
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@WareToWareBalTransList", WTWBalTrans.WareToWareBalTransList)
                cmd.Parameters.AddWithValue("@EntryBy", WTWBalTrans.EntryBy)
                cmd.ExecuteNonQuery()
                con.Close()
                Return 1
            End Using
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

#Region " Warehouse Item Balance By Item "

    Public Function fnWarehouseItemBalanceByItem(ByVal ItemID As String) As DataSet

        Dim sp As String = "spWarehouseItemBalanceByItem"
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

#Region " Get Item Balance By Item "

    Public Function fnGetItemBalanceByItem(ByVal ItemID As String) As Integer

        Dim sp As String = "spGetItemBalanceByItem"
        Dim dr As SqlDataReader
        Dim Balance As Integer = 0
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@ItemID", ItemID)
                dr = cmd.ExecuteReader()
                While dr.Read()
                    Balance = dr.Item("Balance")
                End While
                con.Close()
                Return Balance
            End Using
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return 0
        End Try
    End Function

#End Region

End Class
