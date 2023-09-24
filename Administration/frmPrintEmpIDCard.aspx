<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmPrintEmpIDCard.aspx.vb" Inherits="frmPrintEmpIDCard"
    Title=".:Valmont:Print ID Card:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
                <asp:Panel ID="pnlEmpIDCard" runat="server" Width="70%" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="5">
                                <div class="widget-title">
                                    Print Employee ID Card</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
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
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Starting Card No
                            </td>
                            <td>
                                <asp:TextBox ID="txtStartingCardNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td class="label">
                                Ending Card No
                            </td>
                            <td>
                                <asp:TextBox ID="txtEndingCardNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Format
                            </td>
                            <td>
                                <asp:DropDownList ID="drpReportFormat" runat="server">
                                    <asp:ListItem Text="Bangla" Value="Bangla"></asp:ListItem>
                                    <asp:ListItem Text="English" Value="English"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnPrintIDCard" runat="server" CssClass="styled-button-1" Text="Print ID Card" />
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
            </td>
        </tr>
    </table>
</asp:Content>
