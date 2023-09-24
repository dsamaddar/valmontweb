Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsProductionUnit

    Dim ValmontConn As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString

    Dim _ProductionUnitID, _ProductionUnit, _StyleID, _ProcessID, _SizeID, _EntryBy As String

    Public Property ProductionUnitID() As String
        Get
            Return _ProductionUnitID
        End Get
        Set(ByVal value As String)
            _ProductionUnitID = value
        End Set
    End Property

    Public Property ProductionUnit() As String
        Get
            Return _ProductionUnit
        End Get
        Set(ByVal value As String)
            _ProductionUnit = value
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

    Public Property ProcessID() As String
        Get
            Return _ProcessID
        End Get
        Set(ByVal value As String)
            _ProcessID = value
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

    Public Property EntryBy() As String
        Get
            Return _EntryBy
        End Get
        Set(ByVal value As String)
            _EntryBy = value
        End Set
    End Property

    Dim _RegularRate, _OvertimeRate As Double

    Public Property RegularRate() As Double
        Get
            Return _RegularRate
        End Get
        Set(ByVal value As Double)
            _RegularRate = value
        End Set
    End Property

    Public Property OvertimeRate() As Double
        Get
            Return _OvertimeRate
        End Get
        Set(ByVal value As Double)
            _OvertimeRate = value
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


#Region " Insert Production Unit "

    Public Function fnInsertProductionUnit(ByVal ProdUnit As clsProductionUnit) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spInsertProductionUnit"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ProductionUnit", ProdUnit.ProductionUnit)
            cmd.Parameters.AddWithValue("@StyleID", ProdUnit.StyleID)
            cmd.Parameters.AddWithValue("@ProcessID", ProdUnit.ProcessID)
            cmd.Parameters.AddWithValue("@SizeID", ProdUnit.SizeID)
            cmd.Parameters.AddWithValue("@RegularRate", ProdUnit.RegularRate)
            cmd.Parameters.AddWithValue("@OvertimeRate", ProdUnit.OvertimeRate)
            cmd.Parameters.AddWithValue("@IsActive", ProdUnit.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", ProdUnit.EntryBy)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "New Production Unit Inserted."
            con.Close()
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = ex.Message.ToCharArray()
            Return result
        End Try
    End Function

#End Region

#Region " Update Production Unit "

    Public Function fnUpdateProductionUnit(ByVal ProdUnit As clsProductionUnit) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spUpdateProductionUnit"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ProductionUnitID", ProdUnit.ProductionUnitID)
            cmd.Parameters.AddWithValue("@ProductionUnit", ProdUnit.ProductionUnit)
            cmd.Parameters.AddWithValue("@StyleID", ProdUnit.StyleID)
            cmd.Parameters.AddWithValue("@ProcessID", ProdUnit.ProcessID)
            cmd.Parameters.AddWithValue("@SizeID", ProdUnit.SizeID)
            cmd.Parameters.AddWithValue("@RegularRate", ProdUnit.RegularRate)
            cmd.Parameters.AddWithValue("@OvertimeRate", ProdUnit.OvertimeRate)
            cmd.Parameters.AddWithValue("@IsActive", ProdUnit.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", ProdUnit.EntryBy)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "Production Unit Updated."
            con.Close()
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = ex.Message.ToCharArray()
            Return result
        End Try
    End Function

#End Region


#Region " Get Production Unit Details "

    Public Function fnGetProductionUnitDetails() As DataSet
        Return fnCallDropDownLoader("spGetProductionUnitDetails")
    End Function

#End Region



End Class
