Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient


Public Class clsMaterialDistribution

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _MaterialDistID, _DistNumber, _EmployeeID, _BuyerID, _OrderID, _StyleID, _SizeID, _ColorID, _ComponentID, _
    _IssueRemarks, _IssueBy, _ReceiveRemarks, _ReceiveBy As String

    Public Property MaterialDistID() As String
        Get
            Return _MaterialDistID
        End Get
        Set(ByVal value As String)
            _MaterialDistID = value
        End Set
    End Property

    Public Property DistNumber() As String
        Get
            Return _DistNumber
        End Get
        Set(ByVal value As String)
            _DistNumber = value
        End Set
    End Property

    Public Property EmployeeID() As String
        Get
            Return _EmployeeID
        End Get
        Set(ByVal value As String)
            _EmployeeID = value
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

    Public Property OrderID() As String
        Get
            Return _OrderID
        End Get
        Set(ByVal value As String)
            _OrderID = value
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

    Public Property SizeID() As String
        Get
            Return _SizeID
        End Get
        Set(ByVal value As String)
            _SizeID = value
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

    Public Property ComponentID() As String
        Get
            Return _ComponentID
        End Get
        Set(ByVal value As String)
            _ComponentID = value
        End Set
    End Property

    Public Property IssueRemarks() As String
        Get
            Return _IssueRemarks
        End Get
        Set(ByVal value As String)
            _IssueRemarks = value
        End Set
    End Property

    Public Property IssueBy() As String
        Get
            Return _IssueBy
        End Get
        Set(ByVal value As String)
            _IssueBy = value
        End Set
    End Property

    Public Property ReceiveRemarks() As String
        Get
            Return _ReceiveRemarks
        End Get
        Set(ByVal value As String)
            _ReceiveRemarks = value
        End Set
    End Property

    Public Property ReceiveBy() As String
        Get
            Return _ReceiveBy
        End Get
        Set(ByVal value As String)
            _ReceiveBy = value
        End Set
    End Property

    Dim _Rate, _IssueQuantity, _IssuePiece, _ReceiveQuantity As Double

    Public Property Rate() As Double
        Get
            Return _Rate
        End Get
        Set(ByVal value As Double)
            _Rate = value
        End Set
    End Property

    Public Property IssueQuantity() As Double
        Get
            Return _IssueQuantity
        End Get
        Set(ByVal value As Double)
            _IssueQuantity = value
        End Set
    End Property

    Public Property IssuePiece() As Double
        Get
            Return _IssuePiece
        End Get
        Set(ByVal value As Double)
            _IssuePiece = value
        End Set
    End Property

    Public Property ReceiveQuantity() As Double
        Get
            Return _ReceiveQuantity
        End Get
        Set(ByVal value As Double)
            _ReceiveQuantity = value
        End Set
    End Property

    Dim _IssueDate, _ReceiveDate, _EntryDate As DateTime

    Public Property IssueDate() As DateTime
        Get
            Return _IssueDate
        End Get
        Set(ByVal value As DateTime)
            _IssueDate = value
        End Set
    End Property

    Public Property ReceiveDate() As DateTime
        Get
            Return _ReceiveDate
        End Get
        Set(ByVal value As DateTime)
            _ReceiveDate = value
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

#Region " Issue Material "

    Public Function fnIssueMaterial(ByVal MaterialDist As clsMaterialDistribution) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spIssueMaterial", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", MaterialDist.EmployeeID)
            cmd.Parameters.AddWithValue("@BuyerID", MaterialDist.BuyerID)
            cmd.Parameters.AddWithValue("@OrderID", MaterialDist.OrderID)
            cmd.Parameters.AddWithValue("@StyleID", MaterialDist.StyleID)
            cmd.Parameters.AddWithValue("@SizeID", MaterialDist.SizeID)
            cmd.Parameters.AddWithValue("@ColorID", MaterialDist.ColorID)
            cmd.Parameters.AddWithValue("@ComponentID", MaterialDist.ComponentID)
            cmd.Parameters.AddWithValue("@Rate", MaterialDist.Rate)
            cmd.Parameters.AddWithValue("@IssueQuantity", MaterialDist.IssueQuantity)
            cmd.Parameters.AddWithValue("@IssuePiece", MaterialDist.IssuePiece)
            cmd.Parameters.AddWithValue("@IssueDate", MaterialDist.IssueDate)
            cmd.Parameters.AddWithValue("@IssueRemarks", MaterialDist.IssueRemarks)
            cmd.Parameters.AddWithValue("@IssueBy", MaterialDist.IssueBy)
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

#Region " Receive Material "

    Public Function fnReceiveMaterial(ByVal MaterialDist As clsMaterialDistribution) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spReceiveMaterial", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@MaterialDistID", MaterialDist.MaterialDistID)
            cmd.Parameters.AddWithValue("@ReceiveQuantity", MaterialDist.ReceiveQuantity)
            cmd.Parameters.AddWithValue("@ReceiveDate", MaterialDist.ReceiveDate)
            cmd.Parameters.AddWithValue("@ReceiveRemarks", MaterialDist.ReceiveRemarks)
            cmd.Parameters.AddWithValue("@ReceiveBy", MaterialDist.ReceiveBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Received Successfully."
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

#Region " Get Rate "

    Public Function fnGetRate(ByVal MatDist As clsMaterialDistribution) As clsMaterialDistribution
        Try
            Dim sp As String = "spGetRate"
            Dim ds As New DataSet

            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@BuyerID", MatDist.BuyerID)
            cmd.Parameters.AddWithValue("@OrderID", MatDist.OrderID)
            cmd.Parameters.AddWithValue("@StyleID", MatDist.StyleID)
            cmd.Parameters.AddWithValue("@SizeID", MatDist.SizeID)
            cmd.Parameters.AddWithValue("@ColorID", MatDist.ColorID)
            cmd.Parameters.AddWithValue("@ComponentID", MatDist.ComponentID)
            con.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()
            While dr.Read()
                MatDist.Rate = dr.Item("Rate")
            End While
            con.Close()
            Return MatDist
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

#End Region

#Region " Get Material Dist List "

    Public Function fnGetMaterialDistList() As DataSet
        Return fnCallDropDownLoader("spGetMaterialDistList")
    End Function

#End Region

#Region " Get Material Dist List Pending "

    Public Function fnGetMaterialDistListPending() As DataSet
        Return fnCallDropDownLoader("spGetMaterialDistListPending")
    End Function

#End Region



End Class
