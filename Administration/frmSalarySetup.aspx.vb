
Partial Class Administration_frmSalarySetup
    Inherits System.Web.UI.Page

    Dim EmpData As New clsEmployee()
    Dim SalarySetupData As New clsSalarySetup()

    Protected Sub btnUpdateActualSalary_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateActualSalary.Click
        Try
            Dim salary As New clsSalarySetup()

            salary.EmployeeID = drpEmployeeList.SelectedValue
            salary.BasicSalary = Convert.ToDouble(txtBasicSalary.Text)
            salary.HouseRent = Convert.ToDouble(txtHouseRent.Text)
            salary.MedicalAllowance = Convert.ToDouble(txtMedicalAllowance.Text)
            salary.GrossSalary = Convert.ToDouble(txtGrossSalary.Text)
            salary.FridayAllowance_per = Convert.ToDouble(txtFridayAllowance_per.Text)
            salary.FridayAllowance_fixed = Convert.ToDouble(txtFridayAllowance_fixed.Text)
            salary.Conveyance = Convert.ToDouble(txtConveyance.Text)
            salary.FoodAllowance = Convert.ToDouble(txtFoodAllowance.Text)
            salary.PaymentMethod = drpPaymentMethod.SelectedValue
            salary.BankAccountNo = txtBankAcNo.Text
            salary.EntryBy = Session("LoginUserID")

            Dim chkresult As clsResult = SalarySetupData.fnInsertSalarySetup(salary)

            MessageBox(chkresult.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetEmployeeList()
        End If
    End Sub

    Protected Sub GetEmployeeList()
        drpEmployeeList.DataValueField = "EmployeeID"
        drpEmployeeList.DataTextField = "EmployeeName"
        drpEmployeeList.DataSource = EmpData.fnGetEmpListPayrollActive()
        drpEmployeeList.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"

        drpEmployeeList.Items.Insert(0, A)
    End Sub

    Private Sub MessageBox(ByVal strMsg As String)
        Dim lbl As New System.Web.UI.WebControls.Label
        lbl.Text = "<script language='javascript'>" & Environment.NewLine _
                   & "window.alert(" & "'" & strMsg & "'" & ")</script>"
        Page.Controls.Add(lbl)
    End Sub

    Protected Sub drpEmployeeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpEmployeeList.SelectedIndexChanged
        Try
            GetEmployeeInfo(drpEmployeeList.SelectedValue)
            GetSalarySetup(drpEmployeeList.SelectedValue)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetEmployeeInfo(ByVal EmployeeID As String)
        Try
            If drpEmployeeList.SelectedValue = "N\A" Then
                ClearForm()
            Else
                Dim Emp As New clsEmployee()

                Emp = EmpData.fnGetEmpInfoByID(EmployeeID)

                lblSection.Text = Emp.Section
                lblDesignation.Text = Emp.Designation
                lblMobile.Text = Emp.MobileNo
                lblName.Text = Emp.EmployeeName
                lblPermanentAddress.Text = Emp.PermanentAddress
                lblPresentAddress.Text = Emp.PresentAddress
                impEmpPhoto.ImageUrl = "~/Attachments/" + Emp.EmpPhoto
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub ClearForm()
        txtBasicSalary.Text = ""
        txtFridayAllowance_fixed.Text = ""
        txtFridayAllowance_per.Text = ""
        txtHouseRent.Text = ""
        txtMedicalAllowance.Text = ""
    End Sub

    Protected Sub GetSalarySetup(ByVal EmployeeID As String)
        Try
            Dim salary As New clsSalarySetup()
            salary = SalarySetupData.fnGetSalarySetup(EmployeeID)

            txtBasicSalary.Text = salary.BasicSalary.ToString()
            txtHouseRent.Text = salary.HouseRent.ToString()
            txtMedicalAllowance.Text = salary.MedicalAllowance.ToString()
            txtGrossSalary.Text = salary.GrossSalary.ToString()
            txtFridayAllowance_per.Text = salary.FridayAllowance_per.ToString()
            txtFridayAllowance_fixed.Text = salary.FridayAllowance_fixed.ToString()
            txtConveyance.Text = salary.Conveyance.ToString()
            txtFoodAllowance.Text = salary.FoodAllowance.ToString()
            drpPaymentMethod.SelectedValue = salary.PaymentMethod
            txtBankAcNo.Text = salary.BankAccountNo.ToString()
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub txtGrossSalary_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtGrossSalary.TextChanged
        Try
            txtBasicSalary.Text = Math.Floor(((Convert.ToDouble(txtGrossSalary.Text) - 1850) / 1.5)).ToString()
            txtHouseRent.Text = Math.Ceiling((Convert.ToDouble(txtBasicSalary.Text) * 0.5))
            txtMedicalAllowance.Text = "600"
            txtConveyance.Text = "350"
            txtFoodAllowance.Text = "900"
            SetFocus(btnUpdateActualSalary)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

End Class
