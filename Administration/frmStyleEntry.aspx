<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmStyleEntry.aspx.vb" Inherits="Administration_frmStyleEntry"
    Title=".:Valmont:Style Entry:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlStyleEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="5">
                                <div class="widget-title">
                                    Style Entry</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldStyleID" runat="server" />
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
                                Buyer
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBuyerList" runat="server" Width="200px" 
                                    AutoPostBack="True">
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
                            <td class="label">
                                Style No
                            </td>
                            <td>
                                <asp:TextBox ID="txtStyleNo" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td class="label">
                                Style Code
                            </td>
                            <td>
                                <asp:TextBox ID="txtStyleCode" runat="server" Width="150px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Style Description
                            </td>
                            <td>
                                <asp:TextBox ID="txtStyleDescription" runat="server" TextMode="MultiLine" Width="200px"></asp:TextBox>
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
                                Is Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" CssClass="chkText" Text="YES" />
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
                                <asp:Button ID="btnStyleEntry" runat="server" CssClass="styled-button-1" Text="ADD" />
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
                <asp:Panel ID="pnlStyleList" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdStyleInfo" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="StyleID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleID" runat="server" Text='<%# Bind("StyleID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BuyerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerID" runat="server" Text='<%# Bind("BuyerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Buyer">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Buyer") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Style">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyle" runat="server" Text='<%# Bind("Style") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCode" runat="server" Text='<%# Bind("Code") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Description">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleDescription" runat="server" Text='<%# Bind("StyleDescription") %>'></asp:Label>
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
                                <asp:BoundField DataField="EntryDate" HeaderText="EntryDate" />
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
