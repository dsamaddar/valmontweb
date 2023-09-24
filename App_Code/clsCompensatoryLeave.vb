Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsCompensatoryLeave

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _CompensatoryLeaveID, _Remarks As String

    Public Property CompensatoryLeaveID() As String
        Get
            Return _CompensatoryLeaveID
        End Get
        Set(ByVal value As String)
            _CompensatoryLeaveID = value
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

    Dim _CompensatoryDate As DateTime

    Public Property CompensatoryDate() As DateTime
        Get
            Return _CompensatoryDate
        End Get
        Set(ByVal value As DateTime)
            _CompensatoryDate = value
        End Set
    End Property

    Public Function fnInsertCompensatoryLeave(ByVal com As clsCompensatoryLeave) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertCompensatoryLeave", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@CompensatoryDate", com.CompensatoryDate)
            cmd.Parameters.AddWithValue("@Remarks", com.Remarks)
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

    Public Function fnDeleteCompensatoryLeave(ByVal CompensatoryLeaveID As Integer) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spDeleteCompensatoryLeave", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@CompensatoryLeaveID", CompensatoryLeaveID)
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

    Public Function fnGetCompensatoryLeaveList() As DataSet
        Dim sp As String = "spGetCompensatoryLeaveList"
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
