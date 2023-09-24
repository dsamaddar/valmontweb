Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsLeaveException

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _ExceptionID, _Remarks As String

    Public Property ExceptionID() As String
        Get
            Return _ExceptionID
        End Get
        Set(ByVal value As String)
            _ExceptionID = value
        End Set
    End Property

    Public Property Remarks() As String
        Get
            Return _Remarks
        End Get
        Set(ByVal value As String)
            _Remarks = value
        End Set
    End Property

    Dim _ExceptionDate As DateTime

    Public Property ExceptionDate() As DateTime
        Get
            Return _ExceptionDate
        End Get
        Set(ByVal value As DateTime)
            _ExceptionDate = value
        End Set
    End Property

    Public Function fnInsertExceptions(ByVal exp As clsLeaveException) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertLeaveException", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ExceptionDate", exp.ExceptionDate)
            cmd.Parameters.AddWithValue("@Remarks", exp.Remarks)
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

    Public Function fnDeleteLeaveException(ByVal ExceptionID As String) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spDeleteLeaveException", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@ExceptionID", ExceptionID)
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

    Public Function fnGetLeaveExceptionList() As DataSet
        Dim sp As String = "spGetLeaveExceptionList"
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

End Class
