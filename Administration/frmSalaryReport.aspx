<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    CodeFile="frmSalaryReport.aspx.vb" Inherits="Administration_frmSalaryReport"
    Title="Salary Report" Theme="CommonSkin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table width="100%">
        <tr>
            <td>
                <asp:Panel ID="pnlSalaryReport" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Salary Report</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50px">
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
                                Section
                            </td>
                            <td>
                                <asp:DropDownList ID="drpDepartments" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Block</td>
                            <td>
                                <asp:DropDownList ID="drpSalaryBlockList" runat="server" CssClass="InputTxtBox" 
                                    Width="80px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Salary Year</td>
                            <td>
                                <asp:DropDownList ID="drpSalaryYear" runat="server" Width="80px">
                                    <asp:ListItem>2019</asp:ListItem>
                                    <asp:ListItem>2020</asp:ListItem>
                                    <asp:ListItem>2021</asp:ListItem>
                                    <asp:ListItem>2022</asp:ListItem>
                                    <asp:ListItem>2023</asp:ListItem>
                                    <asp:ListItem>2024</asp:ListItem>
                                    <asp:ListItem>2025</asp:ListItem>
                                    <asp:ListItem>2026</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Salary Month
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSalaryMonth" runat="server" Width="80px" 
                                    AutoPostBack="True">
                                    <asp:ListItem Value="1">January</asp:ListItem>
                                    <asp:ListItem Value="2">February</asp:ListItem>
                                    <asp:ListItem Value="3">March</asp:ListItem>
                                    <asp:ListItem Value="4">April</asp:ListItem>
                                    <asp:ListItem Value="5">May</asp:ListItem>
                                    <asp:ListItem Value="6">Jun</asp:ListItem>
                                    <asp:ListItem Value="7">July</asp:ListItem>
                                    <asp:ListItem Value="8">August</asp:ListItem>
                                    <asp:ListItem Value="9">September</asp:ListItem>
                                    <asp:ListItem Value="10">October</asp:ListItem>
                                    <asp:ListItem Value="11">November</asp:ListItem>
                                    <asp:ListItem Value="12">December</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Entry&nbsp; Point</td>
                            <td>
                                <asp:DropDownList ID="drpEntryPoint" runat="server" CssClass="InputTxtBox" 
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Export Format
                            </td>
                            <td>
                                <asp:DropDownList ID="drpExportFormat" runat="server">
                                    <asp:ListItem Text="PDF" Value="5"></asp:ListItem>
                                    <asp:ListItem Text="Rich Text" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Word for Windows" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Excel" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="Excel Record" Value="8"></asp:ListItem>
                                    <asp:ListItem Text="HTML 3.2" Value="6"></asp:ListItem>
                                </asp:DropDownList>
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
                                <asp:Button ID="btnSalaryReport" runat="server" CssClass="styled-button-1" 
                                    Text="Salary Report" />
                                &nbsp;<asp:Button ID="btnSalarySummary" runat="server" CssClass="styled-button-1" 
                                    Text="Salary Summary" />
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
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlBonusReport" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Bonus Report</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50px">
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
                                Festival
                            </td>
                            <td>
                                <asp:DropDownList ID="drpFestivalType" runat="server" Width="80px" 
                                    CssClass="InputTxtBox">
                                    <asp:ListItem Value="1">Eid al-Fitr</asp:ListItem>
                                    <asp:ListItem Value="2">Eid al-Adha</asp:ListItem>
                                    <asp:ListItem Value="3">Baishakhi Allowance</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnBonusReport" runat="server" CssClass="styled-button-1" 
                                    Text="Bonus Report" />
                                &nbsp;<asp:Button ID="btnBonusSummary" runat="server" CssClass="styled-button-1" 
                                    Text="Bonus Summary" />
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
                                <asp:Button ID="btnBonusReportComp" runat="server" Text="..." />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>
