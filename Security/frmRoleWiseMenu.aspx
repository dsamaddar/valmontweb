<%@ Page Language="VB" MasterPageFile="~/Security/Security.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmRoleWiseMenu.aspx.vb" Inherits="Security_frmRoleWiseMenu"
    Title=".:Valmont:Role Wise Menu:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlRole" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="3">
                                <div class="widget-title">
                                    Role Wise Menu</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldRoleID" runat="server" />
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Available Role</td>
                            <td>
                                <asp:DropDownList ID="drpRoleList" runat="server" CssClass="InputTxtBox" 
                                    Width="200px" AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Role Name</td>
                            <td>
                                <asp:TextBox ID="txtRoleName" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Active</td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" Text="YES" CssClass="chkText" 
                                    Checked="True" />
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnAdd" runat="server" Text="ADD" CssClass="styled-button-1" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TreeView ID="trvwMenu" runat="server" ImageSet="XPFileExplorer" NodeIndent="15"
                    ShowCheckBoxes="All" ExpandDepth="0">
                    <ParentNodeStyle Font-Bold="False" />
                    <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                    <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
                        VerticalPadding="0px" />
                    <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
                        NodeSpacing="0px" VerticalPadding="2px" />
                </asp:TreeView>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
