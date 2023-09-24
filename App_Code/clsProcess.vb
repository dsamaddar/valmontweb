Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsProcess

    Dim _ProcessID, _Process, _EntryBy As String

    Public Property ProcessID() As String
        Get
            Return _ProcessID
        End Get
        Set(ByVal value As String)
            _ProcessID = value
        End Set
    End Property

    Public Property Process() As String
        Get
            Return _Process
        End Get
        Set(ByVal value As String)
            _Process = value
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


#Region " Get Process List "

    Public Function fnGetProcessList() As DataSet
        Return fnCallDropDownLoader("spGetProcessList")
    End Function

#End Region

End Class
