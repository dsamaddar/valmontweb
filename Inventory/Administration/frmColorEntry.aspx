<%@ Page Language="VB" MasterPageFile="~/Inventory/AIMaster.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmColorEntry.aspx.vb" Inherits="Inventory_Administration_frmColorEntry"
    Title=".:Valmont:Color Entry:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlColorEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="4">
                                <div class="widget-title">
                                    Color Entry</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldColorID" runat="server" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Color Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtColorName" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldColorName" runat="server" ControlToValidate="txtColorName"
                                    ErrorMessage="Required : Color Name" ValidationGroup="AddColor"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" CssClass="chkText" Text="YES" />
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
                                <asp:Button ID="btnAddColor" runat="server" CssClass="styled-button-1" Text="Add Color"
                                    ValidationGroup="AddColor" />
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
                <asp:Panel ID="pnlColors" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdColors" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="ColorID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblColorID" runat="server" Text='<%# Bind("ColorID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Color">
                                    <ItemTemplate>
                                        <asp:Label ID="lblColorName" runat="server" Text='<%# Bind("ColorName") %>'></asp:Label>
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
                                <asp:TemplateField HeaderText="EntryDate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEntryDate" runat="server" Text='<%# Bind("EntryDate") %>'></asp:Label>
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
            </td>
        </tr>
    </table>
</asp:Content>
