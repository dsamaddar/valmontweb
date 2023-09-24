<%@ Page Language="VB" MasterPageFile="~/Production/Production.master" AutoEventWireup="false"
    CodeFile="frmMaterialReport.aspx.vb" Inherits="Production_frmMaterialReport"
    Theme="CommonSkin" Title=".:Valmont:Report:Material:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlMatIssueReport" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="6">
                                <div class="widget-title">
                                    Material Issue Report</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px">
                            </td>
                            <td style="width: 100px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 20px">
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Issue Date Range
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssueDateFrom" runat="server" CssClass="InputTxtBox" Width="120px"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtIssueDateFrom_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtIssueDateFrom">
                                </cc1:CalendarExtender>
                            </td>
                            <td>
                                -
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssueDateTo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtIssueDateTo_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtIssueDateTo">
                                </cc1:CalendarExtender>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Export Format
                            </td>
                            <td>
                                <asp:DropDownList ID="drpExportFormat" runat="server" Width="120px">
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
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnIssueReport" runat="server" Text="Issue Report" />
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnReceiveReport" runat="server" Text="Receive Report" />
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
            </td>
        </tr>
    </table>
</asp:Content>
