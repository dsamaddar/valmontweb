Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports System.Data
Imports System.IO

Partial Class frmPrintEmpIDCard
    Inherits System.Web.UI.Page

    Public dtEmpIDCard As New DataTable()
    Dim EmpData As New clsEmployee()

    Protected Function FormatEmpIDCard() As DataTable
        Dim dt As DataTable = New DataTable()
        dt.Columns.Add("EmployeeName", System.Type.GetType("System.String"))
        dt.Columns.Add("EmpCode", System.Type.GetType("System.String"))
        dt.Columns.Add("Designation", System.Type.GetType("System.String"))
        dt.Columns.Add("Section", System.Type.GetType("System.String"))
        dt.Columns.Add("JoiningDate", System.Type.GetType("System.DateTime"))
        dt.Columns.Add("BloodGroup", System.Type.GetType("System.String"))
        dt.Columns.Add("EmpPhoto", System.Type.GetType("System.String"))
        dt.Columns.Add("AltMobile", System.Type.GetType("System.String"))
        dt.Columns.Add("MobileNo", System.Type.GetType("System.String"))
        dt.Columns.Add("NationalID", System.Type.GetType("System.String"))
        dt.Columns.Add("PermanentAddress", System.Type.GetType("System.String"))
        dt.Columns.Add("JoiningDateBangla", System.Type.GetType("System.String"))
        dt.Columns.Add("CardNoBangla", System.Type.GetType("System.String"))
        Return dt
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
    End Sub

    Protected Sub PrintIDCard(ByVal StartingCardNo As String, ByVal EndingCardNo As String)
        Dim serverName As [String], uid As [String], pwd As [String], dbName As [String]
        Dim strPath As String = ""
        Dim myImage As System.Drawing.Image
        Dim converter As New System.Drawing.ImageConverter
        Dim myReport As New ReportDocument()
        Dim folder As String
        Dim f As String
        Dim repName As String

        Try

            f = "~/Reports/"
            folder = Server.MapPath(f)

            If drpReportFormat.SelectedValue = "Bangla" Then
                dtEmpIDCard = EmpData.fnPrintIDCardBangla(StartingCardNo, EndingCardNo).Tables(0)
                repName = folder & "rptEmpIDCardBangla.rpt"
            Else
                dtEmpIDCard = EmpData.fnPrintIDCard(StartingCardNo, EndingCardNo).Tables(0)
                repName = folder & "rptEmpIDCard.rpt"
            End If


            dtEmpIDCard.Columns.Add(New DataColumn("Picture", System.Type.GetType("System.Byte[]")))
            dtEmpIDCard.AcceptChanges()
            For Each rw As DataRow In dtEmpIDCard.Rows
                strPath = Server.MapPath("~/Attachments/" + rw.Item("EmpPhoto"))
                myImage = System.Drawing.Image.FromFile(strPath)
                rw.Item("Picture") = converter.ConvertTo(myImage, System.Type.GetType("System.Byte[]"))
                rw.AcceptChanges()
            Next

            Dim conStr = ConfigurationManager.ConnectionStrings("ValmontConn").ConnectionString
            Dim retArr As [String](), usrArr As [String](), pwdArr As [String](), serverArr As [String](), dbArr As [String]()

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
            myReport.SetDataSource(dtEmpIDCard)
            'myReport.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, True, "ID-CARD-PRINT" & Now.Ticks.ToString())

            Dim mem As MemoryStream
            mem = DirectCast(myReport.ExportToStream(CrystalDecisions.[Shared].ExportFormatType.PortableDocFormat), MemoryStream)
            Response.Clear()
            Response.Buffer = True
            Response.ContentType = "application/pdf"
            Response.AddHeader("Content-Disposition", "attachment;filename=" + "ID-CARD-PRINT" & Now.Ticks.ToString() + ".pdf")
            Response.BinaryWrite(mem.ToArray())
            Response.End()

        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnPrintIDCard_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPrintIDCard.Click
        Try
            PrintIDCard(txtStartingCardNo.Text, txtEndingCardNo.Text)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
