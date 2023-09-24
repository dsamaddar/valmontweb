Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsItem

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _BuyerID, _StyleID, _ColorID, _ParentItemID, _ItemID, _ItemName, _ItemCode, _UnitTypeID, _EntryBy As String

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

    Public Property ColorID() As String
        Get
            Return _ColorID
        End Get
        Set(ByVal value As String)
            _ColorID = value
        End Set
    End Property

    Public Property ParentItemID() As String
        Get
            Return _ParentItemID
        End Get
        Set(ByVal value As String)
            _ParentItemID = value
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

    Public Property ItemCode() As String
        Get
            Return _ItemCode
        End Get
        Set(ByVal value As String)
            _ItemCode = value
        End Set
    End Property

    Public Property UnitTypeID() As String
        Get
            Return _UnitTypeID
        End Get
        Set(ByVal value As String)
            _UnitTypeID = value
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

    Dim _LowBalanceReport, _MaxAllowableRequisition As Integer

    Public Property LowBalanceReport() As Integer
        Get
            Return _LowBalanceReport
        End Get
        Set(ByVal value As Integer)
            _LowBalanceReport = value
        End Set
    End Property

    Public Property MaxAllowableRequisition() As Integer
        Get
            Return _MaxAllowableRequisition
        End Get
        Set(ByVal value As Integer)
            _MaxAllowableRequisition = value
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

#Region " Insert Inventory Items "

    Public Function fnInsertInventoryItems(ByVal Items As clsItem) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertInventoryItems", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", Items.BuyerID)
            cmd.Parameters.AddWithValue("@StyleID", Items.StyleID)
            cmd.Parameters.AddWithValue("@ColorID", Items.ColorID)
            cmd.Parameters.AddWithValue("@ParentItemID", Items.ParentItemID)
            cmd.Parameters.AddWithValue("@ItemName", Items.ItemName)
            cmd.Parameters.AddWithValue("@ItemCode", Items.ItemCode)
            cmd.Parameters.AddWithValue("@UnitTypeID", Items.UnitTypeID)
            cmd.Parameters.AddWithValue("@LowBalanceReport", Items.LowBalanceReport)
            cmd.Parameters.AddWithValue("@MaxAllowableRequisition", Items.MaxAllowableRequisition)
            cmd.Parameters.AddWithValue("@IsActive", Items.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Items.EntryBy)
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

#Region " Update Inventory Items "

    Public Function fnUpdateInventoryItems(ByVal Items As clsItem) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateInventoryItems", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ItemID", Items.ItemID)
            cmd.Parameters.AddWithValue("@BuyerID", Items.BuyerID)
            cmd.Parameters.AddWithValue("@StyleID", Items.StyleID)
            cmd.Parameters.AddWithValue("@ColorID", Items.ColorID)
            cmd.Parameters.AddWithValue("@ParentItemID", Items.ParentItemID)
            cmd.Parameters.AddWithValue("@ItemName", Items.ItemName)
            cmd.Parameters.AddWithValue("@ItemCode", Items.ItemCode)
            cmd.Parameters.AddWithValue("@UnitTypeID", Items.UnitTypeID)
            cmd.Parameters.AddWithValue("@LowBalanceReport", Items.LowBalanceReport)
            cmd.Parameters.AddWithValue("@MaxAllowableRequisition", Items.MaxAllowableRequisition)
            cmd.Parameters.AddWithValue("@IsActive", Items.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Items.EntryBy)
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

#Region " Get Item List "

    Public Function fnGetItemList() As DataSet

        Dim sp As String = "spGetItemList"
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

#Region " Get Requisition Remmaining Item List "

    Public Function fnGetReqRemItemList() As DataSet

        Dim sp As String = "spGetReqRemItemList"
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

#Region " Get Item List Details "

    Public Function fnGetItemListDetails() As DataSet

        Dim sp As String = "spGetItemListDetails"
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

#Region " Get Low Balance Item List "

    Public Function fnGetLowBalanceItemList() As DataSet

        Dim sp As String = "spGetLowBalanceItemList"
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

#Region " Generate Item Name "

    Public Function fnGenerateItemName(ByVal Item As clsItem) As String
        Try
            Dim ItemName As String = ""
            Dim dr As SqlDataReader
            Dim cmd As SqlCommand = New SqlCommand("spGenerateItemName", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@BuyerID", Item.BuyerID)
            cmd.Parameters.AddWithValue("@StyleID", Item.StyleID)
            cmd.Parameters.AddWithValue("@ColorID", Item.ColorID)
            cmd.Parameters.AddWithValue("@ParentItemID", Item.ParentItemID)
            dr = cmd.ExecuteReader()
            While dr.Read()
                ItemName = dr.Item("ItemName")
            End While
            con.Close()

            Return ItemName
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return ""
        End Try
    End Function

#End Region

End Class
