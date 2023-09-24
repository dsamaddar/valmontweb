
Partial Class frmUploadFiles
    Inherits System.Web.UI.Page

    Dim UploadFilesData As New clsUploadedFiles()
    Dim EmpData As New clsEmployee()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'btnUpload.Enabled = False
        End If
    End Sub

    Protected Sub grdEmpList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdEmpList.SelectedIndexChanged

        Dim lblEmployeeID As New Label
        Try
            lblEmployeeID = grdEmpList.SelectedRow.FindControl("lblEmployeeID")
            GetUploadedFiles(lblEmployeeID.Text)
            btnUpload.Enabled = True
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
    End Sub

    Protected Sub GetUploadedFiles(ByVal EmployeeID As String)
        grdUploadedFilesByEmp.DataSource = UploadFilesData.fnGetUploadedFilesByEmp(EmployeeID)
        grdUploadedFilesByEmp.DataBind()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        ClearSelection()
        Dim EmpInfo As New clsEmployee()
        Try
            EmpInfo.NameorID = txtNameorCode.Text
            EmpInfo.MobileNo = txtMobileNo.Text
            EmpInfo.NationalID = txtNationalID.Text

            grdEmpList.DataSource = EmpData.fnSearchEmployees(EmpInfo)
            grdEmpList.DataBind()
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

    Protected Sub ClearSelection()
        If grdEmpList.Rows.Count > 0 Then
            grdEmpList.SelectedIndex = -1
        End If

        grdEmpList.DataSource = ""
        grdEmpList.DataBind()

        drpFileType.SelectedIndex = -1

    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim folder As String = ""
        Dim Title As String = ""
        Dim DocExt As String = ""
        Dim DocFullName As String = ""
        Dim DocPrefix As String = ""
        Dim FileSize As Integer = 0
        Dim DocFileName As String = ""
        Dim DocumentCategory As String = "Document"

        Dim UploadFiles As New clsUploadedFiles()

        Try
            Dim lblEmployeeID As New Label
            lblEmployeeID = grdEmpList.SelectedRow.FindControl("lblEmployeeID")

            If lblEmployeeID.Text = "" Then
                MessageBox("Select An Employee First.")
            End If

            If flupDocuments.HasFile Then

                folder = Server.MapPath("~/Attachments/")

                FileSize = flupDocuments.PostedFile.ContentLength()
                If FileSize > 10485760 Then
                    MessageBox("File size should be within 10MB")
                    Exit Sub
                End If

                DocPrefix = Title.Replace(" ", "")

                DocExt = System.IO.Path.GetExtension(flupDocuments.FileName)
                DocFileName = drpFileType.SelectedValue & "-" & DateTime.Now.ToString("ddMMyyHHmmss") & DocExt
                DocFullName = folder & DocFileName
                flupDocuments.SaveAs(DocFullName)

                UploadFiles.EmployeeID = lblEmployeeID.Text
                UploadFiles.FileType = drpFileType.SelectedItem.ToString()
                UploadFiles.FileTitle = DocFileName
                UploadFiles.EntryBy = "dsamaddar" 'Session("LoginUserID")

                Dim result As clsResult = UploadFilesData.fnInsertUploadedFiles(UploadFiles)

                If result.Success = True Then
                    GetUploadedFiles(lblEmployeeID.Text)
                End If

                MessageBox(result.Message)

            Else
                MessageBox("Select A Document To Upload.")
                Exit Sub
            End If
        Catch ex As Exception
            MessageBox(ex.Message)
        End Try
       
    End Sub

End Class
