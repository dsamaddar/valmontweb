Imports System.Web.UI

Partial Class frmEmployeeInfo
    Inherits System.Web.UI.Page

    Dim Section As New clsSection()
    Dim Designation As New clsDesignation()
    Dim EmpInfoData As New clsEmployee()
    Dim Block As New clsBlock()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetSecitonList()
            GetDesignationList()
            GetAllEmpDetails()
            GetAllBlockList()
            geDistrictName()
            btnUpdate.Enabled = False
            imgEmpPhoto.ImageUrl = "~/Sources/img/photo_avator.png"
            imgEmpSignature.ImageUrl = "~/Sources/img/signature_avator.png"
        End If
    End Sub

    Protected Sub geDistrictName()
        drpPresentDistrict.DataTextField = "DistrictName"
        drpPresentDistrict.DataValueField = "DistrictID"
        drpPresentDistrict.DataSource = EmpInfoData.fnGetDistricts()
        drpPresentDistrict.DataBind()

        If drpPresentDistrict.Items.Count > 0 Then
            drpPresentDistrict.SelectedIndex = 0
            drpPresentUpazila.DataTextField = "UpazilaName"
            drpPresentUpazila.DataValueField = "UpazilaID"
            drpPresentUpazila.DataSource = EmpInfoData.fnGetUpazillaName(drpPresentDistrict.SelectedValue)
            drpPresentUpazila.DataBind()
        End If

        drpPermanentDistrict.DataTextField = "DistrictName"
        drpPermanentDistrict.DataValueField = "DistrictID"
        drpPermanentDistrict.DataSource = EmpInfoData.fnGetDistricts()
        drpPermanentDistrict.DataBind()

        If drpPermanentDistrict.Items.Count > 0 Then
            drpPermanentDistrict.SelectedIndex = 0
            drpPermanentUpazila.DataTextField = "UpazilaName"
            drpPermanentUpazila.DataValueField = "UpazilaID"
            drpPermanentUpazila.DataSource = EmpInfoData.fnGetUpazillaName(drpPermanentDistrict.SelectedValue)
            drpPermanentUpazila.DataBind()
        End If
    End Sub

    Protected Sub GetAllBlockList()
        drpBlockList.DataTextField = "Block"
        drpBlockList.DataValueField = "BlockID"
        drpBlockList.DataSource = Block.fnGetBlockList()
        drpBlockList.DataBind()

        Dim A As New ListItem
        A.Text = "N\A"
        A.Value = "N\A"
        drpBlockList.Items.Insert(0, A)
    End Sub

    Protected Sub GetAllEmpDetails()
        grdEmpDetails.DataSource = EmpInfoData.fnGetAllEmpDetails()
        grdEmpDetails.DataBind()
    End Sub

    Protected Sub GetSecitonList()
        drpSectionList.DataTextField = "Section"
        drpSectionList.DataValueField = "SectionID"
        drpSectionList.DataSource = Section.fnGetSectionList()
        drpSectionList.DataBind()
    End Sub

    Protected Sub GetDesignationList()
        drpDesignationList.DataTextField = "Designation"
        drpDesignationList.DataValueField = "DesignationID"
        drpDesignationList.DataSource = Designation.fnGetDesignationList()
        drpDesignationList.DataBind()
    End Sub

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click

        Dim folder As String = ""
        Dim Title As String = ""
        Dim DocExt As String = ""
        Dim DocFullName As String = ""
        Dim DocPrefix As String = ""
        Dim FileSize As Integer = 0
        Dim DocFileName As String = ""
        Dim DocumentCategory As String = "Document"

        Dim EmpInfo As New clsEmployee()

        Try
            EmpInfo.EmployeeName = txtEmployeeName.Text
            EmpInfo.EmpCode = txtEmpCode.Text
            EmpInfo.FathersName = txtFathersName.Text
            EmpInfo.MothersName = txtMothersName.Text
            EmpInfo.PresentDistrictID = drpPresentDistrict.SelectedValue
            EmpInfo.PresentUpazilaID = drpPresentUpazila.SelectedValue
            EmpInfo.PresentAddress = txtPresentAddress.Text
            EmpInfo.PermanentDistrictID = drpPermanentDistrict.SelectedValue
            EmpInfo.PermanentUpazilaID = drpPermanentUpazila.SelectedValue
            EmpInfo.PermanentAddress = txtPermanentAddress.Text
            EmpInfo.JoiningDate = Convert.ToDateTime(txtJoiningDate.Text)
            EmpInfo.MobileNo = txtMobileNo.Text
            EmpInfo.AlternateMobileNo = txtAlternateMobileNo.Text
            EmpInfo.MachineNo = txtMachineNo.Text
            EmpInfo.BasicSalary = Convert.ToDouble(txtBasicSalary.Text)
            EmpInfo.BlockID = drpBlockList.SelectedValue
            EmpInfo.PaymentMethod = drpPaymentMethod.SelectedValue
            EmpInfo.SectionID = drpSectionList.SelectedValue
            EmpInfo.DesignationID = drpDesignationList.SelectedValue
            EmpInfo.EmpStatus = "Active"

            EmpInfo.CardNo = txtCardNo.Text
            EmpInfo.CardNoBangla = txtCardNoInBangla.Text
            EmpInfo.EmployeeNameBangla = txtEmpNameInBangla.Text
            EmpInfo.JoiningDateBangla = txtJoiningDateInBangla.Text

            If chkIsActive.Checked = True Then
                EmpInfo.IsActive = True
            Else
                EmpInfo.IsActive = False
            End If

            If chkIncludedInPayroll.Checked = True Then
                EmpInfo.InCludedInPayroll = True
            Else
                EmpInfo.InCludedInPayroll = False
            End If

            EmpInfo.BloodGroup = drpBloodGroup.SelectedValue
            EmpInfo.NationalID = txtNationalID.Text

            If flupEmpPhoto.HasFile Then

                folder = Server.MapPath("~/Attachments/")

                FileSize = flupEmpPhoto.PostedFile.ContentLength()
                If FileSize > 4194304 Then
                    MessageBox("File size should be within 4MB")
                    Exit Sub
                End If

                DocPrefix = Title.Replace(" ", "")

                DocExt = System.IO.Path.GetExtension(flupEmpPhoto.FileName)
                DocFileName = "EMP-PHOTO-" & DateTime.Now.ToString("ddMMyyHHmmss") & DocExt
                DocFullName = folder & DocFileName
                flupEmpPhoto.SaveAs(DocFullName)

                EmpInfo.EmpPhoto = DocFileName
            Else
                EmpInfo.EmpPhoto = ""
            End If

            If flupEmpSignature.HasFile Then

                folder = Server.MapPath("~/Attachments/")

                FileSize = flupEmpSignature.PostedFile.ContentLength()
                If FileSize > 4194304 Then
                    MessageBox("File size should be within 4MB")
                    Exit Sub
                End If

                DocPrefix = Title.Replace(" ", "")

                DocExt = System.IO.Path.GetExtension(flupEmpSignature.FileName)
                DocFileName = "EMP-PHOTO-" & DateTime.Now.ToString("ddMMyyHHmmss") & DocExt
                DocFullName = folder & DocFileName
                flupEmpSignature.SaveAs(DocFullName)

                EmpInfo.EmpSignature = DocFileName
            Else
                EmpInfo.EmpSignature = ""
            End If

            If txtExitDate.Text = "" Then
                EmpInfo.ExitDate = Nothing
            Else
                EmpInfo.ExitDate = Convert.ToDateTime(txtExitDate.Text)
            End If

            EmpInfo.EntryBy = Session("LoginUserID")

            Dim result As clsResult = EmpInfo.fnInsertEmployee(EmpInfo)

            If result.Success = True Then
                ClearForm()
                GetAllEmpDetails()
            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try

    End Sub

    Protected Sub ClearForm()
        txtEmployeeName.Text = ""
        txtEmpCode.Text = ""
        txtFathersName.Text = ""
        txtMothersName.Text = ""
        txtPresentAddress.Text = ""
        txtPermanentAddress.Text = ""
        txtMobileNo.Text = ""
        txtBasicSalary.Text = "0"
        drpSectionList.SelectedIndex = -1
        drpDesignationList.SelectedIndex = -1
        drpBlockList.SelectedIndex = -1

        txtCardNo.Text = ""
        txtCardNoInBangla.Text = ""
        txtEmpNameInBangla.Text = ""
        txtJoiningDateInBangla.Text = ""
        txtExitDate.Text = ""

        btnInsert.Enabled = True
        btnUpdate.Enabled = False
        hdFldEmployeeID.Value = ""

    End Sub

    Protected Sub grdEmpDetails_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdEmpDetails.SelectedIndexChanged
        Dim lblEmployeeID, lblEmployeeName, lblEmpCode, lblFathersName, lblMothersName, lblPresentAddress, lblPermanentAddress, lblJoiningDate, lblMobileNo, lblAlternateMobileNo, lblMachineNo, _
        lblEmpPhoto, lblEmpSignature, lblBasicSalary, lblPaymentMethod, lblBlockID, lblSectionID, lblDesignationID, lblEmpStatus, lblActive, lblInPayroll, _
        lblPresentDistrictID, lblPermanentDistrictID, lblPresentUpazilaID, lblPermanentUpazilaID, lblNationalID, lblBloodGroup, _
        lblCardNo, lblCardNoBangla, lblEmployeeNameBangla, lblJoiningDateBangla, lblExitDate As New Label

        lblEmployeeID = grdEmpDetails.SelectedRow.FindControl("lblEmployeeID")
        lblEmployeeName = grdEmpDetails.SelectedRow.FindControl("lblEmployeeName")
        lblEmpCode = grdEmpDetails.SelectedRow.FindControl("lblEmpCode")
        lblFathersName = grdEmpDetails.SelectedRow.FindControl("lblFathersName")
        lblMothersName = grdEmpDetails.SelectedRow.FindControl("lblMothersName")
        lblPresentAddress = grdEmpDetails.SelectedRow.FindControl("lblPresentAddress")
        lblPermanentAddress = grdEmpDetails.SelectedRow.FindControl("lblPermanentAddress")
        lblJoiningDate = grdEmpDetails.SelectedRow.FindControl("lblJoiningDate")
        lblMobileNo = grdEmpDetails.SelectedRow.FindControl("lblMobileNo")
        lblAlternateMobileNo = grdEmpDetails.SelectedRow.FindControl("lblAlternateMobileNo")
        lblMachineNo = grdEmpDetails.SelectedRow.FindControl("lblMachineNo")
        lblEmpPhoto = grdEmpDetails.SelectedRow.FindControl("lblEmpPhoto")
        lblEmpSignature = grdEmpDetails.SelectedRow.FindControl("lblEmpSignature")
        lblBasicSalary = grdEmpDetails.SelectedRow.FindControl("lblBasicSalary")
        lblPaymentMethod = grdEmpDetails.SelectedRow.FindControl("lblPaymentMethod")
        lblBlockID = grdEmpDetails.SelectedRow.FindControl("lblBlockID")
        lblSectionID = grdEmpDetails.SelectedRow.FindControl("lblSectionID")
        lblDesignationID = grdEmpDetails.SelectedRow.FindControl("lblDesignationID")
        lblEmpStatus = grdEmpDetails.SelectedRow.FindControl("lblEmpStatus")
        lblActive = grdEmpDetails.SelectedRow.FindControl("lblActive")
        lblInPayroll = grdEmpDetails.SelectedRow.FindControl("lblInPayroll")
        lblPresentDistrictID = grdEmpDetails.SelectedRow.FindControl("lblPresentDistrictID")
        lblPermanentDistrictID = grdEmpDetails.SelectedRow.FindControl("lblPermanentDistrictID")
        lblPresentUpazilaID = grdEmpDetails.SelectedRow.FindControl("lblPresentUpazilaID")
        lblPermanentUpazilaID = grdEmpDetails.SelectedRow.FindControl("lblPermanentUpazilaID")
        lblNationalID = grdEmpDetails.SelectedRow.FindControl("lblNationalID")
        lblBloodGroup = grdEmpDetails.SelectedRow.FindControl("lblBloodGroup")
        lblCardNo = grdEmpDetails.SelectedRow.FindControl("lblCardNo")
        lblCardNoBangla = grdEmpDetails.SelectedRow.FindControl("lblCardNoBangla")
        lblEmployeeNameBangla = grdEmpDetails.SelectedRow.FindControl("lblEmployeeNameBangla")
        lblJoiningDateBangla = grdEmpDetails.SelectedRow.FindControl("lblJoiningDateBangla")
        lblExitDate = grdEmpDetails.SelectedRow.FindControl("lblExitDate")

        Try
            hdFldEmployeeID.Value = lblEmployeeID.Text
            txtBasicSalary.Text = Convert.ToDouble(lblBasicSalary.Text)
            txtEmpCode.Text = lblEmpCode.Text
            txtEmployeeName.Text = lblEmployeeName.Text
            txtFathersName.Text = lblFathersName.Text
            txtMothersName.Text = lblMothersName.Text
            txtMachineNo.Text = lblMachineNo.Text
            txtPresentAddress.Text = lblPresentAddress.Text
            txtPermanentAddress.Text = lblPermanentAddress.Text
            txtJoiningDate.Text = Convert.ToDateTime(lblJoiningDate.Text)
            txtMobileNo.Text = lblMobileNo.Text
            txtAlternateMobileNo.Text = lblAlternateMobileNo.Text
            drpSectionList.SelectedValue = lblSectionID.Text
            drpBlockList.SelectedValue = lblBlockID.Text
            drpDesignationList.SelectedValue = lblDesignationID.Text
            txtNationalID.Text = lblNationalID.Text
            drpBloodGroup.SelectedValue = lblBloodGroup.Text
            drpPaymentMethod.SelectedValue = lblPaymentMethod.Text

            txtCardNo.Text = lblCardNo.Text
            txtCardNoInBangla.Text = lblCardNoBangla.Text
            txtEmpNameInBangla.Text = lblEmployeeNameBangla.Text
            txtJoiningDateInBangla.Text = lblJoiningDateBangla.Text
            txtExitDate.Text = lblExitDate.Text

            If lblEmpPhoto.Text <> "" Then
                imgEmpPhoto.ImageUrl = "~/Attachments/" + lblEmpPhoto.Text
            Else
                imgEmpPhoto.ImageUrl = ""
            End If

            If lblEmpSignature.Text <> "" Then
                imgEmpSignature.ImageUrl = "~/Attachments/" + lblEmpSignature.Text
            Else
                imgEmpSignature.ImageUrl = ""
            End If

            If lblActive.Text = "YES" Then
                chkIsActive.Checked = True
            Else
                chkIsActive.Checked = False
            End If

            If lblInPayroll.Text = "YES" Then
                chkIncludedInPayroll.Checked = True
            Else
                chkIncludedInPayroll.Checked = False
            End If

            If lblPresentDistrictID.Text <> "0" Then
                drpPresentDistrict.SelectedValue = lblPresentDistrictID.Text
                GetPresentUpazila(drpPresentDistrict.SelectedValue)
            End If

            If lblPermanentDistrictID.Text <> "0" Then
                drpPermanentDistrict.SelectedValue = lblPermanentDistrictID.Text
                GetPermanentUpazila(drpPermanentDistrict.SelectedValue)
            End If

            btnInsert.Enabled = False
            btnUpdate.Enabled = True

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

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Dim folder As String = ""
        Dim Title As String = ""
        Dim DocExt As String = ""
        Dim DocFullName As String = ""
        Dim DocPrefix As String = ""
        Dim FileSize As Integer = 0
        Dim DocFileName As String = ""
        Dim DocumentCategory As String = "Document"

        Dim EmpInfo As New clsEmployee()

        Try
            If hdFldEmployeeID.Value = "" Then
                MessageBox("Select An Employee First.")
                Exit Sub
            End If

            EmpInfo.EmployeeID = hdFldEmployeeID.Value
            EmpInfo.EmployeeName = txtEmployeeName.Text
            EmpInfo.EmpCode = txtEmpCode.Text
            EmpInfo.FathersName = txtFathersName.Text
            EmpInfo.MothersName = txtMothersName.Text
            EmpInfo.PresentDistrictID = drpPresentDistrict.SelectedValue
            EmpInfo.PresentUpazilaID = drpPresentUpazila.SelectedValue
            EmpInfo.PresentAddress = txtPresentAddress.Text
            EmpInfo.PermanentDistrictID = drpPermanentDistrict.SelectedValue
            EmpInfo.PermanentUpazilaID = drpPermanentUpazila.SelectedValue
            EmpInfo.PermanentAddress = txtPermanentAddress.Text
            EmpInfo.JoiningDate = Convert.ToDateTime(txtJoiningDate.Text)
            EmpInfo.MobileNo = txtMobileNo.Text
            EmpInfo.AlternateMobileNo = txtAlternateMobileNo.Text
            EmpInfo.MachineNo = txtMachineNo.Text
            EmpInfo.BasicSalary = Convert.ToDouble(txtBasicSalary.Text)
            EmpInfo.PaymentMethod = drpPaymentMethod.SelectedValue
            EmpInfo.BlockID = drpBlockList.SelectedValue
            EmpInfo.SectionID = drpSectionList.SelectedValue
            EmpInfo.DesignationID = drpDesignationList.SelectedValue
            EmpInfo.EmpStatus = "Active"

            EmpInfo.CardNo = txtCardNo.Text
            EmpInfo.CardNoBangla = txtCardNoInBangla.Text
            EmpInfo.EmployeeNameBangla = txtEmpNameInBangla.Text
            EmpInfo.JoiningDateBangla = txtJoiningDateInBangla.Text

            If txtExitDate.Text = "" Then
                EmpInfo.ExitDate = "01/01/2030"
            Else
                EmpInfo.ExitDate = Convert.ToDateTime(txtExitDate.Text)
            End If

            If chkIsActive.Checked = True Then
                EmpInfo.IsActive = True
            Else
                EmpInfo.IsActive = False
            End If

            If chkIncludedInPayroll.Checked = True Then
                EmpInfo.InCludedInPayroll = True
            Else
                EmpInfo.InCludedInPayroll = False
            End If

            EmpInfo.BloodGroup = drpBloodGroup.SelectedValue
            EmpInfo.NationalID = txtNationalID.Text

            If flupEmpPhoto.HasFile Then

                folder = Server.MapPath("~/Attachments/")

                FileSize = flupEmpPhoto.PostedFile.ContentLength()
                If FileSize > 4194304 Then
                    MessageBox("File size should be within 4MB")
                    Exit Sub
                End If

                DocPrefix = Title.Replace(" ", "")

                DocExt = System.IO.Path.GetExtension(flupEmpPhoto.FileName)
                DocFileName = "EMP-PHOTO-" & DateTime.Now.ToString("ddMMyyHHmmss") & DocExt
                DocFullName = folder & DocFileName
                flupEmpPhoto.SaveAs(DocFullName)

                EmpInfo.EmpPhoto = DocFileName
            Else
                EmpInfo.EmpPhoto = ""
            End If

            If flupEmpSignature.HasFile Then

                folder = Server.MapPath("~/Attachments/")

                FileSize = flupEmpSignature.PostedFile.ContentLength()
                If FileSize > 4194304 Then
                    MessageBox("File size should be within 4MB")
                    Exit Sub
                End If

                DocPrefix = Title.Replace(" ", "")

                DocExt = System.IO.Path.GetExtension(flupEmpSignature.FileName)
                DocFileName = "EMP-SIG-" & DateTime.Now.ToString("ddMMyyHHmmss") & DocExt
                DocFullName = folder & DocFileName
                flupEmpSignature.SaveAs(DocFullName)

                EmpInfo.EmpSignature = DocFileName
            Else
                EmpInfo.EmpSignature = ""
            End If

            EmpInfo.EntryBy = Session("LoginUserID")

            Dim result As clsResult = EmpInfo.fnUpdateEmployee(EmpInfo)

            If result.Success = True Then
                ClearForm()
                GetAllEmpDetails()
            End If
            MessageBox(result.Message)
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub drpPresentDistrict_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpPresentDistrict.SelectedIndexChanged
        GetPresentUpazila(drpPresentDistrict.SelectedValue)
    End Sub

    Protected Sub GetPresentUpazila(ByVal ID As String)
        drpPresentUpazila.DataTextField = "UpazilaName"
        drpPresentUpazila.DataValueField = "UpazilaID"
        drpPresentUpazila.DataSource = EmpInfoData.fnGetUpazillaName(drpPresentDistrict.SelectedValue)
        drpPresentUpazila.DataBind()
    End Sub

    Protected Sub drpPermanentDistrict_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpPermanentDistrict.SelectedIndexChanged
        GetPermanentUpazila(drpPermanentDistrict.SelectedValue)
    End Sub

    Protected Sub GetPermanentUpazila(ByVal ID As String)
        drpPermanentUpazila.DataTextField = "UpazilaName"
        drpPermanentUpazila.DataValueField = "UpazilaID"
        drpPermanentUpazila.DataSource = EmpInfoData.fnGetUpazillaName(drpPermanentDistrict.SelectedValue)
        drpPermanentUpazila.DataBind()
    End Sub

End Class
