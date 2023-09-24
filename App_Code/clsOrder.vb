Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsOrder

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _OrderID, _OrderNumber, _BuyerID, _StyleID, _OrderDetails, _EntryBy As String

    Public Property OrderID() As String
        Get
            Return _OrderID
        End Get
        Set(ByVal value As String)
            _OrderID = value
        End Set
    End Property

    Public Property OrderNumber() As String
        Get
            Return _OrderNumber
        End Get
        Set(ByVal value As String)
            _OrderNumber = value
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

    Public Property StyleID() As String
        Get
            Return _StyleID
        End Get
        Set(ByVal value As String)
            _StyleID = value
        End Set
    End Property

    Public Property OrderDetails() As String
        Get
            Return _OrderDetails
        End Get
        Set(ByVal value As String)
            _OrderDetails = value
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

    Dim _OrderQuantity As Integer

    Public Property OrderQuantity() As Integer
        Get
            Return _OrderQuantity
        End Get
        Set(ByVal value As Integer)
            _OrderQuantity = value
        End Set
    End Property

    Dim _OrderDate, _DeliveryDate As Date

    Public Property OrderDate() As Date
        Get
            Return _OrderDate
        End Get
        Set(ByVal value As Date)
            _OrderDate = value
        End Set
    End Property

    Public Property DeliveryDate() As Date
        Get
            Return _DeliveryDate
        End Get
        Set(ByVal value As Date)
            _DeliveryDate = value
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


#Region " Insert Order "

    Public Function fnInsertOrder(ByVal Order As clsOrder) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertOrder", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", Order.BuyerID)
            cmd.Parameters.AddWithValue("@StyleID", Order.StyleID)
            cmd.Parameters.AddWithValue("@OrderNumber", Order.OrderNumber)
            cmd.Parameters.AddWithValue("@OrderQuantity", Order.OrderQuantity)
            cmd.Parameters.AddWithValue("@OrderDate", Order.OrderDate)
            cmd.Parameters.AddWithValue("@DeliveryDate", Order.DeliveryDate)
            cmd.Parameters.AddWithValue("@OrderDetails", Order.OrderDetails)
            cmd.Parameters.AddWithValue("@EntryBy", Order.EntryBy)
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

#Region " Update Order "

    Public Function fnUpdateOrder(ByVal Order As clsOrder) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateOrder", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@OrderID", Order.OrderID)
            cmd.Parameters.AddWithValue("@BuyerID", Order.BuyerID)
            cmd.Parameters.AddWithValue("@StyleID", Order.StyleID)
            cmd.Parameters.AddWithValue("@OrderNumber", Order.OrderNumber)
            cmd.Parameters.AddWithValue("@OrderQuantity", Order.OrderQuantity)
            cmd.Parameters.AddWithValue("@OrderDate", Order.OrderDate)
            cmd.Parameters.AddWithValue("@DeliveryDate", Order.DeliveryDate)
            cmd.Parameters.AddWithValue("@OrderDetails", Order.OrderDetails)
            cmd.Parameters.AddWithValue("@EntryBy", Order.EntryBy)
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

#Region " Get Order Info "

    Public Function fnGetOrderInfo() As DataSet
        Return fnCallDropDownLoader("spGetOrderInfo")
    End Function

    Public Function fnGetOrderInfo(ByVal BuyerID As String) As DataSet
        Return fnCallDropDownLoader("spGetOrderInfoByBuyerID", "BuyerID", BuyerID)
    End Function

#End Region

End Class
