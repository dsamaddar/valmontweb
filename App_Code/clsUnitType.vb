Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsUnitType

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _UnitTypeID, _UnitType, _EntryBy As String

    Public Property UnitTypeID() As String
        Get
            Return _UnitTypeID
        End Get
        Set(ByVal value As String)
            _UnitTypeID = value
        End Set
    End Property

    Public Property UnitType() As String
        Get
            Return _UnitType
        End Get
        Set(ByVal value As String)
            _UnitType = value
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

#Region " Insert Unit Type "

    Public Function fnInsertUnitType(ByVal UnitType As clsUnitType) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertUnitType", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UnitType", UnitType.UnitType)
            cmd.Parameters.AddWithValue("@IsActive", UnitType.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", UnitType.EntryBy)

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

#Region " Update Unit Type "

    Public Function fnUpdateUnitType(ByVal UnitType As clsUnitType) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spUpdateUnitType", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@UnitTypeID", UnitType.UnitTypeID)
            cmd.Parameters.AddWithValue("@UnitType", UnitType.UnitType)
            cmd.Parameters.AddWithValue("@IsActive", UnitType.IsActive)
            cmd.Parameters.AddWithValue("@EntryBy", UnitType.EntryBy)
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

#Region " Get Unit Type List "

    Public Function fnGetUnitTypeList() As DataSet

        Dim sp As String = "spGetUnitTypeList"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
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

#Region " Show Details Unit Type List "

    Public Function fnShowDetailsUnitTypeList() As DataSet

        Dim sp As String = "spShowDetailsUnitTypeList"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
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
