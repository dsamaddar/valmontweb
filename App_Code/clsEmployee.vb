Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsEmployee

    Dim ValmontConn As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString

    Dim _EmployeeID, _EmployeeName, _EmployeeNameBangla, _EmpCode, _FathersName, _MothersName, _PresentAddress, _PermanentAddress, _MobileNo, _AlternateMobileNo, _MachineNo, _EmpPhoto, _EmpSignature, _
    _BlockID, _SectionID, _Section, _DesignationID, _Designation, _EmpStatus, _EntryBy, _NameorID, _NationalID, _UserID, _UserPassword, _NewPassword, _UserType, _BloodGroup, _RFIDCode, _
    _AccessModule, _PermittedMenu, _CardNo, _CardNoBangla, _JoiningDateBangla As String

    Public Property EmployeeID() As String
        Get
            Return _EmployeeID
        End Get
        Set(ByVal value As String)
            _EmployeeID = value
        End Set
    End Property

    Public Property EmployeeName() As String
        Get
            Return _EmployeeName
        End Get
        Set(ByVal value As String)
            _EmployeeName = value
        End Set
    End Property

    Public Property EmployeeNameBangla() As String
        Get
            Return _EmployeeNameBangla
        End Get
        Set(ByVal value As String)
            _EmployeeNameBangla = value
        End Set
    End Property

    Public Property EmpCode() As String
        Get
            Return _EmpCode
        End Get
        Set(ByVal value As String)
            _EmpCode = value
        End Set
    End Property

    Public Property FathersName() As String
        Get
            Return _FathersName
        End Get
        Set(ByVal value As String)
            _FathersName = value
        End Set
    End Property

    Public Property MothersName() As String
        Get
            Return _MothersName
        End Get
        Set(ByVal value As String)
            _MothersName = value
        End Set
    End Property

    Public Property PresentAddress() As String
        Get
            Return _PresentAddress
        End Get
        Set(ByVal value As String)
            _PresentAddress = value
        End Set
    End Property

    Public Property PermanentAddress() As String
        Get
            Return _PermanentAddress
        End Get
        Set(ByVal value As String)
            _PermanentAddress = value
        End Set
    End Property

    Public Property MobileNo() As String
        Get
            Return _MobileNo
        End Get
        Set(ByVal value As String)
            _MobileNo = value
        End Set
    End Property

    Public Property AlternateMobileNo() As String
        Get
            Return _AlternateMobileNo
        End Get
        Set(ByVal value As String)
            _AlternateMobileNo = value
        End Set
    End Property

    Public Property MachineNo() As String
        Get
            Return _MachineNo
        End Get
        Set(ByVal value As String)
            _MachineNo = value
        End Set
    End Property

    Public Property EmpPhoto() As String
        Get
            Return _EmpPhoto
        End Get
        Set(ByVal value As String)
            _EmpPhoto = value
        End Set
    End Property

    Public Property EmpSignature() As String
        Get
            Return _EmpSignature
        End Get
        Set(ByVal value As String)
            _EmpSignature = value
        End Set
    End Property

    Public Property BlockID() As String
        Get
            Return _BlockID
        End Get
        Set(ByVal value As String)
            _BlockID = value
        End Set
    End Property

    Public Property SectionID() As String
        Get
            Return _SectionID
        End Get
        Set(ByVal value As String)
            _SectionID = value
        End Set
    End Property

    Public Property Section() As String
        Get
            Return _Section
        End Get
        Set(ByVal value As String)
            _Section = value
        End Set
    End Property

    Public Property DesignationID() As String
        Get
            Return _DesignationID
        End Get
        Set(ByVal value As String)
            _DesignationID = value
        End Set
    End Property

    Public Property Designation() As String
        Get
            Return _Designation
        End Get
        Set(ByVal value As String)
            _Designation = value
        End Set
    End Property

    Public Property EmpStatus() As String
        Get
            Return _EmpStatus
        End Get
        Set(ByVal value As String)
            _EmpStatus = value
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

    Public Property NameorID() As String
        Get
            Return _NameorID
        End Get
        Set(ByVal value As String)
            _NameorID = value
        End Set
    End Property

    Public Property NationalID() As String
        Get
            Return _NationalID
        End Get
        Set(ByVal value As String)
            _NationalID = value
        End Set
    End Property

    Public Property UserID() As String
        Get
            Return _UserID
        End Get
        Set(ByVal value As String)
            _UserID = value
        End Set
    End Property

    Public Property UserPassword() As String
        Get
            Return _UserPassword
        End Get
        Set(ByVal value As String)
            _UserPassword = value
        End Set
    End Property

    Public Property NewPassword() As String
        Get
            Return _NewPassword
        End Get
        Set(ByVal value As String)
            _NewPassword = value
        End Set
    End Property

    Public Property UserType() As String
        Get
            Return _UserType
        End Get
        Set(ByVal value As String)
            _UserType = value
        End Set
    End Property

    Public Property BloodGroup() As String
        Get
            Return _BloodGroup
        End Get
        Set(ByVal value As String)
            _BloodGroup = value
        End Set
    End Property

    Public Property RFIDCode() As String
        Get
            Return _RFIDCode
        End Get
        Set(ByVal value As String)
            _RFIDCode = value
        End Set
    End Property

    Public Property AccessModule() As String
        Get
            Return _AccessModule
        End Get
        Set(ByVal value As String)
            _AccessModule = value
        End Set
    End Property

    Public Property PermittedMenu() As String
        Get
            Return _PermittedMenu
        End Get
        Set(ByVal value As String)
            _PermittedMenu = value
        End Set
    End Property

    Public Property JoiningDateBangla() As String
        Get
            Return _JoiningDateBangla
        End Get
        Set(ByVal value As String)
            _JoiningDateBangla = value
        End Set
    End Property

    Dim _PaymentMethod As Char

    Public Property PaymentMethod() As Char
        Get
            Return _PaymentMethod
        End Get
        Set(ByVal value As Char)
            _PaymentMethod = value
        End Set
    End Property

    Dim _IsActive, _InCludedInPayroll As Boolean

    Public Property IsActive() As Boolean
        Get
            Return _IsActive
        End Get
        Set(ByVal value As Boolean)
            _IsActive = value
        End Set
    End Property

    Public Property InCludedInPayroll() As Boolean
        Get
            Return _InCludedInPayroll
        End Get
        Set(ByVal value As Boolean)
            _InCludedInPayroll = value
        End Set
    End Property

    Dim _EntryDate, _JoiningDate, _ExitDate As DateTime

    Public Property EntryDate() As DateTime
        Get
            Return _EntryDate
        End Get
        Set(ByVal value As DateTime)
            _EntryDate = value
        End Set
    End Property

    Public Property JoiningDate() As DateTime
        Get
            Return _JoiningDate
        End Get
        Set(ByVal value As DateTime)
            _JoiningDate = value
        End Set
    End Property

    Public Property ExitDate() As DateTime
        Get
            Return _ExitDate
        End Get
        Set(ByVal value As DateTime)
            _ExitDate = value
        End Set
    End Property

    Dim _BasicSalary As Double

    Public Property BasicSalary() As Double
        Get
            Return _BasicSalary
        End Get
        Set(ByVal value As Double)
            _BasicSalary = value
        End Set
    End Property

    Dim _PresentDistrictID, _PresentUpazilaID, _PermanentDistrictID, _PermanentUpazilaID As Integer

    Public Property PresentDistrictID() As Integer
        Get
            Return _PresentDistrictID
        End Get
        Set(ByVal value As Integer)
            _PresentDistrictID = value
        End Set
    End Property

    Public Property PresentUpazilaID() As Integer
        Get
            Return _PresentUpazilaID
        End Get
        Set(ByVal value As Integer)
            _PresentUpazilaID = value
        End Set
    End Property

    Public Property PermanentDistrictID() As Integer
        Get
            Return _PermanentDistrictID
        End Get
        Set(ByVal value As Integer)
            _PermanentDistrictID = value
        End Set
    End Property

    Public Property PermanentUpazilaID() As Integer
        Get
            Return _PermanentUpazilaID
        End Get
        Set(ByVal value As Integer)
            _PermanentUpazilaID = value
        End Set
    End Property

    Public Property CardNo() As String
        Get
            Return _CardNo
        End Get
        Set(ByVal value As String)
            _CardNo = value
        End Set
    End Property

    Public Property CardNoBangla() As String
        Get
            Return _CardNoBangla
        End Get
        Set(ByVal value As String)
            _CardNoBangla = value
        End Set
    End Property

#Region " Employee Input "

    Public Function fnInsertEmployee(ByVal EmpInfo As clsEmployee) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spInsertEmployee"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("EmployeeName", EmpInfo.EmployeeName)
            cmd.Parameters.AddWithValue("EmpCode", EmpInfo.EmpCode)
            cmd.Parameters.AddWithValue("FathersName", EmpInfo.FathersName)
            cmd.Parameters.AddWithValue("MothersName", EmpInfo.MothersName)
            cmd.Parameters.AddWithValue("PresentDistrictID", EmpInfo.PresentDistrictID)
            cmd.Parameters.AddWithValue("PresentUpazilaID", EmpInfo.PresentUpazilaID)
            cmd.Parameters.AddWithValue("PresentAddress", EmpInfo.PresentAddress)
            cmd.Parameters.AddWithValue("PermanentDistrictID", EmpInfo.PermanentDistrictID)
            cmd.Parameters.AddWithValue("PermanentUpazilaID", EmpInfo.PermanentUpazilaID)
            cmd.Parameters.AddWithValue("PermanentAddress", EmpInfo.PermanentAddress)
            cmd.Parameters.AddWithValue("JoiningDate", EmpInfo.JoiningDate)
            cmd.Parameters.AddWithValue("MobileNo", EmpInfo.MobileNo)
            cmd.Parameters.AddWithValue("AlternateMobileNo", EmpInfo.AlternateMobileNo)
            cmd.Parameters.AddWithValue("MachineNo", EmpInfo.MachineNo)
            cmd.Parameters.AddWithValue("EmpPhoto", EmpInfo.EmpPhoto)
            cmd.Parameters.AddWithValue("EmpSignature", EmpInfo.EmpSignature)
            cmd.Parameters.AddWithValue("BasicSalary", EmpInfo.BasicSalary)
            cmd.Parameters.AddWithValue("PaymentMethod", EmpInfo.PaymentMethod)
            cmd.Parameters.AddWithValue("BlockID", EmpInfo.BlockID)
            cmd.Parameters.AddWithValue("SectionID", EmpInfo.SectionID)
            cmd.Parameters.AddWithValue("DesignationID", EmpInfo.DesignationID)
            cmd.Parameters.AddWithValue("EmpStatus", EmpInfo.EmpStatus)
            cmd.Parameters.AddWithValue("IsActive", EmpInfo.IsActive)
            cmd.Parameters.AddWithValue("InCludedInPayroll", EmpInfo.InCludedInPayroll)
            cmd.Parameters.AddWithValue("BloodGroup", EmpInfo.BloodGroup)
            cmd.Parameters.AddWithValue("NationalID", EmpInfo.NationalID)
            cmd.Parameters.AddWithValue("EntryBy", EmpInfo.EntryBy)
            cmd.Parameters.AddWithValue("CardNo", EmpInfo.CardNo)
            cmd.Parameters.AddWithValue("CardNoBangla", EmpInfo.CardNoBangla)
            cmd.Parameters.AddWithValue("EmployeeNameBangla", EmpInfo.EmployeeNameBangla)
            cmd.Parameters.AddWithValue("JoiningDateBangla", EmpInfo.JoiningDateBangla)
            cmd.Parameters.AddWithValue("ExitDate", EmpInfo.ExitDate)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "Employee Information Submitted."
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

#Region " Update Employee "

    Public Function fnUpdateEmployee(ByVal EmpInfo As clsEmployee) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spUpdateEmployee"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("EmployeeID", EmpInfo.EmployeeID)
            cmd.Parameters.AddWithValue("EmployeeName", EmpInfo.EmployeeName)
            cmd.Parameters.AddWithValue("EmpCode", EmpInfo.EmpCode)
            cmd.Parameters.AddWithValue("FathersName", EmpInfo.FathersName)
            cmd.Parameters.AddWithValue("MothersName", EmpInfo.MothersName)
            cmd.Parameters.AddWithValue("PresentDistrictID", EmpInfo.PresentDistrictID)
            cmd.Parameters.AddWithValue("PresentUpazilaID", EmpInfo.PresentUpazilaID)
            cmd.Parameters.AddWithValue("PresentAddress", EmpInfo.PresentAddress)
            cmd.Parameters.AddWithValue("PermanentDistrictID", EmpInfo.PermanentDistrictID)
            cmd.Parameters.AddWithValue("PermanentUpazilaID", EmpInfo.PermanentUpazilaID)
            cmd.Parameters.AddWithValue("PermanentAddress", EmpInfo.PermanentAddress)
            cmd.Parameters.AddWithValue("JoiningDate", EmpInfo.JoiningDate)
            cmd.Parameters.AddWithValue("MobileNo", EmpInfo.MobileNo)
            cmd.Parameters.AddWithValue("AlternateMobileNo", EmpInfo.AlternateMobileNo)
            cmd.Parameters.AddWithValue("MachineNo", EmpInfo.MachineNo)
            cmd.Parameters.AddWithValue("EmpPhoto", EmpInfo.EmpPhoto)
            cmd.Parameters.AddWithValue("EmpSignature", EmpInfo.EmpSignature)
            cmd.Parameters.AddWithValue("BasicSalary", EmpInfo.BasicSalary)
            cmd.Parameters.AddWithValue("PaymentMethod", EmpInfo.PaymentMethod)
            cmd.Parameters.AddWithValue("BlockID", EmpInfo.BlockID)
            cmd.Parameters.AddWithValue("SectionID", EmpInfo.SectionID)
            cmd.Parameters.AddWithValue("DesignationID", EmpInfo.DesignationID)
            cmd.Parameters.AddWithValue("EmpStatus", EmpInfo.EmpStatus)
            cmd.Parameters.AddWithValue("IsActive", EmpInfo.IsActive)
            cmd.Parameters.AddWithValue("InCludedInPayroll", EmpInfo.InCludedInPayroll)
            cmd.Parameters.AddWithValue("BloodGroup", EmpInfo.BloodGroup)
            cmd.Parameters.AddWithValue("NationalID", EmpInfo.NationalID)
            cmd.Parameters.AddWithValue("EntryBy", EmpInfo.EntryBy)
            cmd.Parameters.AddWithValue("CardNo", EmpInfo.CardNo)
            cmd.Parameters.AddWithValue("CardNoBangla", EmpInfo.CardNoBangla)
            cmd.Parameters.AddWithValue("EmployeeNameBangla", EmpInfo.EmployeeNameBangla)
            cmd.Parameters.AddWithValue("JoiningDateBangla", EmpInfo.JoiningDateBangla)
            cmd.Parameters.AddWithValue("ExitDate", EmpInfo.ExitDate)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "Employee Information Updated Successfully."
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

    Public Function fnActivateEmployee(ByVal EmployeeID As String) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spActivateEmployee"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("EmployeeID", EmployeeID)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "Employee Information Updated Successfully."
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

#Region " Print ID Card "

    Public Function fnPrintIDCard(ByVal StartingCardNo As String, ByVal EndingCardNo As String) As DataSet
        Dim sp As String = "spPrintIDCard"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@StartingCardNo", StartingCardNo)
            cmd.Parameters.AddWithValue("@EndingCardNo", EndingCardNo)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using
    End Function

#End Region

#Region " Print ID Card Bangla "

    Public Function fnPrintIDCardBangla(ByVal StartingCardNo As String, ByVal EndingCardNo As String) As DataSet
        Dim sp As String = "spPrintIDCardBangla"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@StartingCardNo", StartingCardNo)
            cmd.Parameters.AddWithValue("@EndingCardNo", EndingCardNo)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using
    End Function

#End Region

#Region " Get Districts "

    Public Function fnGetDistricts() As DataSet
        Return fnCallDropDownLoader("spGetDistricts")
    End Function

#End Region

#Region " Get Upazilla Name "

    Public Function fnGetUpazillaName(ByVal DistrictID As String) As DataSet
        Return fnCallDropDownLoader("spGetUpazillaName", "@DistrictID", DistrictID)
    End Function

#End Region

#Region " Get Employee Info"

    Public Function fnGetEmpListPayrollActive() As DataSet
        Dim sp As String = "spGetEmpListPayrollActive"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using
    End Function

    Public Function fnGetShiftingEmployee() As DataSet
        Dim sp As String = "spGetShiftingEmployee"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using
    End Function

    Public Function fnSearchEmployees(ByVal EmpInfo As clsEmployee) As DataSet

        Dim sp As String = "spSearchEmployee"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@NameorID", EmpInfo.NameorID)
            cmd.Parameters.AddWithValue("@MobileNo", EmpInfo.MobileNo)
            cmd.Parameters.AddWithValue("@NationalID", EmpInfo.NationalID)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using

    End Function

    Public Function fnSearchInActiveEmployee(ByVal EmpInfo As clsEmployee) As DataSet

        Dim sp As String = "spSearchInActiveEmployee"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@NameorID", EmpInfo.NameorID)
            cmd.Parameters.AddWithValue("@MobileNo", EmpInfo.MobileNo)
            cmd.Parameters.AddWithValue("@NationalID", EmpInfo.NationalID)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using

    End Function

    Public Function fnGetEmpListBySectionID(ByVal SectionID As String) As DataSet

        Dim sp As String = "spGetEmpListBySectionID"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SectionID", SectionID)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using

    End Function

    Public Function fnGetAllEmpDetails() As DataSet
        Dim sp As String = "spGetAllEmpDetails"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using
    End Function

    Public Function fnGetEmpInfoByRFIDCode(ByVal RFIDCode As String) As clsEmployee
        Dim EmpInfo As New clsEmployee()
        Dim sp As String = "spGetEmpInfoByRFIDCode"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@RFIDCode", RFIDCode)
            con.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()
            While dr.Read()
                EmpInfo.EmployeeName = dr.Item("EmployeeName")
                EmpInfo.EmpCode = dr.Item("EmpCode")
                EmpInfo.MobileNo = dr.Item("MobileNo")
                EmpInfo.EmpPhoto = dr.Item("EmpPhoto")
            End While
            con.Close()
            Return EmpInfo
        End Using

    End Function

    Public Function fnGetEmpInfoByID(ByVal EmployeeID As String) As clsEmployee
        Dim EmpInfo As New clsEmployee()
        Dim sp As String = "spGetEmpInfoByID"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID)
            con.Open()
            Dim dr As SqlDataReader = cmd.ExecuteReader()
            While dr.Read()
                EmpInfo.EmployeeName = dr.Item("EmployeeName")
                EmpInfo.EmpCode = dr.Item("EmpCode")
                EmpInfo.MobileNo = dr.Item("MobileNo")
                EmpInfo.EmpPhoto = dr.Item("EmpPhoto")
                EmpInfo.Designation = dr.Item("Designation")
                EmpInfo.Section = dr.Item("Section")
                EmpInfo.PermanentAddress = dr.Item("PermanentAddress")
                EmpInfo.PresentAddress = dr.Item("PresentAddress")
            End While
            con.Close()
            Return EmpInfo
        End Using

    End Function

#End Region

#Region " Login "

    Public Function fnLogin(ByVal EmployeeInfo As clsEmployee) As clsEmployee
        Dim EmpInfo As New clsEmployee()
        Dim sp As String = "spLogin"
        Dim ds As New DataSet

        Using con As New SqlConnection(ValmontConn)
            Try
                Dim cmd As New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@AccessModule", EmployeeInfo.AccessModule)
                cmd.Parameters.AddWithValue("@UserID", EmployeeInfo.UserID)
                cmd.Parameters.AddWithValue("@UserPassword", EmployeeInfo.UserPassword)
                con.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader()
                While dr.Read()
                    EmpInfo.UserID = EmployeeInfo.UserID
                    EmpInfo.EmployeeID = dr.Item("EmployeeID")
                    EmpInfo.EmployeeName = dr.Item("EmployeeName")
                    EmpInfo.PermittedMenu = dr.Item("PermittedMenu")
                End While
                con.Close()
                Return EmpInfo
            Catch ex As Exception
                If con.State = ConnectionState.Open Then
                    con.Close()
                End If
                Return Nothing
            End Try
        End Using

    End Function

#End Region

#Region " Change Password "

    Public Function fnChangePassword(ByVal EmployeeInfo As clsEmployee) As clsResult
        Dim sp As String = "spChangePassword"
        Dim result As New clsResult()

        Using con As New SqlConnection(ValmontConn)
            Try
                Dim cmd As New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@UserID", EmployeeInfo.UserID)
                cmd.Parameters.AddWithValue("@UserPassword", EmployeeInfo.UserPassword)
                cmd.Parameters.AddWithValue("@NewPassword", EmployeeInfo.NewPassword)
                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
                result.Success = True
                result.Message = "Password Changed"
                Return result
            Catch ex As Exception
                If con.State = ConnectionState.Open Then
                    con.Close()
                End If
                result.Success = False
                result.Message = "Password Changed Problem: " & ex.Message
                Return Nothing
            End Try
        End Using

    End Function

#End Region

End Class
