<%@ Page Language="VB" MasterPageFile="~/Security/Security.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmDefineMenu.aspx.vb" Inherits="Security_frmDefineMenu"
    Title=".:Vamont:Menu Definition:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    &nbsp;<table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlDefineMenu" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="5">
                                <div class="widget-title">
                                    Menu Definition</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldMenuID" runat="server" />
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
                                Menu Value
                            </td>
                            <td>
                                <asp:TextBox ID="txtMenuValue" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td class="label">
                                Menu Order
                            </td>
                            <td>
                                <asp:TextBox ID="txtMenuOrder" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Menu Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtMenuName" runat="server"></asp:TextBox>
                            </td>
                            <td class="label">
                                Menu Hyperlink
                            </td>
                            <td>
                                <asp:TextBox ID="txtMenuHyperLink" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Parent Menu
                            </td>
                            <td>
                                <asp:DropDownList ID="drpParentMenu" runat="server">
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
                                <asp:Button ID="btnInsert" runat="server" Text="Insert" 
                                    CssClass="styled-button-1" />
                                &nbsp;<asp:Button ID="btnUpdate" runat="server" Text="Update" 
                                    CssClass="styled-button-1" />
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
            <td align="left">
                <asp:Panel ID="pnlMenuView" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:TreeView ID="trvwMenu" runat="server" ImageSet="XPFileExplorer" BorderStyle="Groove"
                            ExpandDepth="0" NodeIndent="15" ShowLines="True">
                            <ParentNodeStyle Font-Bold="False" />
                            <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                            <SelectedNodeStyle Font-Underline="False" HorizontalPadding="0px" 
                                VerticalPadding="0px" BackColor="#B5B5B5" />
                            <RootNodeStyle BorderStyle="None" />
                            <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
                                NodeSpacing="0px" VerticalPadding="2px" BorderStyle="None" />
                        </asp:TreeView>
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
