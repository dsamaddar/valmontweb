
Partial Class Administration_frmProcessSalary
    Inherits System.Web.UI.Page

    Dim SalaryData As New clsSalarySetup()

    Protected Sub btnProcessSalary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcessSalary.Click
        Try
            Dim result As New clsResult()
            result = SalaryData.fnProcessSalaryAll(drpSalaryYear.SelectedValue, drpSalaryMonth.SelectedValue, _
                                                   Convert.ToDateTime(txtSalaryStartDate.Text), Convert.ToDateTime(txtSalaryEndDate.Text), Session("LoginUserID"))
            If result.Success = True Then

            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            drpSalaryYear.SelectedValue = Now.Year.ToString()
            drpSalaryMonth.SelectedValue = Now.Month.ToString()
            drpFestivalYear.SelectedValue = Now.Year.ToString()
            drpFestivalMonth.SelectedValue = Now.Month.ToString()
            txtEffectiveDate.Text = Now.Date
            txtSalaryStartDate.Text = New DateTime(Now.Year, Now.Month, 1)
            txtSalaryEndDate.Text = New DateTime(Now.Year, Now.Month, DateTime.DaysInMonth(Now.Year, Now.Month))
        End If
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub btnProcessFestivalBonus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcessFestivalBonus.Click
        Try
            Dim result As New clsResult()

            result = SalaryData.fnProcessFestivalBonus(Convert.ToInt32(drpFestivalType.SelectedValue), _
                                                       Convert.ToInt32(drpFestivalYear.SelectedValue), _
                                                       Convert.ToInt32(drpFestivalMonth.SelectedValue), _
                                                       Convert.ToDateTime(txtEffectiveDate.Text), Session("LoginUserID"))
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub drpSalaryMonth_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpSalaryMonth.SelectedIndexChanged
        txtSalaryStartDate.Text = New DateTime(Convert.ToInt32(drpSalaryYear.SelectedValue), Convert.ToInt32(drpSalaryMonth.SelectedValue), 1)
        txtSalaryEndDate.Text = New DateTime(Convert.ToInt32(drpSalaryYear.SelectedValue), Convert.ToInt32(drpSalaryMonth.SelectedValue), DateTime.DaysInMonth(Convert.ToInt32(drpSalaryYear.SelectedValue), Convert.ToInt32(drpSalaryMonth.SelectedValue)))

    End Sub
End Class
