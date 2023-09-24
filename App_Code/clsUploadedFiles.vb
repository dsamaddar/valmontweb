Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsUploadedFiles

    Dim ValmontConn As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString

    Dim _UploadFileID, _EmployeeID, _FileType, _FileTitle, _EntryBy As String

    Public Property UploadFileID() As String
        Get
            Return _UploadFileID
        End Get
        Set(ByVal value As String)
            _UploadFileID = value
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

    Public Property FileType() As String
        Get
            Return _FileType
        End Get
        Set(ByVal value As String)
            _FileType = value
        End Set
    End Property

    Public Property FileTitle() As String
        Get
            Return _FileTitle
        End Get
        Set(ByVal value As String)
            _FileTitle = value
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

    Dim _EntryDate As DateTime

    Public Property EntryDate() As DateTime
        Get
            Return _EntryDate
        End Get
        Set(ByVal value As DateTime)
            _EntryDate = value
        End Set
    End Property

#Region " Insert Uploaded Files "

    Public Function fnInsertUploadedFiles(ByVal UploadedFiles As clsUploadedFiles) As clsResult
        Dim result As New clsResult()
        Dim sp As String = "spInsertUploadedFiles"
        Dim con As New SqlConnection(ValmontConn)
        Try
            con.Open()
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("EmployeeID", UploadedFiles.EmployeeID)
            cmd.Parameters.AddWithValue("FileType", UploadedFiles.FileType)
            cmd.Parameters.AddWithValue("FileTitle", UploadedFiles.FileTitle)
            cmd.Parameters.AddWithValue("EntryBy", UploadedFiles.EntryBy)
            cmd.ExecuteNonQuery()
            result.Success = True
            result.Message = "Uploded Successfully."
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

#Region " Get Uploaded Files "

    Public Function fnGetUploadedFilesByEmp(ByVal EmployeeID As String) As DataSet

        Dim sp As String = "spGetUploadedFilesByEmp"
        Dim ds As New DataSet
        Using con As New SqlConnection(ValmontConn)
            Dim cmd As New SqlCommand(sp, con)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", EmployeeID)
            con.Open()
            Dim da As SqlDataAdapter = New SqlDataAdapter(cmd)
            da.Fill(ds)
            con.Close()
            Return ds
        End Using

    End Function

#End Region

End Class
