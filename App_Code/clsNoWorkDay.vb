Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsNoWorkDay

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _NoWorkDayID, _EmployeeID As String

    Public Property NoWorkDayID() As String
        Get
            Return _NoWorkDayID
        End Get
        Set(ByVal value As String)
            _NoWorkDayID = value
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

    Dim _NoWorkDay, _NoWorkDayStartDate, _NoWorkDayEndDate As Date

    Public Property NoWorkDay() As Date
        Get
            Return _NoWorkDay
        End Get
        Set(ByVal value As Date)
            _NoWorkDay = value
        End Set
    End Property

    Public Property NoWorkDayStartDate() As Date
        Get
            Return _NoWorkDayStartDate
        End Get
        Set(ByVal value As Date)
            _NoWorkDayStartDate = value
        End Set
    End Property

    Public Property NoWorkDayEndDate() As Date
        Get
            Return _NoWorkDayEndDate
        End Get
        Set(ByVal value As Date)
            _NoWorkDayEndDate = value
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

#Region " Insert No Work Day "
    Public Function fnInsertNoWorkDay(ByVal NoWorkDay As clsNoWorkDay) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertNoWorkDay", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", NoWorkDay.EmployeeID)
            cmd.Parameters.AddWithValue("@NoWorkDay", NoWorkDay.NoWorkDay)
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

#Region " Insert No Work Days "
    Public Function fnInsertNoWorkDays(ByVal NoWorkDay As clsNoWorkDay) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertNoWorkDays", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", NoWorkDay.EmployeeID)
            cmd.Parameters.AddWithValue("@NoWorkDayStartDate", NoWorkDay.NoWorkDayStartDate)
            cmd.Parameters.AddWithValue("@NoWorkDayEndDate", NoWorkDay.NoWorkDayEndDate)
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
            result.Message = ex.Message
            Return result
        End Try
    End Function
#End Region

#Region " Delete No Work Day "

    Public Function fnDeleteNoWorkDay(ByVal NoWorkDayID As String) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spDeleteNoWorkDay", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@NoWorkDayID", NoWorkDayID)
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

#Region " Get No Work Day By EmpID "

    Public Function fnGetNoWorkDayByEmpID(ByVal EmployeeID As String) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetNoWorkDayByEmpID", con)
            Dim da As SqlDataAdapter = New SqlDataAdapter()
            Dim ds As DataSet = New DataSet()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID)
            cmd.ExecuteNonQuery()
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

End Class
