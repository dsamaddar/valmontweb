<%@ Page Language="VB" MasterPageFile="~/Production/Production.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmProductionUnitDefinition.aspx.vb" Inherits="frmProductionUnitDefinition"
    Title=".::Valmont Sweaters:Production Unit Definition::." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlProductionUnitDef" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="5">
                                <div class="widget-title">
                                    Production Unit Definition</div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Production Unit Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtProductionUnit" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                            <td class="label">
                                Normal Rate
                            </td>
                            <td>
                                <asp:TextBox ID="txtRegularRate" runat="server" CssClass="InputTxtBox" Width="80px"></asp:TextBox>
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
                            <td class="label">
                                Overtime Rate
                            </td>
                            <td>
                                <asp:TextBox ID="txtOvertimeRate" runat="server" CssClass="InputTxtBox" Width="80px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Process
                            </td>
                            <td>
                                <asp:DropDownList ID="drpProcessList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Is Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsActive" runat="server" />
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
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnInsert" runat="server" CssClass="styled-button-1" Text="Insert" />
                                &nbsp;<asp:Button ID="btnUpdate" runat="server" CssClass="styled-button-1" Text="Update" />
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldProductionUnitID" runat="server" />
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
                <asp:Panel ID="pnlProdUnitDetailsList" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdProductionUnitDetails" runat="server" CssClass="mGrid" AutoGenerateColumns="False">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="ProductionUnitID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductionUnitID" runat="server" Text='<%# Bind("ProductionUnitID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ProductionUnit">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProductionUnit" runat="server" Text='<%# Bind("ProductionUnit") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="StyleID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyleID" runat="server" Text='<%# Bind("StyleID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Style">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStyle" runat="server" Text='<%# Bind("Style") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ProcessID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProcessID" runat="server" Text='<%# Bind("ProcessID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Process">
                                    <ItemTemplate>
                                        <asp:Label ID="lblProcess" runat="server" Text='<%# Bind("Process") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SizeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSizeID" runat="server" Text='<%# Bind("SizeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Size" HeaderText="Size" />
                                <asp:TemplateField HeaderText="RegularRate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRegularRate" runat="server" Text='<%# Bind("RegularRate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OvertimeRate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOvertimeRate" runat="server" Text='<%# Bind("OvertimeRate") %>'></asp:Label>
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
            </td>
        </tr>
    </table>
</asp:Content>
