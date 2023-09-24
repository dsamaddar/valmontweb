Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsSection

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)

    Dim _SectionID, _Section, _SectionInBangla, _EntryBy As String

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

    Public Property SectionInBangla() As String
        Get
            Return _SectionInBangla
        End Get
        Set(ByVal value As String)
            _SectionInBangla = value
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


#Region " Insert Section "
    Public Function fnInsertSection(ByVal section As clsSection) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertSection", con)
            con.Open()

            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@Section", section.Section)
            cmd.Parameters.AddWithValue("@SectionInBangla", section.SectionInBangla)
            cmd.Parameters.AddWithValue("@IsActive", section.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", section.EntryBy)
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

#Region " Update Section "
    Public Function fnUpdateSection(ByVal section As clsSection) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateSection", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@SectionID", section.SectionID)
            cmd.Parameters.AddWithValue("@Section", section.Section)
            cmd.Parameters.AddWithValue("@SectionInBangla", section.SectionInBangla)
            cmd.Parameters.AddWithValue("@IsActive", section.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", section.EntryBy)
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

#Region " Get Section List "

    Public Function fnGetSectionList() As DataSet
        Return fnCallDropDownLoader("spGetSectionList")
    End Function

#End Region

End Class
