<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    CodeFile="frmSalaryReversal.aspx.vb" Inherits="Administration_frmSalaryReversal"
    Theme="CommonSkin" Title=".:ValmontWEB:Reverse Salary:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/javascript">    
   function ConfirmOnDelete() {
    if (confirm("Do you really want to delete?") == true)
        return true;
    else
        return false;
   }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlSalReversal" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="3">
                                <div class="widget-title">
                                    Salary Reversal
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Salary Year
                            </td>
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Salary Month
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSalaryMonth" runat="server" AutoPostBack="True" Width="80px">
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
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Entry Point
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEntryPoint" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
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
                            </td>
                            <td>
                                <asp:Button ID="btnReverseSalary" runat="server" CssClass="styled-button-1" Text="Reverse Salary" OnClientClick="return ConfirmOnDelete();" />
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
