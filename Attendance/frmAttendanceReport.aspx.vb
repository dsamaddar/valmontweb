Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared

Partial Class Attendance_frmAttendanceReport
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim SecData As New clsSection()
    Dim DesignationData As New clsDesignation()
    Dim Block As New clsBlock()

    Protected Sub btnDailyReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDailyReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptDailyAtt.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@DepartmentID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BranchID", drpBranchList.SelectedValue)
            myReport.SetParameterValue("@DesignationID", drpDesignation.SelectedValue)
            myReport.SetParameterValue("@DateFrom", Convert.ToDateTime(txtDateFrom.Text))
            myReport.SetParameterValue("@DateTo", Convert.ToDateTime(txtDateTo.Text))
            'myReport.SetParameterValue("@EmpTypeID", drpEmploymentType.SelectedValue)
            myReport.SetParameterValue("@AttStatus", drpAttStatus.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Attendance-Report-Daily" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetEmployeeList()
        drpEmployeeList.DataValueField = "EmployeeID"
        drpEmployeeList.DataTextField = "EmployeeName"
        drpEmployeeList.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpEmployeeList.DataBind()

        Dim A As New ListItem
        A.Text = "ALL"
        A.Value = "ALL"

        drpEmployeeList.Items.Insert(0, A)
    End Sub

    Protected Sub ShowDepertment()
        Try
            drpDepartments.DataTextField = "Section"
            drpDepartments.DataValueField = "SectionID"
            drpDepartments.DataSource = SecData.fnGetSectionList()
            drpDepartments.DataBind()

            Dim A As New ListItem
            A.Text = "ALL"
            A.Value = "ALL"

            drpDepartments.Items.Insert(0, A)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetAllBlockList()
        drpBlockList.DataTextField = "Block"
        drpBlockList.DataValueField = "BlockID"
        drpBlockList.DataSource = Block.fnGetBlockList()
        drpBlockList.DataBind()

        Dim A As New ListItem
        A.Text = "ALL"
        A.Value = "ALL"
        drpBlockList.Items.Insert(0, A)
    End Sub

    Protected Sub ShowDesignation()
        Try
            'drpDesignation.DataTextField = "DesignationName"
            'drpDesignation.DataValueField = "DesignationID"
            'drpDesignation.DataSource = EmpData.fnGetOfficialDesignation()
            'drpDesignation.DataBind()

            Dim A As New ListItem
            A.Text = "ALL"
            A.Value = "ALL"

            drpDesignation.Items.Insert(0, A)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ShowBranchList()
        'drpBranchList.DataTextField = "ULCBranchName"
        'drpBranchList.DataValueField = "ULCBranchID"
        'drpBranchList.DataSource = EmpData.fnGetULCBranch()
        'drpBranchList.DataBind()

        Dim A As New ListItem
        A.Text = "ALL"
        A.Value = "ALL"
        drpBranchList.Items.Insert(0, A)
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnMonthlySummary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMonthlySummary.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptMonthlyAttSummary.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@DesignationID", drpDesignation.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Attendance-Report-Monthly" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim MenuIDs As String

        MenuIDs = Session("PermittedMenus")

        If InStr(MenuIDs, "~att_attReport") = 0 Then
            Response.Redirect("~\frmLogin.aspx")
        End If

        If Not IsPostBack Then
            GetEmployeeList()
            ShowDepertment()
            ShowBranchList()
            ShowDesignation()
            ShowEmployeeType()
            GetAllBlockList()

            drpReportYear.SelectedValue = Now.Year.ToString()
            drpReportMonth.SelectedValue = Now.Month.ToString()
            txtDateFrom.Text = Now.Date
            txtDateTo.Text = Now.Date
        End If
    End Sub

    Protected Sub ShowEmployeeType()
        Try
            'drpEmploymentType.DataTextField = "EmployeeTypeName"
            'drpEmploymentType.DataValueField = "EmployeeTypeID"
            'drpEmploymentType.DataSource = EmpData.fnGetEmployeeType()
            'drpEmploymentType.DataBind()

            Dim A As New ListItem
            A.Text = "ALL"
            A.Value = "ALL"

            drpEmploymentType.Items.Insert(0, A)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnDailyPresentList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDailyPresentList.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptDailyPresentList.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@ReportDate", Convert.ToDateTime(txtDateFrom.Text))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Daily_present_list_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnDailyLateAttList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDailyLateAttList.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptDailyLateAttList.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@ReportDate", Convert.ToDateTime(txtDateFrom.Text))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Daily_late_attendance_list_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub


    Protected Sub btnDailyAbsentList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDailyAbsentList.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptDailyAbsentList.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@ReportDate", Convert.ToDateTime(txtDateFrom.Text))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Daily_Absent_list_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnEmpJobCard_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmpJobCard.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptEmpJobCard.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnEmpJobCardCompliance_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmpJobCardCompliance.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptEmpJobCardCompliance.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpBlockList.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Comp_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnDailyErrorReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDailyErrorReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptDailyErrorAttList.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@ReportDate", Convert.ToDateTime(txtDateFrom.Text))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Daily_error_attendance_list_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnShiftingDutyReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnShiftingDutyReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptEmpJobCardShifting.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@year", Convert.ToInt32(drpReportYear.SelectedValue))
            myReport.SetParameterValue("@month", Convert.ToInt32(drpReportMonth.SelectedValue))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Shifting_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnErrorRptShiftingDuty_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorRptShiftingDuty.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptErrorReportShiftingDuty.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@year", Convert.ToInt32(drpReportYear.SelectedValue))
            myReport.SetParameterValue("@month", Convert.ToInt32(drpReportMonth.SelectedValue))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Shifting_Duty_Error_Report_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnErrorRptShiftingDutyDaily_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorRptShiftingDutyDaily.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptErrorReportShiftingDutyDaily.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@ReportDate", Convert.ToDateTime(txtDateFrom.Text))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Shifting_Duty_Error_Report_Daily_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnInActiveEmpJobCardCompliance_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInActiveEmpJobCardCompliance.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptInActiveEmpJobCardCompliance.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Comp_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnInActiveShiftingDutyReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInActiveShiftingDutyReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptInActiveEmpJobCardShifting.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@year", Convert.ToInt32(drpReportYear.SelectedValue))
            myReport.SetParameterValue("@month", Convert.ToInt32(drpReportMonth.SelectedValue))
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Shifting_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnEmpOTReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmpOTReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptEmpJobCardOT.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpBlockList.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Comp_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnWeekEndOTReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnWeekEndOTReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptWeekendJobCardOT.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpBlockList.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Comp_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnShiftingDutyOTReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnShiftingDutyOTReport.Click
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]

        Dim conStr As String = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
        Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

        Try
            f = "~/Reports/"
            folder = Server.MapPath(f)
            repName = folder & "rptWeekendJobCardJacOT.rpt"
            myReport.Load(repName)

            retArr = conStr.Split(";")
            serverArr = retArr(0).Split("=")
            dbArr = retArr(1).Split("=")
            usrArr = retArr(2).Split("=")
            pwdArr = retArr(3).Split("=")

            serverName = serverArr(1)
            uid = usrArr(1)
            pwd = pwdArr(1)
            dbName = dbArr(1)

            myReport.SetDatabaseLogon(uid, pwd, serverName, dbName)

            Dim parameters As CrystalDecisions.Web.Parameter = New CrystalDecisions.Web.Parameter()
            myReport.SetParameterValue("@EmployeeID", drpEmployeeList.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpBlockList.SelectedValue)
            myReport.SetParameterValue("@year", drpReportYear.SelectedValue)
            myReport.SetParameterValue("@month", drpReportMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "Emp_Job_Card_Comp_" & Now.Ticks.ToString())
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub
End Class
