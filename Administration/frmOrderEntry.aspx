<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmOrderEntry.aspx.vb" Inherits="Administration_frmOrderEntry"
    Title=".:Valmont:Order Entry:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlOrderEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="5">
                                <div class="widget-title">
                                    Order Entry</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 200px">
                                <asp:HiddenField ID="hdFldOrderID" runat="server" />
                            </td>
                            <td style="width: 150px">
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
                            </td>
                            <td style="width: 150px">
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Buyer
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBuyerList" runat="server" AutoPostBack="True" Width="200px"
                                    CssClass="InputTxtBox">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Style
                            </td>
                            <td>
                                <asp:DropDownList ID="drpStyleInfo" runat="server" Width="200px" CssClass="InputTxtBox">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Order Number
                            </td>
                            <td>
                                <asp:TextBox ID="txtOrderNumber" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldOrderNumber" runat="server" 
                                    ControlToValidate="txtOrderNumber" ErrorMessage="*" ValidationGroup="order"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Order Quantity
                            </td>
                            <td>
                                <asp:TextBox ID="txtOrderQuantity" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldOrderQuantity" runat="server" 
                                    ControlToValidate="txtOrderQuantity" ErrorMessage="*" ValidationGroup="order"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Order Placement Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtOrderDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtOrderDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtOrderDate">
                                </cc1:CalendarExtender>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldOrderPlacementDate" runat="server" 
                                    ControlToValidate="txtOrderDate" ErrorMessage="*" ValidationGroup="order"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Order Delivery Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtDeliverDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtDeliverDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtDeliverDate">
                                </cc1:CalendarExtender>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldOrderDeliveryDate" runat="server" 
                                    ControlToValidate="txtDeliverDate" ErrorMessage="*" ValidationGroup="order"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Order Details
                            </td>
                            <td>
                                <asp:TextBox ID="txtOrderDetails" runat="server" TextMode="MultiLine" Width="200px"
                                    CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldOrderDetails" runat="server" 
                                    ControlToValidate="txtOrderDetails" ErrorMessage="*" ValidationGroup="order"></asp:RequiredFieldValidator>
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
                                <asp:Button ID="btnAddOrder" runat="server" CssClass="styled-button-1" 
                                    Text="ADD/UPDATE" ValidationGroup="order" />
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlOrderList" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdOrderList" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="OrderID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderID" runat="server" Text='<%# Bind("OrderID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BuyerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerID" runat="server" Text='<%# Bind("BuyerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Buyer">
                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Buyer") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="StyleID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleID" runat="server" Text='<%# Bind("StyleID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Style">
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Style") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OrderNumber">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderNumber" runat="server" Text='<%# Bind("OrderNumber") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OrderQuantity">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderQuantity" runat="server" Text='<%# Bind("OrderQuantity") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OrderDate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderDate" runat="server" Text='<%# Bind("OrderDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DeliveryDate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDeliveryDate" runat="server" Text='<%# Bind("DeliveryDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OrderDetails">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderDetails" runat="server" Text='<%# Bind("OrderDetails") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EntryBy">
                                    <ItemTemplate>
                                        <asp:Label ID="Label10" runat="server" Text='<%# Bind("EntryBy") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EntryDate">
                                    <ItemTemplate>
                                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("EntryDate") %>'></asp:Label>
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
