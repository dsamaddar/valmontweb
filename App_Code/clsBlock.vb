Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class clsBlock

    Dim ValmontConn As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString

    Dim _BlockID, _Block, _EntryBy As String

    Public Property BlockID() As String
        Get
            Return _BlockID
        End Get
        Set(ByVal value As String)
            _BlockID = value
        End Set
    End Property

    Public Property Block() As String
        Get
            Return _Block
        End Get
        Set(ByVal value As String)
            _Block = value
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

#Region " Get Block List "

    Public Function fnGetBlockList() As DataSet
        Return fnCallDropDownLoader("spGetBlockList")
    End Function

#End Region


End Class
