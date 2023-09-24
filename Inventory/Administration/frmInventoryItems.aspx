<%@ Page Language="VB" Theme="CommonSkin" MasterPageFile="~/Inventory/AIMaster.master"
    AutoEventWireup="false" CodeFile="frmInventoryItems.aspx.vb" Inherits="Administration_frmInventoryItems"
    Title=".:Valmont Sweaters:Item Definition:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
                <asp:Panel ID="pnlItemInput" runat="server" Width="100%" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="6">
                                <div class="widgettitle">
                                    .: Item Definition :.</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 230px">
                                <asp:HiddenField ID="hdFldItemID" runat="server" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Buyer
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBuyer" runat="server" CssClass="InputTxtBox" Width="200px"
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <td class="label">
                                Style No
                            </td>
                            <td>
                                <asp:DropDownList ID="drpStyleNo" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Color
                            </td>
                            <td>
                                <asp:DropDownList ID="drpColor" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldItemCode" runat="server" ControlToValidate="txtItemCode"
                                    Display="None" ErrorMessage="Item Code Required" ValidationGroup="ItemInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldItemCode_ValidatorCalloutExtender" runat="server"
                                    CloseImageUrl="~/Sources/img/valClose.png" CssClass="customCalloutStyle" Enabled="True"
                                    TargetControlID="reqFldItemCode" WarningIconImageUrl="~/Sources/img/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Parent Item
                            </td>
                            <td>
                                <asp:DropDownList ID="drpInventoryItems" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
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
                            </td>
                            <td class="label">
                                Item Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtItemName" runat="server" CssClass="InputTxtBox" Width="200px"
                                    AutoPostBack="True"></asp:TextBox>
                                &nbsp;
                            </td>
                            <td>
                                <asp:ImageButton ID="imgBtnGenItemName" runat="server" Height="25px" ImageUrl="~/Sources/img/check.png" />
                            </td>
                            <td class="label">
                                Item Code
                            </td>
                            <td>
                                <asp:TextBox ID="txtItemCode" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Unit Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpUnitType" runat="server" Width="200px" CssClass="InputTxtBox">
                                </asp:DropDownList>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldMaxRequisition" runat="server" ControlToValidate="txtMaxRequisition"
                                    Display="None" ErrorMessage="Max Allowable Requisition Required" ValidationGroup="ItemInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldMaxRequisition_ValidatorCalloutExtender"
                                    runat="server" CloseImageUrl="~/Sources/img/valClose.png" CssClass="customCalloutStyle"
                                    Enabled="True" TargetControlID="reqFldMaxRequisition" WarningIconImageUrl="~/Sources/img/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Low Balance Report
                            </td>
                            <td>
                                <asp:TextBox ID="txtLowBalanceReport" runat="server" CssClass="InputTxtBox" Width="120px"></asp:TextBox>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:TextBox ID="txtMaxRequisition" runat="server" CssClass="InputTxtBox" Visible="False"
                                    Width="120px">10000</asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkItemIsActive" runat="server" CssClass="chkText" Text="Is Active" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldItemName" runat="server" ControlToValidate="txtItemName"
                                    Display="None" ErrorMessage="Item Name Required" ValidationGroup="ItemInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldItemName_ValidatorCalloutExtender" runat="server"
                                    CloseImageUrl="~/Sources/img/valClose.png" CssClass="customCalloutStyle" Enabled="True"
                                    TargetControlID="reqFldItemName" WarningIconImageUrl="~/Sources/img/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnAddItem" runat="server" CssClass="styled-button-1" Text="ADD Item"
                                    ValidationGroup="ItemInput" />
                                <asp:Button ID="btnUpdateInventoryItems" runat="server" CssClass="styled-button-1"
                                    Text="Update" />
                                <asp:Button ID="btnCancelInputItemType" runat="server" CssClass="styled-button-1"
                                    Text="Cancel" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldUnitTypeItemInput" runat="server" ControlToValidate="drpUnitType"
                                    Display="None" ErrorMessage="Unit Type Required" ValidationGroup="ItemInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldUnitTypeItemInput_ValidatorCalloutExtender"
                                    runat="server" CloseImageUrl="~/Sources/img/valClose.png" CssClass="customCalloutStyle"
                                    Enabled="True" TargetControlID="reqFldUnitTypeItemInput" WarningIconImageUrl="~/Sources/img/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
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
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldLowBalanceReport" runat="server" ControlToValidate="txtLowBalanceReport"
                                    Display="None" ErrorMessage="Low Balance Report Required" ValidationGroup="ItemInput"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldLowBalanceReport_ValidatorCalloutExtender"
                                    runat="server" CloseImageUrl="~/Sources/img/valClose.png" CssClass="customCalloutStyle"
                                    Enabled="True" TargetControlID="reqFldLowBalanceReport" WarningIconImageUrl="~/Sources/img/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td>
                <asp:Panel ID="pnlAvailableInventoryItems" runat="server" SkinID="pnlInner">
                    <div style="max-height: 250px; max-width: 100%; overflow: auto">
                        <asp:GridView ID="grdAvailableItems" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            CssClass="mGrid" ForeColor="#333333" GridLines="None" Width="100%">
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <Columns>
                                <asp:TemplateField HeaderText="Select" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                            Text="Select"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ItemID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Bind("ItemID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemName" runat="server" Text='<%# Bind("ItemName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemCode" runat="server" Text='<%# Bind("ItemCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UnitTypeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnitTypeID" runat="server" Text='<%# Bind("UnitTypeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit">
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("UnitType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Low Balance">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLowBalanceReport" runat="server" Text='<%# Bind("LowBalanceReport") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Max Requisition" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMaxAllowableRequisition" runat="server" Text='<%# Bind("MaxAllowableRequisition") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Active">
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
                                        <asp:Label ID="Label10" runat="server" Text='<%# Bind("EntryDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="BuyerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyerID" runat="server" Text='<%# Bind("BuyerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="StyleID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleID" runat="server" Text='<%# Bind("StyleID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ColorID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblColorID" runat="server" Text='<%# Bind("ColorID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ParentItemID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblParentItemID" runat="server" Text='<%# Bind("ParentItemID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <EditRowStyle BackColor="#999999" />
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
