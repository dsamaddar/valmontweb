<%@ Page Language="VB" Theme="CommonSkin" MasterPageFile="~/Inventory/AIMaster.master"
    AutoEventWireup="false" CodeFile="frmItemUnitDefinition.aspx.vb" Inherits="Administration_frmItemUnitDefinition"
    Title=".:Valmont Sweaters:Unit Type Definition:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
                <asp:Panel ID="pnlUnitType" runat="server" Width="100%" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="4">
                                <div class="widgettitle">
                                    .: Unit Definition :.<asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                                &nbsp;
                            </td>
                            <td style="width: 150px">
                                &nbsp;
                            </td>
                            <td style="width: 230px">
                                <asp:HiddenField ID="hdFldUnitTypeID" runat="server" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Unit Type
                            </td>
                            <td>
                                <asp:TextBox ID="txtUnitType" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldUnitType" runat="server" ControlToValidate="txtUnitType"
                                    Display="None" ErrorMessage="Unit Type Required" ValidationGroup="UnitTypeInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldUnitType_ValidatorCalloutExtender0" runat="server"
                                    Enabled="True" TargetControlID="reqFldUnitType" CssClass="customCalloutStyle"
                                    CloseImageUrl="~/Sources/images/valClose.png" WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkUnitTypeIsActive" runat="server" CssClass="chkText" Text="Is Active" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnAddUnitType" runat="server" Text="ADD" CssClass="styled-button-1"
                                    ValidationGroup="UnitTypeInput" />
                                &nbsp;<asp:Button ID="btnUpdateUnitType" runat="server" CssClass="styled-button-1"
                                    Text="Update" />
                                &nbsp;<asp:Button ID="btnCancelAddUnitType" runat="server" Text="Cancel" CssClass="styled-button-1" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td colspan="3" align="center">
                                <div style="max-height: 200px; overflow: auto">
                                    <asp:GridView ID="grdAvailableUnitType" runat="server" AutoGenerateColumns="False"
                                        CellPadding="4" ForeColor="#333333" GridLines="None" Width="100%" CssClass="mGrid">
                                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Select" ShowHeader="False">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                        Text="Select"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="UnitTypeID" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblUnitTypeID" runat="server" Text='<%# Bind("UnitTypeID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Unit">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblUnitType" runat="server" Text='<%# Bind("UnitType") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Is Active">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblIsActive" runat="server" Text='<%# Bind("IsActive") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Entry By">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEntryBy" runat="server" Text='<%# Bind("EntryBy") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="EntryDate" HeaderText="Entry Date" />
                                        </Columns>
                                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                        <EditRowStyle BackColor="#999999" />
                                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
