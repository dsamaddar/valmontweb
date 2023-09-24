Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsDesignation

    Public con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _DesignationID, _Designation, _DesignationBangla, _ShortCode, _DesignationLevel, _DesignationType, _EntryBy As String

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

    Public Property DesignationBangla() As String
        Get
            Return _DesignationBangla
        End Get
        Set(ByVal value As String)
            _DesignationBangla = value
        End Set
    End Property

    Public Property ShortCode() As String
        Get
            Return _ShortCode
        End Get
        Set(ByVal value As String)
            _ShortCode = value
        End Set
    End Property

    Public Property DesignationLevel() As String
        Get
            Return _DesignationLevel
        End Get
        Set(ByVal value As String)
            _DesignationLevel = value
        End Set
    End Property

    Public Property DesignationType() As String
        Get
            Return _DesignationType
        End Get
        Set(ByVal value As String)
            _DesignationType = value
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

    Dim _IntOrder As Integer

    Public Property IntOrder() As Integer
        Get
            Return _IntOrder
        End Get
        Set(ByVal value As Integer)
            _IntOrder = value
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

#Region " Insert Designation "
    Public Function fnInsertDesignation(ByVal Designation As clsDesignation) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertDesignation", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Designation", Designation.Designation)
            cmd.Parameters.AddWithValue("@DesignationBangla", Designation.DesignationBangla)
            cmd.Parameters.AddWithValue("@ShortCode", Designation.ShortCode)
            cmd.Parameters.AddWithValue("@DesignationLevel", Designation.DesignationLevel)
            cmd.Parameters.AddWithValue("@DesignationType", Designation.DesignationType)
            cmd.Parameters.AddWithValue("@IntOrder", Designation.IntOrder)
            cmd.Parameters.AddWithValue("@IsActive", Designation.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Designation.EntryBy)
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
            result.Message = "Error Found : " & ex.Message
            Return result
        End Try
    End Function
#End Region

#Region " Update Designation "
    Public Function fnUpdateDesignation(ByVal Designation As clsDesignation) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateDesignation", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DesignationID", Designation.DesignationID)
            cmd.Parameters.AddWithValue("@Designation", Designation.Designation)
            cmd.Parameters.AddWithValue("@DesignationBangla", Designation.DesignationBangla)
            cmd.Parameters.AddWithValue("@ShortCode", Designation.ShortCode)
            cmd.Parameters.AddWithValue("@DesignationLevel", Designation.DesignationLevel)
            cmd.Parameters.AddWithValue("@DesignationType", Designation.DesignationType)
            cmd.Parameters.AddWithValue("@IntOrder", Designation.IntOrder)
            cmd.Parameters.AddWithValue("@IsActive", Designation.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", Designation.EntryBy)
            cmd.ExecuteNonQuery()
            con.Close()
            result.Success = True
            result.Message = "Updated Successfully."
            Return result
        Catch ex As Exception
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
            result.Success = False
            result.Message = "Error Found : " & ex.Message
            Return result
        End Try
    End Function
#End Region

#Region " Get Designation List "

    Public Function fnGetDesignationList() As DataSet
        Return fnCallDropDownLoader("spGetDesignationList")
    End Function

#End Region

#Region " Get functional Designation Type "

    Public Function fnGetFunctionalDesignation() As DataSet

        Dim sp As String = "spGetFunctionalDesignation"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
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

#Region " Get Official Designation List "

    Public Function fnGetOfficialDesignation() As DataSet

        Dim sp As String = "spGetOfficialDesignation"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd As SqlCommand = New SqlCommand(sp, con)
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
