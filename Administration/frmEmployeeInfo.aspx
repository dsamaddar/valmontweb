<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmEmployeeInfo.aspx.vb" Inherits="frmEmployeeInfo"
    Title=".::Valmonte Sweaters: Employee Info::." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        p.MsoNormal
        {
            margin-top: 0in;
            margin-right: 0in;
            margin-bottom: 10.0pt;
            margin-left: 0in;
            line-height: 100%;
            font-size: 10.0pt;
            font-family: "Calibri" , "sans-serif";
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        window.onload = function() {
            var strCook = document.cookie;
            if (strCook.indexOf("!~") != 0) {
                var intS = strCook.indexOf("!~");
                var intE = strCook.indexOf("~!");
                var strPos = strCook.substring(intS + 2, intE);
                document.getElementById("divCandidate").scrollTop = strPos;
                }
        }
        function SetDivPosition() {
            var intY = document.getElementById("divCandidate").scrollTop;
            document.title = intY;
            document.cookie = "yPos=!~" + intY + "~!";
        }
    </script>

    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlEmpInputForm" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="8">
                                <div class="widget-title">
                                    Employee Information
                                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td align="center" rowspan="6">
                                <asp:Image ID="imgEmpPhoto" runat="server" Height="200px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Employee Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtEmployeeName" runat="server" Width="150px" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td class="label">
                                Emp Code
                            </td>
                            <td style="margin-left: 80px">
                                <asp:TextBox ID="txtEmpCode" runat="server" Width="150px" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td class="label">
                                Present Dist.
                            </td>
                            <td>
                                <asp:DropDownList ID="drpPresentDistrict" runat="server" CssClass="InputTxtBox" Width="150px"
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Father&#39;s Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtFathersName" runat="server" Width="150px" CssClass="InputTxtBox">.</asp:TextBox>
                            </td>
                            <td class="label">
                                Mother&#39;s Name
                            </td>
                            <td style="margin-left: 40px">
                                <asp:TextBox ID="txtMothersName" runat="server" Width="150px" CssClass="InputTxtBox">.</asp:TextBox>
                            </td>
                            <td class="label">
                                Present Upazila/Thana
                            </td>
                            <td style="margin-left: 40px">
                                <asp:DropDownList ID="drpPresentUpazila" runat="server" CssClass="InputTxtBox" Width="150px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Mobile No
                            </td>
                            <td>
                                <asp:TextBox ID="txtMobileNo" runat="server" CssClass="InputTxtBox" Width="150px">.</asp:TextBox>
                            </td>
                            <td class="label">
                                Alternate Mobile No
                            </td>
                            <td>
                                <asp:TextBox ID="txtAlternateMobileNo" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td class="label">
                                Present Address
                            </td>
                            <td>
                                <asp:TextBox ID="txtPresentAddress" runat="server" CssClass="InputTxtBox" Height="50px"
                                    TextMode="MultiLine" Width="150px">.</asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Section
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSectionList" runat="server" CssClass="InputTxtBox" Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Designation
                            </td>
                            <td>
                                <asp:DropDownList ID="drpDesignationList" runat="server" CssClass="InputTxtBox" Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Card No
                            </td>
                            <td>
                                <asp:TextBox ID="txtCardNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Basic Salary
                            </td>
                            <td>
                                <asp:TextBox ID="txtBasicSalary" runat="server" CssClass="InputTxtBox" Width="100px">0</asp:TextBox>
                            </td>
                            <td class="label">
                                Block
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBlockList" runat="server" CssClass="InputTxtBox" Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Permanent Dist.
                            </td>
                            <td>
                                <asp:DropDownList ID="drpPermanentDistrict" runat="server" CssClass="InputTxtBox"
                                    Width="150px" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Joining Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtJoiningDate" runat="server" CssClass="InputTxtBox" Width="100px"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtJoiningDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtJoiningDate">
                                </cc1:CalendarExtender>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldJoiningDate" runat="server" ControlToValidate="txtJoiningDate"
                                    Display="None" ErrorMessage="Joining Date Required" ValidationGroup="EmpInfo"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldJoiningDate_ValidatorCalloutExtender" runat="server"
                                    CloseImageUrl="~/Sources/icon/valClose.png" CssClass="customCalloutStyle" Enabled="True"
                                    TargetControlID="reqFldJoiningDate" WarningIconImageUrl="~/Sources/icon/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                            <td class="label">
                                Machine No
                            </td>
                            <td>
                                <asp:TextBox ID="txtMachineNo" runat="server" CssClass="InputTxtBox" Width="150px">.</asp:TextBox>
                            </td>
                            <td class="label">
                                Permanent Upazila/Thana
                            </td>
                            <td>
                                <asp:DropDownList ID="drpPermanentUpazila" runat="server" CssClass="InputTxtBox"
                                    Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:FileUpload ID="flupEmpPhoto" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" Checked="True" />
                            </td>
                            <td class="label">
                                Included In Payroll
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIncludedInPayroll" runat="server" Checked="True" />
                            </td>
                            <td class="label">
                                Permanent Address
                            </td>
                            <td>
                                <asp:TextBox ID="txtPermanentAddress" runat="server" CssClass="InputTxtBox" Height="50px"
                                    TextMode="MultiLine" Width="150px">.</asp:TextBox>
                            </td>
                            <td align="center" rowspan="3">
                                <asp:Image ID="imgEmpSignature" runat="server" Height="50px" Width="200px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Blood Group
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBloodGroup" runat="server" CssClass="InputTxtBox" Width="100px">
                                    <asp:ListItem>N\A</asp:ListItem>
                                    <asp:ListItem>A+</asp:ListItem>
                                    <asp:ListItem>A-</asp:ListItem>
                                    <asp:ListItem>B+</asp:ListItem>
                                    <asp:ListItem>B-</asp:ListItem>
                                    <asp:ListItem>AB+</asp:ListItem>
                                    <asp:ListItem>AB-</asp:ListItem>
                                    <asp:ListItem>O+</asp:ListItem>
                                    <asp:ListItem>O-</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                National ID
                            </td>
                            <td>
                                <asp:TextBox ID="txtNationalID" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td class="label" style="color: Red">
                                Exit Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtExitDate" runat="server" CssClass="InputTxtBox" Width="100px"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtExitDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtExitDate">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                &nbsp;</td>
                            <td>
                                <asp:DropDownList ID="drpPaymentMethod" runat="server" CssClass="InputTxtBox" 
                                    Width="120px" Visible="False">
                                    <asp:ListItem Value="B">Bank Payment</asp:ListItem>
                                    <asp:ListItem Value="C">Cash Payment</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldEmployeeID" runat="server" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td class="label">
                                বাংলায় তথ্যঃ
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;</td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:FileUpload ID="flupEmpSignature" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                <p class="MsoNormal">
                                    <span lang="BN" style="font-size: 10.0pt; mso-ansi-font-size: 11.0pt; line-height: 115%;
                                        font-family: Vrinda; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin;
                                        mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin; mso-bidi-font-family: Vrinda;
                                        mso-bidi-theme-font: minor-bidi">শ্রমিকের নামঃ</span></p>
                            </td>
                            <td>
                                <asp:TextBox ID="txtEmpNameInBangla" runat="server" CssClass="InputTxtBox" Width="150px">.</asp:TextBox>
                            </td>
                            <td class="label">
                                <p class="MsoNormal">
                                    <span lang="BN" style="font-size: 10.0pt; mso-ansi-font-size: 11.0pt; line-height: 115%;
                                        font-family: Vrinda; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin;
                                        mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin; mso-bidi-font-family: Vrinda;
                                        mso-bidi-theme-font: minor-bidi">যোগদানের তারিখঃ</span></p>
                            </td>
                            <td>
                                <asp:TextBox ID="txtJoiningDateInBangla" runat="server" CssClass="InputTxtBox" Width="100px"></asp:TextBox>
                            </td>
                            <td class="label">
                                <p class="MsoNormal">
                                    <span lang="BN" style="font-size: 10.0pt; mso-ansi-font-size: 11.0pt; line-height: 115%;
                                        font-family: Vrinda; mso-ascii-font-family: Calibri; mso-ascii-theme-font: minor-latin;
                                        mso-hansi-font-family: Calibri; mso-hansi-theme-font: minor-latin; mso-bidi-font-family: Vrinda;
                                        mso-bidi-theme-font: minor-bidi">কার্ড নং-</span></p>
                            </td>
                            <td>
                                <asp:TextBox ID="txtCardNoInBangla" runat="server" CssClass="InputTxtBox" Width="150px">.</asp:TextBox>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnInsert" runat="server" CssClass="styled-button-1" Text="Submit" />
                                &nbsp;<asp:Button ID="btnUpdate" runat="server" CssClass="styled-button-1" Text="Update" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlEmpListDetails" runat="server" SkinID="pnlInner">
                    <div id="divCandidate" onscroll="SetDivPosition()" style="max-height: 300px; max-width: 100%;
                        overflow: auto">
                        <asp:GridView ID="grdEmpDetails" runat="server" AutoGenerateColumns="False" BackColor="White"
                            BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" CssClass="mGrid">
                            <RowStyle ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="Select" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                            Text="Select"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmployeeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeID" runat="server" Text='<%# Bind("EmployeeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmployeeName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeName" runat="server" Text='<%# Bind("EmployeeName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmpCode">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpCode" runat="server" Text='<%# Bind("EmpCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FathersName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFathersName" runat="server" Text='<%# Bind("FathersName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MothersName" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMothersName" runat="server" Text='<%# Bind("MothersName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PresentAddress" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPresentAddress" runat="server" Text='<%# Bind("PresentAddress") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PermanentAddress" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPermanentAddress" runat="server" Text='<%# Bind("PermanentAddress") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="JoiningDate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblJoiningDate" runat="server" Text='<%# Bind("JoiningDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MobileNo">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMobileNo" runat="server" Text='<%# Bind("MobileNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="AlternateMobileNo" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAlternateMobileNo" runat="server" Text='<%# Bind("AlternateMobileNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MachineNo">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMachineNo" runat="server" Text='<%# Bind("MachineNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmpPhoto" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpPhoto" runat="server" Text='<%# Bind("EmpPhoto") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmpSignature" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpSignature" runat="server" Text='<%# Bind("EmpSignature") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BasicSalary">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBasicSalary" runat="server" Text='<%# Bind("BasicSalary") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="PM" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPaymentMethod" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BlockID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBlockID" runat="server" Text='<%# Bind("BlockID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Block">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBlock" runat="server" Text='<%# Bind("Block") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SectionID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSectionID" runat="server" Text='<%# Bind("SectionID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Section">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSection" runat="server" Text='<%# Bind("Section") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DesignationID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignationID" runat="server" Text='<%# Bind("DesignationID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignation" runat="server" Text='<%# Bind("Designation") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmpStatus">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpStatus" runat="server" Text='<%# Bind("EmpStatus") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Active">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# Bind("Active") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="InPayroll">
                                    <ItemTemplate>
                                        <asp:Label ID="lblInPayroll" runat="server" Text='<%# Bind("InPayroll") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PresentDistrictID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPresentDistrictID" runat="server" Text='<%# Bind("PresentDistrictID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PermanentDistrictID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPermanentDistrictID" runat="server" Text='<%# Bind("PermanentDistrictID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PresentUpazilaID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPresentUpazilaID" runat="server" Text='<%# Bind("PresentUpazilaID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PermanentUpazilaID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPermanentUpazilaID" runat="server" Text='<%# Bind("PermanentUpazilaID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BloodGroup" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBloodGroup" runat="server" Text='<%# Bind("BloodGroup") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="NationalID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNationalID" runat="server" Text='<%# Bind("NationalID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="CardNo" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCardNo" runat="server" Text='<%# Bind("CardNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="CardNoBangla" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCardNoBangla" runat="server" Text='<%# Bind("CardNoBangla") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmployeeNameBangla" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeNameBangla" runat="server" Text='<%# Bind("EmployeeNameBangla") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="JoiningDateBangla" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblJoiningDateBangla" runat="server" Text='<%# Bind("JoiningDateBangla") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ExitDate" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblExitDate" runat="server" Text='<%# Bind("ExitDate","{0:MM/dd/yyyy}") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
