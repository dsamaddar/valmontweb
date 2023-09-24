Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsBuyer

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _BuyerID, _BuyerName, _Country, _BuyerAddress, _ContactPerson, _ContactNo, _EmailAddress, _Fax, _MerchandizerID, _EntryBy As String

    Public Property BuyerID() As String
        Get
            Return _BuyerID
        End Get
        Set(ByVal value As String)
            _BuyerID = value
        End Set
    End Property

    Public Property BuyerName() As String
        Get
            Return _BuyerName
        End Get
        Set(ByVal value As String)
            _BuyerName = value
        End Set
    End Property

    Public Property Country() As String
        Get
            Return _Country
        End Get
        Set(ByVal value As String)
            _Country = value
        End Set
    End Property

    Public Property BuyerAddress() As String
        Get
            Return _BuyerAddress
        End Get
        Set(ByVal value As String)
            _BuyerAddress = value
        End Set
    End Property

    Public Property ContactPerson() As String
        Get
            Return _ContactPerson
        End Get
        Set(ByVal value As String)
            _ContactPerson = value
        End Set
    End Property

    Public Property ContactNo() As String
        Get
            Return _ContactNo
        End Get
        Set(ByVal value As String)
            _ContactNo = value
        End Set
    End Property

    Public Property EmailAddress() As String
        Get
            Return _EmailAddress
        End Get
        Set(ByVal value As String)
            _EmailAddress = value
        End Set
    End Property

    Public Property Fax() As String
        Get
            Return _Fax
        End Get
        Set(ByVal value As String)
            _Fax = value
        End Set
    End Property

    Public Property MerchandizerID() As String
        Get
            Return _MerchandizerID
        End Get
        Set(ByVal value As String)
            _MerchandizerID = value
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

#Region " Insert Buyer "

    Public Function fnInsertBuyer(ByVal Buyer As clsBuyer) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertBuyer", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerName", Buyer.BuyerName)
            cmd.Parameters.AddWithValue("@Country", Buyer.Country)
            cmd.Parameters.AddWithValue("@BuyerAddress", Buyer.BuyerAddress)
            cmd.Parameters.AddWithValue("@ContactPerson", Buyer.ContactPerson)
            cmd.Parameters.AddWithValue("@ContactNo", Buyer.ContactNo)
            cmd.Parameters.AddWithValue("@EmailAddress", Buyer.EmailAddress)
            cmd.Parameters.AddWithValue("@Fax", Buyer.Fax)
            cmd.Parameters.AddWithValue("@MerchandizerID", Buyer.MerchandizerID)
            cmd.Parameters.AddWithValue("@EntryBy", Buyer.EntryBy)
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


#Region " Update Buyer "

    Public Function fnUpdateBuyer(ByVal Buyer As clsBuyer) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateBuyer", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", Buyer.BuyerID)
            cmd.Parameters.AddWithValue("@BuyerName", Buyer.BuyerName)
            cmd.Parameters.AddWithValue("@Country", Buyer.Country)
            cmd.Parameters.AddWithValue("@BuyerAddress", Buyer.BuyerAddress)
            cmd.Parameters.AddWithValue("@ContactPerson", Buyer.ContactPerson)
            cmd.Parameters.AddWithValue("@ContactNo", Buyer.ContactNo)
            cmd.Parameters.AddWithValue("@EmailAddress", Buyer.EmailAddress)
            cmd.Parameters.AddWithValue("@Fax", Buyer.Fax)
            cmd.Parameters.AddWithValue("@MerchandizerID", Buyer.MerchandizerID)
            cmd.Parameters.AddWithValue("@EntryBy", Buyer.EntryBy)
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

#Region " Get Buyer Info "

    Public Function fnGetBuyerInfo() As DataSet
        Return fnCallDropDownLoader("spGetBuyerInfo")
    End Function

#End Region

End Class
