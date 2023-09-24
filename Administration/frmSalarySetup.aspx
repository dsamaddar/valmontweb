<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    CodeFile="frmSalarySetup.aspx.vb" Inherits="Administration_frmSalarySetup" Title="Salary Setup"
    Theme="CommonSkin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlEmpSelection" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="5">
                                <div class="widget-title">
                                    Salary Setup</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 200px">
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Select an employee
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEmployeeList" runat="server" AutoPostBack="True" CssClass="InputTxtBox"
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <td rowspan="3">
                                <asp:Image ID="impEmpPhoto" runat="server" Height="100px" ImageAlign="Middle" />
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Name
                            </td>
                            <td>
                                <asp:Label ID="lblName" runat="server" CssClass="label"></asp:Label>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Section
                            </td>
                            <td>
                                <asp:Label ID="lblSection" runat="server" CssClass="label"></asp:Label>
                            </td>
                            <td class="label">
                                Designation
                            </td>
                            <td>
                                <asp:Label ID="lblDesignation" runat="server" CssClass="label"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Mobile
                            </td>
                            <td>
                                <asp:Label ID="lblMobile" runat="server" CssClass="label"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Present Address
                            </td>
                            <td>
                                <asp:Label ID="lblPresentAddress" runat="server" CssClass="label" Height="40px" Width="200px"></asp:Label>
                            </td>
                            <td class="label">
                                Permanent Address
                            </td>
                            <td>
                                <asp:Label ID="lblPermanentAddress" runat="server" CssClass="label" 
                                    Height="40px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
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
                <asp:Panel ID="pnlBankSalary" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="5">
                                <div class="widget-title">
                                    Bank Salary</div>
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Basic
                            </td>
                            <td>
                                <asp:TextBox ID="txtBasicSalary" runat="server" CssClass="InputTxtBox" ValidationGroup="salarysetup"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldBasicSalary" runat="server" ControlToValidate="txtBasicSalary"
                                    ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                House Rent
                            </td>
                            <td>
                                <asp:TextBox ID="txtHouseRent" runat="server" CssClass="InputTxtBox" ValidationGroup="salarysetup"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldHouseRent" runat="server" ControlToValidate="txtHouseRent"
                                    ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Medical Allowance
                            </td>
                            <td>
                                <asp:TextBox ID="txtMedicalAllowance" runat="server" CssClass="InputTxtBox" ValidationGroup="salarysetup"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldMedicalAllowance" runat="server" ControlToValidate="txtMedicalAllowance"
                                    ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Friday Allowance (%)
                            </td>
                            <td>
                                <asp:TextBox ID="txtFridayAllowance_per" runat="server" CssClass="InputTxtBox" ValidationGroup="salarysetup"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldFridayAllowance_per" runat="server" ControlToValidate="txtFridayAllowance_per"
                                    ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Gross Salary
                            </td>
                            <td>
                                <asp:TextBox ID="txtGrossSalary" runat="server" CssClass="InputTxtBox" AutoPostBack="True"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldMedicalAllowance0" runat="server" ControlToValidate="txtGrossSalary"
                                    ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Friday Allowance Fixed
                            </td>
                            <td>
                                <asp:TextBox ID="txtFridayAllowance_fixed" runat="server" CssClass="InputTxtBox"
                                    ValidationGroup="salarysetup"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldFridayAllowance_fixed" runat="server"
                                    ControlToValidate="txtFridayAllowance_fixed" ErrorMessage="*" ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Conveyance</td>
                            <td>
                                <asp:TextBox ID="txtConveyance" runat="server" CssClass="InputTxtBox" 
                                    ValidationGroup="salarysetup">0</asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldConveyance" runat="server" 
                                    ControlToValidate="txtConveyance" ErrorMessage="*" 
                                    ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Food Allowance</td>
                            <td>
                                <asp:TextBox ID="txtFoodAllowance" runat="server" CssClass="InputTxtBox" 
                                    ValidationGroup="salarysetup">0</asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldFoodAllowance" runat="server" 
                                    ControlToValidate="txtFoodAllowance" ErrorMessage="*" 
                                    ValidationGroup="salarysetup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;</td>
                            <td class="label">
                                Payment Method</td>
                            <td>
                                <asp:DropDownList ID="drpPaymentMethod" runat="server" CssClass="InputTxtBox" 
                                    Width="120px">
                                    <asp:ListItem Value="B">Bank Payment</asp:ListItem>
                                    <asp:ListItem Value="C">Cash Payment</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Bank A/C No</td>
                            <td>
                                <asp:TextBox ID="txtBankAcNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnUpdateActualSalary" runat="server" 
                                    CssClass="styled-button-1" Text="Update" ValidationGroup="salarysetup" />
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
            &nbsp;</td>
        </tr>
        </table>
</asp:Content>
