<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmRateSetup.aspx.vb" Inherits="Administration_frmRateSetup"
    Title=".:Valmont:Rate Setup:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlRateSetup" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Rate Setup</div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldRateSetupID" runat="server" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Buyer
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBuyerList" runat="server" AutoPostBack="True" CssClass="InputTxtBox"
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldBuyerID" runat="server" ControlToValidate="drpBuyerList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Order
                            </td>
                            <td>
                                <asp:DropDownList ID="drpOrderList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldOrderList" runat="server" ControlToValidate="drpOrderList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Style
                            </td>
                            <td>
                                <asp:DropDownList ID="drpStyleList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldStyleList" runat="server" ControlToValidate="drpStyleList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Size
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSizeList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldSizeList" runat="server" ControlToValidate="drpSizeList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Color
                            </td>
                            <td>
                                <asp:DropDownList ID="drpColorList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldColorList" runat="server" ControlToValidate="drpColorList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Component
                            </td>
                            <td>
                                <asp:DropDownList ID="drpComponentList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldComponentList" runat="server" ControlToValidate="drpComponentList"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Rate /p
                            </td>
                            <td>
                                <asp:TextBox ID="txtRate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                &nbsp;
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldRate" runat="server" ControlToValidate="txtRate"
                                    ErrorMessage="*" ValidationGroup="rate_setup"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button ID="btnAdd" runat="server" CssClass="styled-button-1" Text="Add / Update"
                                    ValidationGroup="rate_setup" />
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
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlRateSetupList" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdRateSetupList" runat="server" CssClass="mGrid" AutoGenerateColumns="False">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="RateSetupID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRateSetupID" runat="server" Text='<%# Bind("RateSetupID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BuyerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerID" runat="server" Text='<%# Bind("BuyerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="BuyerName" HeaderText="Buyer" />
                                <asp:TemplateField HeaderText="OrderID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderID" runat="server" Text='<%# Bind("OrderID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="OrderNumber" HeaderText="Order#" />
                                <asp:TemplateField HeaderText="StyleID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleID" runat="server" Text='<%# Bind("StyleID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Style" HeaderText="Style" />
                                <asp:TemplateField HeaderText="SizeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSizeID" runat="server" Text='<%# Bind("SizeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Size" HeaderText="Size" />
                                <asp:TemplateField HeaderText="ColorID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblColorID" runat="server" Text='<%# Bind("ColorID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ColorName" HeaderText="Color" />
                                <asp:TemplateField HeaderText="ComponentID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblComponentID" runat="server" Text='<%# Bind("ComponentID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ComponentName" HeaderText="Component" />
                                <asp:TemplateField HeaderText="Rate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRate" runat="server" Text='<%# Bind("Rate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="EntryBy" HeaderText="EntryBy" />
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
