Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsSalarySetup

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _SalarySetupID, _CompSalarySetupID, _EmployeeID, _BankAccountNo, _EntryBy As String

    Dim _BasicSalary, _HouseRent, _MedicalAllowance, _GrossSalary, _FridayAllowance_per, _FridayAllowance_fixed, _Conveyance, _FoodAllowance As Double

    Dim _PaymentMethod As Char

    Public Property PaymentMethod() As Char
        Get
            Return _PaymentMethod
        End Get
        Set(ByVal value As Char)
            _PaymentMethod = value
        End Set
    End Property

    Dim _EntryDate As DateTime

    Public Property SalarySetupID() As String
        Get
            Return _SalarySetupID
        End Get
        Set(ByVal value As String)
            _SalarySetupID = value
        End Set
    End Property

    Public Property CompSalarySetupID() As String
        Get
            Return _CompSalarySetupID
        End Get
        Set(ByVal value As String)
            _CompSalarySetupID = value
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

    Public Property BankAccountNo() As String
        Get
            Return _BankAccountNo
        End Get
        Set(ByVal value As String)
            _BankAccountNo = value
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

    Public Property BasicSalary() As Double
        Get
            Return _BasicSalary
        End Get
        Set(ByVal value As Double)
            _BasicSalary = value
        End Set
    End Property

    Public Property HouseRent() As Double
        Get
            Return _HouseRent
        End Get
        Set(ByVal value As Double)
            _HouseRent = value
        End Set
    End Property

    Public Property MedicalAllowance() As Double
        Get
            Return _MedicalAllowance
        End Get
        Set(ByVal value As Double)
            _MedicalAllowance = value
        End Set
    End Property

    Public Property GrossSalary() As Double
        Get
            Return _GrossSalary
        End Get
        Set(ByVal value As Double)
            _GrossSalary = value
        End Set
    End Property

    Public Property FridayAllowance_per() As Double
        Get
            Return _FridayAllowance_per
        End Get
        Set(ByVal value As Double)
            _FridayAllowance_per = value
        End Set
    End Property

    Public Property FridayAllowance_fixed() As Double
        Get
            Return _FridayAllowance_fixed
        End Get
        Set(ByVal value As Double)
            _FridayAllowance_fixed = value
        End Set
    End Property

    Public Property Conveyance() As Double
        Get
            Return _Conveyance
        End Get
        Set(ByVal value As Double)
            _Conveyance = value
        End Set
    End Property

    Public Property FoodAllowance() As Double
        Get
            Return _FoodAllowance
        End Get
        Set(ByVal value As Double)
            _FoodAllowance = value
        End Set
    End Property

#Region " Insert Salary Setup "

    Public Function fnInsertSalarySetup(ByVal salary_setup As clsSalarySetup) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertSalarySetup", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", salary_setup.EmployeeID)
            cmd.Parameters.AddWithValue("@BasicSalary", salary_setup.BasicSalary)
            cmd.Parameters.AddWithValue("@HouseRent", salary_setup.HouseRent)
            cmd.Parameters.AddWithValue("@MedicalAllowance", salary_setup.MedicalAllowance)
            cmd.Parameters.AddWithValue("@GrossSalary", salary_setup.GrossSalary)
            cmd.Parameters.AddWithValue("@FridayAllowance_per", salary_setup.FridayAllowance_per)
            cmd.Parameters.AddWithValue("@FridayAllowance_fixed", salary_setup.FridayAllowance_fixed)
            cmd.Parameters.AddWithValue("@Conveyance", salary_setup.Conveyance)
            cmd.Parameters.AddWithValue("@FoodAllowance", salary_setup.FoodAllowance)
            cmd.Parameters.AddWithValue("@PaymentMethod", salary_setup.PaymentMethod)
            cmd.Parameters.AddWithValue("@BankAccountNo", salary_setup.BankAccountNo)
            cmd.Parameters.AddWithValue("@EntryBy", salary_setup.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Saved."
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

#Region " Insert Salary Setup Compliance "

    Public Function fnInsertSalarySetupComp(ByVal salary_setup As clsSalarySetup) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertSalarySetupComp", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", salary_setup.EmployeeID)
            cmd.Parameters.AddWithValue("@BasicSalary", salary_setup.BasicSalary)
            cmd.Parameters.AddWithValue("@HouseRent", salary_setup.HouseRent)
            cmd.Parameters.AddWithValue("@MedicalAllowance", salary_setup.MedicalAllowance)
            cmd.Parameters.AddWithValue("@GrossSalary", salary_setup.GrossSalary)
            cmd.Parameters.AddWithValue("@FridayAllowance_per", salary_setup.FridayAllowance_per)
            cmd.Parameters.AddWithValue("@FridayAllowance_fixed", salary_setup.FridayAllowance_fixed)
            cmd.Parameters.AddWithValue("@Conveyance", salary_setup.Conveyance)
            cmd.Parameters.AddWithValue("@FoodAllowance", salary_setup.FoodAllowance)
            cmd.Parameters.AddWithValue("@EntryBy", salary_setup.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Saved."
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

#Region " Process Salary for All Employee "

    Public Function fnProcessSalaryAll(ByVal SalaryYear As Integer, ByVal SalaryMonth As Integer, ByVal StartDate As Date, ByVal EndDate As Date, ByVal ProcessedBy As String) As clsResult
        Dim result As New clsResult()
        Try

            Dim cmd As SqlCommand = New SqlCommand("spProcessSalaryAll", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandTimeout = 24000

            cmd.Parameters.AddWithValue("@SalaryYear", SalaryYear)
            cmd.Parameters.AddWithValue("@SalaryMonth", SalaryMonth)
            cmd.Parameters.AddWithValue("@StartDate", StartDate)
            cmd.Parameters.AddWithValue("@EndDate", EndDate)
            cmd.Parameters.AddWithValue("@ProcessedBy", ProcessedBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Processed."
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

#Region " Process Festival Bonus "

    Public Function fnProcessFestivalBonus(ByVal FestivalTypeID As Integer, ByVal FestivalYear As Integer, ByVal FestivalMonth As Integer, ByVal EffectiveDate As Date, ByVal ProcessedBy As String) As clsResult
        Dim result As New clsResult()
        Try

            Dim cmd As SqlCommand = New SqlCommand("spProcessFestivalBonus", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@FestivalTypeID", FestivalTypeID)
            cmd.Parameters.AddWithValue("@FestivalYear", FestivalYear)
            cmd.Parameters.AddWithValue("@FestivalMonth", FestivalMonth)
            cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate)
            cmd.Parameters.AddWithValue("@ProcessedBy", ProcessedBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Processed."
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

#Region " Process Festival Bonus "

    Public Function fnReverseSalary(ByVal EntryPoint As String) As clsResult
        Dim result As New clsResult()
        Try

            Dim cmd As SqlCommand = New SqlCommand("spReverseSalary", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EntryPoint", EntryPoint)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Successfully Processed."
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

#Region " Get Salary Setup "

    Public Function fnGetSalarySetup(ByVal EmployeeID As String) As clsSalarySetup
        Try
            Dim salary As New clsSalarySetup()
            Dim sp As String = "spGetSalarySetup"
            Dim ds As New DataSet
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID)
            con.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()
            While dr.Read()
                salary.BasicSalary = dr.Item("BasicSalary")
                salary.HouseRent = dr.Item("HouseRent")
                salary.MedicalAllowance = dr.Item("MedicalAllowance")
                salary.GrossSalary = dr.Item("GrossSalary")
                salary.FridayAllowance_per = dr.Item("FridayAllowance_per")
                salary.FridayAllowance_fixed = dr.Item("FridayAllowance_fixed")
                salary.Conveyance = dr.Item("Conveyance")
                salary.FoodAllowance = dr.Item("FoodAllowance")
                salary.PaymentMethod = dr.Item("PaymentMethod")
                salary.BankAccountNo = dr.Item("BankAccountNo")
            End While
            con.Close()
            Return salary
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return Nothing
        End Try
    End Function

#End Region

#Region " Get Entry Points"

    Public Function fnGetEntryPoints(ByVal SalaryYear As Integer, ByVal SalaryMonth As Integer) As DataSet
        Dim sp As String = "spGetEntryPoints"
        Dim ds As New DataSet
        Dim da As New SqlDataAdapter
        Try
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SalaryYear", SalaryYear)
            cmd.Parameters.AddWithValue("@SalaryMonth", SalaryMonth)
            con.Open()
            da.SelectCommand = cmd
            da.Fill(ds)
            con.Close()
            Return ds
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return Nothing
        End Try

    End Function

#End Region

#Region " Get Salary Setup Comp"

    Public Function fnGetSalarySetupComp(ByVal EmployeeID As String) As clsSalarySetup
        Dim salary As New clsSalarySetup()
        Dim sp As String = "spGetSalarySetupComp"
        Dim ds As New DataSet
        Try
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID)
            con.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()
            While dr.Read()
                salary.BasicSalary = dr.Item("BasicSalary")
                salary.HouseRent = dr.Item("HouseRent")
                salary.MedicalAllowance = dr.Item("MedicalAllowance")
                salary.GrossSalary = dr.Item("GrossSalary")
                salary.FridayAllowance_per = dr.Item("FridayAllowance_per")
                salary.FridayAllowance_fixed = dr.Item("FridayAllowance_fixed")
                salary.Conveyance = dr.Item("Conveyance")
                salary.FoodAllowance = dr.Item("FoodAllowance")
            End While
            con.Close()
            Return salary
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            Return Nothing
        End Try

    End Function

#End Region

End Class
