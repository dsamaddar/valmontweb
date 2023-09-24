Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared

Partial Class Administration_frmSalaryReport
    Inherits System.Web.UI.Page

    Dim SalaryData As New clsSalarySetup()
    Dim SecData As New clsSection()
    Dim Block As New clsBlock()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            drpSalaryYear.SelectedValue = Now.Year.ToString()
            drpSalaryMonth.SelectedValue = Now.Month.ToString()
            ShowDepertment()
            GetAllBlockList()
            GetEntryPoints()
        End If
    End Sub

    Protected Sub GetEntryPoints()
        drpEntryPoint.DataTextField = "value"
        drpEntryPoint.DataValueField = "id"
        drpEntryPoint.DataSource = SalaryData.fnGetEntryPoints(drpSalaryYear.SelectedValue, drpSalaryMonth.SelectedValue)
        drpEntryPoint.DataBind()
    End Sub


    Protected Sub GetAllBlockList()
        drpSalaryBlockList.DataTextField = "Block"
        drpSalaryBlockList.DataValueField = "BlockID"
        drpSalaryBlockList.DataSource = Block.fnGetBlockList()
        drpSalaryBlockList.DataBind()

        Dim A As New ListItem
        A.Text = "ALL"
        A.Value = "ALL"
        drpSalaryBlockList.Items.Insert(0, A)
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
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

    Protected Sub btnSalaryReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSalaryReport.Click
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
            repName = folder & "rptSalaryReport.rpt"
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
            myReport.SetParameterValue("@SalaryYear", drpSalaryYear.SelectedValue)
            myReport.SetParameterValue("@SalaryMonth", drpSalaryMonth.SelectedValue)
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpSalaryBlockList.SelectedValue)
            myReport.SetParameterValue("@EntryPoint", drpEntryPoint.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "salary_report_" & drpSalaryYear.SelectedValue.ToString() & "_" & drpSalaryMonth.SelectedValue.ToString() & "_" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnBonusReport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBonusReport.Click
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
            repName = folder & "rptBonusReport.rpt"
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
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpSalaryBlockList.SelectedValue)
            myReport.SetParameterValue("@FestivalTypeID", drpFestivalType.SelectedValue)
            myReport.SetParameterValue("@FestivalYear", drpSalaryYear.SelectedValue)
            myReport.SetParameterValue("@FestivalMonth", drpSalaryMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "festival_bonus_report_" & drpSalaryYear.SelectedValue.ToString() & "_" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnBonusSummary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBonusSummary.Click
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
            repName = folder & "rptBonusSummary.rpt"
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

            myReport.SetParameterValue("@FestivalTypeID", drpFestivalType.SelectedValue)
            myReport.SetParameterValue("@FestivalYear", drpSalaryYear.SelectedValue)
            myReport.SetParameterValue("@FestivalMonth", drpSalaryMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "festival_summary_" & drpSalaryYear.SelectedValue.ToString() & "_" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnSalarySummary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSalarySummary.Click
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
            repName = folder & "rptSalarySummary.rpt"
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
            myReport.SetParameterValue("@SalaryYear", drpSalaryYear.SelectedValue)
            myReport.SetParameterValue("@SalaryMonth", drpSalaryMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "salary_summary_report_" & drpSalaryYear.SelectedValue.ToString() & "_" & drpSalaryMonth.SelectedValue.ToString() & "_" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnBonusReportComp_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBonusReportComp.Click
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
            repName = folder & "rptBonusReportComp.rpt"
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
            myReport.SetParameterValue("@SectionID", drpDepartments.SelectedValue)
            myReport.SetParameterValue("@BlockID", drpSalaryBlockList.SelectedValue)
            myReport.SetParameterValue("@FestivalTypeID", drpFestivalType.SelectedValue)
            myReport.SetParameterValue("@FestivalYear", drpSalaryYear.SelectedValue)
            myReport.SetParameterValue("@FestivalMonth", drpSalaryMonth.SelectedValue)
            myReport.ExportToHttpResponse(drpExportFormat.SelectedValue, Response, True, "festival_bonus_report_comp_" & drpSalaryYear.SelectedValue.ToString() & "_" & Now.Ticks)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub drpSalaryMonth_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSalaryMonth.SelectedIndexChanged
        GetEntryPoints()
    End Sub
End Class
