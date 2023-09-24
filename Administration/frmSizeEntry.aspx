<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmSizeEntry.aspx.vb" Inherits="Administration_frmSizeEntry"
    Title=".: Valmont: Size Entry :." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlSizeEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Size Entry
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldSizeID" runat="server" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Size Name</td>
                            <td>
                                <asp:TextBox ID="txtSize" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldSize" runat="server" ControlToValidate="txtSize"
                                    ErrorMessage="Required: Size Name" ValidationGroup="Size"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Is Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" />
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
                                <asp:Button ID="btnInsertSize" runat="server" CssClass="styled-button-1" 
                                    Text="Insert" ValidationGroup="Size" />
                                &nbsp;<asp:Button ID="btnUpdateSize" runat="server" CssClass="styled-button-1" 
                                    Text="Update" ValidationGroup="Size" />
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
                <asp:Panel ID="pnlSizeList" runat="server" SkinID="pnlInner">
                    <div style="max-height: 300px; max-width: 100%; overflow: auto">
                        <asp:GridView ID="grdSizeList" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="SizeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSizeID" runat="server" Text='<%# Bind("SizeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Size">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSize" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IsActive">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsActive" runat="server" Text='<%# Bind("IsActive") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EntryBy">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEntryBy" runat="server" Text='<%# Bind("EntryBy") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
