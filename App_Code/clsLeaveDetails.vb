Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic

Public Class clsLeaveDetails

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _LeaveDetailID, _LeaveBalanceID, _LeaveRequestID, _EmployeeID As String

    Public Property LeaveDetailID() As String
        Get
            Return _LeaveDetailID
        End Get
        Set(ByVal value As String)
            _LeaveDetailID = value
        End Set
    End Property

    Public Property LeaveBalanceID() As String
        Get
            Return _LeaveBalanceID
        End Get
        Set(ByVal value As String)
            _LeaveBalanceID = value
        End Set
    End Property

    Public Property LeaveRequestID() As String
        Get
            Return _LeaveRequestID
        End Get
        Set(ByVal value As String)
            _LeaveRequestID = value
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

    Dim _LeaveDate, _LeaveStartDate, _LeaveEndDate As Date

    Public Property LeaveDate() As Date
        Get
            Return _LeaveDate
        End Get
        Set(ByVal value As Date)
            _LeaveDate = value
        End Set
    End Property

    Public Property LeaveStartDate() As Date
        Get
            Return _LeaveStartDate
        End Get
        Set(ByVal value As Date)
            _LeaveStartDate = value
        End Set
    End Property

    Public Property LeaveEndDate() As Date
        Get
            Return _LeaveEndDate
        End Get
        Set(ByVal value As Date)
            _LeaveEndDate = value
        End Set
    End Property

#Region " Insert Leave Details "

    Public Function fnInsertLeaveDetails(ByVal LeaveDetails As clsLeaveDetails) As clsResult
        Dim result As New clsResult()
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertLeaveDetails", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", LeaveDetails.EmployeeID)
            cmd.Parameters.AddWithValue("@LeaveStartDate", LeaveDetails.LeaveStartDate)
            cmd.Parameters.AddWithValue("@LeaveEndDate", LeaveDetails.LeaveEndDate)
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

#Region " Delete Leave Details "

    Public Function fnDeleteLeaveDetails(ByVal LeaveDetailID As String) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spDeleteLeaveDetails", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@LeaveDetailID", LeaveDetailID)
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
   
#Region " Get Leave Details "

    Public Function fnGetLeaveDetails(ByVal EmployeeID As String) As DataSet
        Return fnCallDropDownLoader("spGetLeaveDetails", "@EmployeeID", EmployeeID)
    End Function

#End Region

End Class
