Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsWarehouse

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _WarehouseID, _WarehouseName, _WarehouseCode, _BranchID, _Location, _Details, _EntryBy As String

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

    Public Property WarehouseCode() As String
        Get
            Return _WarehouseCode
        End Get
        Set(ByVal value As String)
            _WarehouseCode = value
        End Set
    End Property

    Public Property BranchID() As String
        Get
            Return _BranchID
        End Get
        Set(ByVal value As String)
            _BranchID = value
        End Set
    End Property

    Public Property Location() As String
        Get
            Return _Location
        End Get
        Set(ByVal value As String)
            _Location = value
        End Set
    End Property

    Public Property Details() As String
        Get
            Return _Details
        End Get
        Set(ByVal value As String)
            _Details = value
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

#Region " Insert Warehouse "

    Public Function fnInsertWarehouse(ByVal Warehouse As clsWarehouse) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertWarehouse", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@WarehouseName", Warehouse.WarehouseName)
            cmd.Parameters.AddWithValue("@WarehouseCode", Warehouse.WarehouseCode)
            cmd.Parameters.AddWithValue("@BranchID", Warehouse.BranchID)
            cmd.Parameters.AddWithValue("@Location", Warehouse.Location)
            cmd.Parameters.AddWithValue("@Details", Warehouse.Details)
            cmd.Parameters.AddWithValue("@IsActive", Warehouse.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Warehouse.EntryBy)

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

#Region " Update Warehouse "

    Public Function fnUpdateWarehouse(ByVal Warehouse As clsWarehouse) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateWarehouse", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@WarehouseID", Warehouse.WarehouseID)
            cmd.Parameters.AddWithValue("@WarehouseName", Warehouse.WarehouseName)
            cmd.Parameters.AddWithValue("@WarehouseCode", Warehouse.WarehouseCode)
            cmd.Parameters.AddWithValue("@BranchID", Warehouse.BranchID)
            cmd.Parameters.AddWithValue("@Location", Warehouse.Location)
            cmd.Parameters.AddWithValue("@Details", Warehouse.Details)
            cmd.Parameters.AddWithValue("@IsActive", Warehouse.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Warehouse.EntryBy)

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

#Region " Get Warehouse List "

    Public Function fnGetWarehouseList() As DataSet

        Dim sp As String = "spGetWarehouseList"
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

#Region " Get Details Warehouse List "

    Public Function fnGetDetailsWarehouseList() As DataSet

        Dim sp As String = "spGetDetailsWarehouseList"
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
