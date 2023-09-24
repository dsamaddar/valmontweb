<%@ Page Language="VB" MasterPageFile="~/Security/Security.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="fromAssignRole.aspx.vb" Inherits="Security_fromAssignRole"
    Title=".:Valmont:Assign Role:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlAssignRole" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Assign Role</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 120px">
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
                                User Name</td>
                            <td>
                            </td>
                            <td>
                                <asp:DropDownList ID="drpUserList" runat="server" Width="200px" 
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnAssignRole" runat="server" Text="Assign Role" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Available Role</td>
                            <td class="label">
                            </td>
                            <td class="label">
                                Assigned Role</td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                <asp:ListBox ID="lstBxAvailableRole" runat="server" Width="250px" 
                                    Height="250px">
                                </asp:ListBox>
                            </td>
                            <td align="center">
                                <asp:Button ID="btnRightAll" runat="server" Text="&gt;&gt;" Width="40px" 
                                    CssClass="styled-button-1" />
                                <br />
                                <br />
                                <asp:Button ID="btnRight" runat="server" Text="&gt;" style="height: 26px" 
                                    Width="40px" CssClass="styled-button-1" />
                                <br />
                                <br />
                                <asp:Button ID="btnLeft" runat="server" Text="&lt;" Width="40px" 
                                    CssClass="styled-button-1" />
                                <br />
                            </td>
                            <td>
                                <asp:ListBox ID="lstBxAssignedRole" runat="server" Height="250px" Width="250px">
                                </asp:ListBox>
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
    </table>
</asp:Content>
