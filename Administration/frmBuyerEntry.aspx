<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmBuyerEntry.aspx.vb" Inherits="Administration_frmBuyerEntry"
    Title=".:Valmont:Buyer Entry:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td style="margin-left: 40px">
                <asp:Panel ID="pnlBuyerEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="6">
                                <div class="widget-title">
                                    Buyer Entry
                                </div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 120px">
                            </td>
                            <td style="width: 150px">
                                <asp:HiddenField ID="hdFldBuyerID" runat="server" />
                            </td>
                            <td style="width: 120px">
                                &nbsp;
                            </td>
                            <td style="width: 120px">
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Buyer Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtBuyerName" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td>
                                &nbsp;
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
                                Country
                            </td>
                            <td>
                                <asp:DropDownList ID="drpCountry" runat="server" CssClass="InputTxtBox" Width="150px">
                                    <asp:ListItem>Chaina</asp:ListItem>
                                    <asp:ListItem>France</asp:ListItem>
                                    <asp:ListItem>Germany</asp:ListItem>
                                    <asp:ListItem>Italy</asp:ListItem>
                                    <asp:ListItem>Japan</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                &nbsp;
                            </td>
                            <td class="label">
                                Address
                            </td>
                            <td>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="InputTxtBox" TextMode="MultiLine"
                                    Width="200px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Contact Person
                            </td>
                            <td>
                                <asp:TextBox ID="txtContactPerson" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td class="label">
                                &nbsp;
                            </td>
                            <td class="label">
                                Contact No
                            </td>
                            <td>
                                <asp:TextBox ID="txtContactNo" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                E-Mail Address
                            </td>
                            <td>
                                <asp:TextBox ID="txtEmailAddress" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                            <td class="label">
                                &nbsp;
                            </td>
                            <td class="label">
                                Fax
                            </td>
                            <td>
                                <asp:TextBox ID="txtFax" runat="server" CssClass="InputTxtBox" Width="150px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Merchandizer
                            </td>
                            <td>
                                <asp:DropDownList ID="drpMerchandizer" runat="server" CssClass="InputTxtBox" Width="150px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                &nbsp;
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
                                <asp:Button ID="btnAddBuyer" runat="server" Text="Add Buyer" CssClass="styled-button-1" />
                            </td>
                            <td>
                                &nbsp;
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
                <asp:Panel ID="pnlBuyerList" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdBuyerList" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="BuyerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerID" runat="server" Text='<%# Bind("BuyerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BuyerName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerName" runat="server" Text='<%# Bind("BuyerName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Country">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCountry" runat="server" Text='<%# Bind("Country") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Address">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerAddress" runat="server" Text='<%# Bind("BuyerAddress") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ContactPerson">
                                    <ItemTemplate>
                                        <asp:Label ID="lblContactPerson" runat="server" Text='<%# Bind("ContactPerson") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ContactNo">
                                    <ItemTemplate>
                                        <asp:Label ID="lblContactNo" runat="server" Text='<%# Bind("ContactNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmailAddress">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmailAddress" runat="server" Text='<%# Bind("EmailAddress") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Fax">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFax" runat="server" Text='<%# Bind("Fax") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MerchandizerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMerchandizerID" runat="server" Text='<%# Bind("MerchandizerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Merchandizer">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMerchandizer" runat="server" Text='<%# Bind("Merchandizer") %>'></asp:Label>
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
