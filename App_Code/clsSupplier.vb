Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsSupplier

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _SupplierID, _SupplierName, _Address, _ContactPerson, _ContactNumber, _AboutSupplier, _Company_Phone_Mobile, _Fax, _Email, _EntryBy As String

    Public Property SupplierID() As String
        Get
            Return _SupplierID
        End Get
        Set(ByVal value As String)
            _SupplierID = value
        End Set
    End Property

    Public Property SupplierName() As String
        Get
            Return _SupplierName
        End Get
        Set(ByVal value As String)
            _SupplierName = value
        End Set
    End Property

    Public Property Address() As String
        Get
            Return _Address
        End Get
        Set(ByVal value As String)
            _Address = value
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

    Public Property ContactNumber() As String
        Get
            Return _ContactNumber
        End Get
        Set(ByVal value As String)
            _ContactNumber = value
        End Set
    End Property

    Public Property AboutSupplier() As String
        Get
            Return _AboutSupplier
        End Get
        Set(ByVal value As String)
            _AboutSupplier = value
        End Set
    End Property

    Public Property Company_Phone_Mobile() As String
        Get
            Return _Company_Phone_Mobile
        End Get
        Set(ByVal value As String)
            _Company_Phone_Mobile = value
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

    Public Property Email() As String
        Get
            Return _Email
        End Get
        Set(ByVal value As String)
            _Email = value
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

    Dim _IsBlackListed As Boolean

    Public Property IsBlackListed() As Boolean
        Get
            Return _IsBlackListed
        End Get
        Set(ByVal value As Boolean)
            _IsBlackListed = value
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
#Region " Insert Supplier "

    Public Function fnInsertSupplier(ByVal Supplier As clsSupplier) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertSupplier", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SupplierName", Supplier.SupplierName)
            cmd.Parameters.AddWithValue("@Address", Supplier.Address)
            cmd.Parameters.AddWithValue("@ContactPerson", Supplier.ContactPerson)
            cmd.Parameters.AddWithValue("@ContactNumber", Supplier.ContactNumber)
            cmd.Parameters.AddWithValue("@AboutSupplier", Supplier.AboutSupplier)
            cmd.Parameters.AddWithValue("@Company_Phone_Mobile", Supplier.Company_Phone_Mobile)
            cmd.Parameters.AddWithValue("@Fax", Supplier.Fax)
            cmd.Parameters.AddWithValue("@Email", Supplier.Email)
            cmd.Parameters.AddWithValue("@IsBlackListed", Supplier.IsBlackListed)
            cmd.Parameters.AddWithValue("@EntryBy", Supplier.EntryBy)
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

#Region " Update Supplier "

    Public Function fnUpdateSupplier(ByVal Supplier As clsSupplier) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateSupplier", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SupplierID", Supplier.SupplierID)
            cmd.Parameters.AddWithValue("@SupplierName", Supplier.SupplierName)
            cmd.Parameters.AddWithValue("@Address", Supplier.Address)
            cmd.Parameters.AddWithValue("@ContactPerson", Supplier.ContactPerson)
            cmd.Parameters.AddWithValue("@ContactNumber", Supplier.ContactNumber)
            cmd.Parameters.AddWithValue("@AboutSupplier", Supplier.AboutSupplier)
            cmd.Parameters.AddWithValue("@Company_Phone_Mobile", Supplier.Company_Phone_Mobile)
            cmd.Parameters.AddWithValue("@Fax", Supplier.Fax)
            cmd.Parameters.AddWithValue("@Email", Supplier.Email)
            cmd.Parameters.AddWithValue("@IsBlackListed", Supplier.IsBlackListed)
            cmd.Parameters.AddWithValue("@EntryBy", Supplier.EntryBy)
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

#Region " Get Supplier Details "

    Public Function fnGetSupplierDetails() As DataSet

        Dim sp As String = "spGetSupplierDetails"
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

#Region " Get Supplier "

    Public Function fnGetSupplier() As DataSet

        Dim sp As String = "spGetSupplier"
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
