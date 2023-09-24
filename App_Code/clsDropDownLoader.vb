Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Module clsDropDownLoader

    Public ValmontCon As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Public Function fnCallDropDownLoader(ByVal StoredProcedure As String) As DataSet

        Dim sp As String = StoredProcedure
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            ValmontCon.Open()
            Using cmd = New SqlCommand(sp, ValmontCon)
                cmd.CommandType = CommandType.StoredProcedure
                da.SelectCommand = cmd
                da.Fill(ds)
                ValmontCon.Close()
                Return ds
            End Using
        Catch ex As Exception
            If ValmontCon.State = ConnectionState.Open Then
                ValmontCon.Close()
            End If
            Return Nothing
        End Try
    End Function

    Public Function fnCallDropDownLoader(ByVal StoredProcedure As String, ByVal ParamName As String, ByVal ParamVal As String) As DataSet

        Dim sp As String = StoredProcedure
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            ValmontCon.Open()
            Using cmd = New SqlCommand(sp, ValmontCon)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue(ParamName, ParamVal)
                da.SelectCommand = cmd
                da.Fill(ds)
                ValmontCon.Close()
                Return ds
            End Using
        Catch ex As Exception
            If ValmontCon.State = ConnectionState.Open Then
                ValmontCon.Close()
            End If
            Return Nothing
        End Try
    End Function

End Module
