Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class clsItemRequisition

    Dim con As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString)
    Dim _RequisitionID, _RequisitionIDList, _EmployeeID, _ItemID, _ItemName, _Remarks, _EntryPoint, _SupervisorID, _DepartmentID, _ULCBranchID, _OnDemandRequisitionFor, _ApprovedBy, _RejectedBy, _DeliveredBy, _Status, _MailStatus, _ApproverRemarks, _EntryBy, _RequisitionItemList, _WarehouseID, _DeliveryEntryPoint, _RequisitionFor As String

    Public Property RequisitionID() As String
        Get
            Return _RequisitionID
        End Get
        Set(ByVal value As String)
            _RequisitionID = value
        End Set
    End Property

    Public Property RequisitionIDList() As String
        Get
            Return _RequisitionIDList
        End Get
        Set(ByVal value As String)
            _RequisitionIDList = value
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

    Public Property ItemID() As String
        Get
            Return _ItemID
        End Get
        Set(ByVal value As String)
            _ItemID = value
        End Set
    End Property

    Public Property ItemName() As String
        Get
            Return _ItemName
        End Get
        Set(ByVal value As String)
            _ItemName = value
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

    Public Property EntryPoint() As String
        Get
            Return _EntryPoint
        End Get
        Set(ByVal value As String)
            _EntryPoint = value
        End Set
    End Property

    Public Property SupervisorID() As String
        Get
            Return _SupervisorID
        End Get
        Set(ByVal value As String)
            _SupervisorID = value
        End Set
    End Property

    Public Property DepartmentID() As String
        Get
            Return _DepartmentID
        End Get
        Set(ByVal value As String)
            _DepartmentID = value
        End Set
    End Property

    Public Property ULCBranchID() As String
        Get
            Return _ULCBranchID
        End Get
        Set(ByVal value As String)
            _ULCBranchID = value
        End Set
    End Property

    Public Property OnDemandRequisitionFor() As String
        Get
            Return _OnDemandRequisitionFor
        End Get
        Set(ByVal value As String)
            _OnDemandRequisitionFor = value
        End Set
    End Property

    Public Property ApprovedBy() As String
        Get
            Return _ApprovedBy
        End Get
        Set(ByVal value As String)
            _ApprovedBy = value
        End Set
    End Property

    Public Property RejectedBy() As String
        Get
            Return _RejectedBy
        End Get
        Set(ByVal value As String)
            _RejectedBy = value
        End Set
    End Property

    Public Property DeliveredBy() As String
        Get
            Return _DeliveredBy
        End Get
        Set(ByVal value As String)
            _DeliveredBy = value
        End Set
    End Property

    Public Property Status() As String
        Get
            Return _Status
        End Get
        Set(ByVal value As String)
            _Status = value
        End Set
    End Property

    Public Property MailStatus() As String
        Get
            Return _MailStatus
        End Get
        Set(ByVal value As String)
            _MailStatus = value
        End Set
    End Property

    Public Property ApproverRemarks() As String
        Get
            Return _ApproverRemarks
        End Get
        Set(ByVal value As String)
            _ApproverRemarks = value
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

    Public Property RequisitionItemList() As String
        Get
            Return _RequisitionItemList
        End Get
        Set(ByVal value As String)
            _RequisitionItemList = value
        End Set
    End Property

    Public Property WarehouseID() As String
        Get
            Return _WarehouseID
        End Get
        Set(ByVal value As String)
            _WarehouseID = value
        End Set
    End Property

    Public Property DeliveryEntryPoint() As String
        Get
            Return _DeliveryEntryPoint
        End Get
        Set(ByVal value As String)
            _DeliveryEntryPoint = value
        End Set
    End Property

    Public Property RequisitionFor() As String
        Get
            Return _RequisitionFor
        End Get
        Set(ByVal value As String)
            _RequisitionFor = value
        End Set
    End Property

    Dim _Quantity, _ApprovedQuantity As Integer

    Public Property Quantity() As Integer
        Get
            Return _Quantity
        End Get
        Set(ByVal value As Integer)
            _Quantity = value
        End Set
    End Property

    Public Property ApprovedQuantity() As Integer
        Get
            Return _ApprovedQuantity
        End Get
        Set(ByVal value As Integer)
            _ApprovedQuantity = value
        End Set
    End Property

    Dim _IsOnDemandRequisition, _IsApproved, _IsRejected, _IsDelivered As Boolean

    Public Property IsOnDemandRequisition() As Boolean
        Get
            Return _IsOnDemandRequisition
        End Get
        Set(ByVal value As Boolean)
            _IsOnDemandRequisition = value
        End Set
    End Property

    Public Property IsApproved() As Boolean
        Get
            Return _IsApproved
        End Get
        Set(ByVal value As Boolean)
            _IsApproved = value
        End Set
    End Property

    Public Property IsRejected() As Boolean
        Get
            Return _IsRejected
        End Get
        Set(ByVal value As Boolean)
            _IsRejected = value
        End Set
    End Property

    Public Property IsDelivered() As String
        Get
            Return _IsDelivered
        End Get
        Set(ByVal value As String)
            _IsDelivered = value
        End Set
    End Property

    Dim _ApprovalDate, _RejectionDate, _DeliveryDate, _EntryDate, _DateFrom, _DateTo As DateTime

    Public Property ApprovalDate() As String
        Get
            Return _ApprovalDate
        End Get
        Set(ByVal value As String)
            _ApprovalDate = value
        End Set
    End Property

    Public Property RejectionDate() As DateTime
        Get
            Return _RejectionDate
        End Get
        Set(ByVal value As DateTime)
            _RejectionDate = value
        End Set
    End Property

    Public Property DeliveryDate() As DateTime
        Get
            Return _DeliveryDate
        End Get
        Set(ByVal value As DateTime)
            _DeliveryDate = value
        End Set
    End Property

    Public Property EntryDate() As DateTime
        Get
            Return _EntryDate
        End Get
        Set(ByVal value As DateTime)
            _EntryDate = value
        End Set
    End Property

    Public Property DateFrom() As DateTime
        Get
            Return _DateFrom
        End Get
        Set(ByVal value As DateTime)
            _DateFrom = value
        End Set
    End Property

    Public Property DateTo() As DateTime
        Get
            Return _DateTo
        End Get
        Set(ByVal value As DateTime)
            _DateTo = value
        End Set
    End Property

#Region " Insert Multiple Requisition "

    Public Function fnInsertMultipleRequisition(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertMultipleRequisition", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@EmployeeID", ItemRequisition.EmployeeID)
            cmd.Parameters.AddWithValue("@RequisitionItemList", ItemRequisition.RequisitionItemList)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)

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

#Region " Insert Multiple On Demand Requisition "

    Public Function fnInsertMultipleOnDemandReq(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spInsertMultipleOnDemandReq", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@RequisitionItemList", ItemRequisition.RequisitionItemList)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Search Item Requisition "

    Public Function fnSearchItemRequisition(ByVal ItemRequisition As clsItemRequisition) As DataSet

        Dim sp As String = "spSearchItemRequisition"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@DateFrom", ItemRequisition.DateFrom)
                cmd.Parameters.AddWithValue("@DateTo", ItemRequisition.DateTo)
                cmd.Parameters.AddWithValue("@WarehouseID", ItemRequisition.WarehouseID)
                cmd.Parameters.AddWithValue("@BranchID", ItemRequisition.ULCBranchID)
                cmd.Parameters.AddWithValue("@DepartmentID", ItemRequisition.DepartmentID)
                cmd.Parameters.AddWithValue("@EmployeeID", ItemRequisition.EmployeeID)
                cmd.Parameters.AddWithValue("@ItemID", ItemRequisition.ItemID)
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

#Region " Reject Requisition "

    Public Function fnRejectRequisition(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spRejectRequisition", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionID", ItemRequisition.RequisitionID)
            cmd.Parameters.AddWithValue("@ApproverRemarks", ItemRequisition.ApproverRemarks)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Accept Requisition "

    Public Function fnAcceptRequisition(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spAcceptRequisition", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionID", ItemRequisition.RequisitionID)
            cmd.Parameters.AddWithValue("@WarehouseID", ItemRequisition.WarehouseID)
            cmd.Parameters.AddWithValue("@ItemID", ItemRequisition.ItemID)
            cmd.Parameters.AddWithValue("@ApprovedQuantity", ItemRequisition.ApprovedQuantity)
            cmd.Parameters.AddWithValue("@ApproverRemarks", ItemRequisition.ApproverRemarks)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Advance Accept Requisition "

    Public Function fnAdvAcceptRequisition(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spAdvAcceptRequisition", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionIDList", ItemRequisition.RequisitionIDList)
            cmd.Parameters.AddWithValue("@WarehouseID", ItemRequisition.WarehouseID)
            cmd.Parameters.AddWithValue("@ApproverRemarks", ItemRequisition.ApproverRemarks)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Request Departmental Approval "

    Public Function fnReqDeptApproval(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spReqDeptApproval", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionIDList", ItemRequisition.RequisitionIDList)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Deliver Requisition "

    Public Function fnDeliverRequisition(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spDeliverRequisition", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionIDList", ItemRequisition.RequisitionIDList)
            cmd.Parameters.AddWithValue("@DeliveredBy", ItemRequisition.DeliveredBy)
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

#Region " Request Departmental Rejection "

    Public Function fnReqDeptRejection(ByVal ItemRequisition As clsItemRequisition) As Integer
        Try
            Dim cmd As SqlCommand = New SqlCommand("spReqDeptRejection", con)
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.AddWithValue("@RequisitionIDList", ItemRequisition.RequisitionIDList)
            cmd.Parameters.AddWithValue("@ApproverRemarks", ItemRequisition.ApproverRemarks)
            cmd.Parameters.AddWithValue("@EntryBy", ItemRequisition.EntryBy)
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

#Region " Get Requisition History By UserID "

    Public Function fnGetReqHistoryByUserID(ByVal ItemRequisition As clsItemRequisition) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetReqHistoryByUserID", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@EmployeeID", ItemRequisition.EmployeeID)
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

#Region " Itm Requisition For Dept Approval "

    Public Function fnItmReqForDeptApproval(ByVal ItemRequisition As clsItemRequisition) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spItmReqForDeptApproval", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DateFrom", ItemRequisition.DateFrom)
            cmd.Parameters.AddWithValue("@DateTo", ItemRequisition.DateTo)
            cmd.Parameters.AddWithValue("@BranchID", ItemRequisition.ULCBranchID)
            cmd.Parameters.AddWithValue("@DepartmentID", ItemRequisition.DepartmentID)
            cmd.Parameters.AddWithValue("@SupervisorID", ItemRequisition.SupervisorID)
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

#Region " Get Pending Requisition List To Deliver"

    Public Function fnGetPendingReqListToDeliver(ByVal ItemRequisition As clsItemRequisition) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetPendingReqListToDeliver", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DateFrom", ItemRequisition.DateFrom)
            cmd.Parameters.AddWithValue("@DateTo", ItemRequisition.DateTo)
            cmd.Parameters.AddWithValue("@ULCBranchID", ItemRequisition.ULCBranchID)
            cmd.Parameters.AddWithValue("@DepartmentID", ItemRequisition.DepartmentID)
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

#Region " Get Requisition By Delivery Entry Point "

    Public Function fnGetReqByDeliveryEntryPoint(ByVal DeliveryEntryPoint As String, ByVal DateFrom As DateTime, ByVal DateTo As DateTime) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetReqByDeliveryEntryPoint", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DeliveryEntryPoint", DeliveryEntryPoint)
            cmd.Parameters.AddWithValue("@DateFrom", DateFrom)
            cmd.Parameters.AddWithValue("@DateTo", DateTo)
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

#Region " Get Delivery Entry Point "

    Public Function fnGetDeliveryEntryPoint() As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetDeliveryEntryPoint", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
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

#Region " Get Requisition Status "

    Public Function fnGetRequisitionStatus() As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spGetRequisitionStatus", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
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

#Region " Show Requisition Report "

    Public Function fnShowRequisitionReport(ByVal ItemRequisitionInfo As clsItemRequisition) As DataSet
        Try
            Dim cmd As SqlCommand = New SqlCommand("spShowRequisitionReport", con)
            Dim ds As New DataSet()
            Dim da As New SqlDataAdapter()
            con.Open()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.AddWithValue("@DateFrom", ItemRequisitionInfo.DateFrom)
            cmd.Parameters.AddWithValue("@DateTo", ItemRequisitionInfo.DateTo)
            cmd.Parameters.AddWithValue("@ULCBranchID", ItemRequisitionInfo.ULCBranchID)
            cmd.Parameters.AddWithValue("@DepartmentID", ItemRequisitionInfo.DepartmentID)
            cmd.Parameters.AddWithValue("@EmployeeID", ItemRequisitionInfo.EmployeeID)
            cmd.Parameters.AddWithValue("@Status", ItemRequisitionInfo.Status)
            cmd.Parameters.AddWithValue("@ItemID", ItemRequisitionInfo.ItemID)
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

#Region " GetRequisition Remaining Department List "

    Public Function fnGetReqRemDepartmentList() As DataSet

        Dim sp As String = "spGetReqRemDepartmentList"
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

#Region " Get Req Rem Dept Wise User "

    Public Function fnGetReqRemDeptWiseUser(ByVal DepartmentID As String) As DataSet

        Dim sp As String = "spGetReqRemDeptWiseUser"
        Dim da As SqlDataAdapter = New SqlDataAdapter()
        Dim ds As DataSet = New DataSet()
        Try
            con.Open()
            Using cmd = New SqlCommand(sp, con)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@DepartmentID", DepartmentID)
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
