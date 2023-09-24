<%@ Page Language="VB" MasterPageFile="~/Production/Production.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmMaterialReceive.aspx.vb" Inherits="Production_frmMaterialReceive"
    Title=".:Valmont:Receive Material:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlReceiveMaterial" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <div class="widget-title">
                                    Receive Material</div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="height: 300px; width: 100%; overflow: auto">
                                    <asp:GridView ID="grdMaterialIssueList" runat="server" AutoGenerateColumns="False"
                                        CssClass="mGrid">
                                        <Columns>
                                            <asp:CommandField ShowSelectButton="True" />
                                            <asp:TemplateField HeaderText="MaterialDistID" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMaterialDistID" runat="server" Text='<%# Bind("MaterialDistID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="DistNumber" HeaderText="DistNumber" />
                                            <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
                                            <asp:BoundField DataField="BuyerName" HeaderText="Buyer" />
                                            <asp:BoundField DataField="OrderNumber" HeaderText="Order" />
                                            <asp:BoundField DataField="Style" HeaderText="Style" />
                                            <asp:BoundField DataField="Size" HeaderText="Size" />
                                            <asp:BoundField DataField="ColorName" HeaderText="Color" />
                                            <asp:BoundField DataField="ComponentName" HeaderText="Component" />
                                            <asp:BoundField DataField="Rate" HeaderText="Rate" />
                                            <asp:TemplateField HeaderText="I.Qty">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblIssueQuantity" runat="server" Text='<%# Bind("IssueQuantity") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="IssueRemarks" HeaderText="I.Remarks" />
                                            <asp:BoundField DataField="IssueBy" HeaderText="I.By" />
                                            <asp:BoundField DataField="IssueDate" HeaderText="I.Date" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlReceiveStat" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldMaterialDistID" runat="server" />
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
                            <td class="label">
                                Receive Quantity
                            </td>
                            <td>
                                <asp:TextBox ID="txtReceiveQuantity" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldRecQty" runat="server" ControlToValidate="txtReceiveQuantity"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Receive Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtReceiveDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtReceiveDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtReceiveDate">
                                </cc1:CalendarExtender>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldRecDate" runat="server" ControlToValidate="txtReceiveDate"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Receive Remarks
                            </td>
                            <td>
                                <asp:TextBox ID="txtReceiveRemarks" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldRecRemarks" runat="server" ControlToValidate="txtReceiveRemarks"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
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
                                <asp:Button ID="btnReceive" runat="server" CssClass="styled-button-1" Text="Receive"
                                    ValidationGroup="material" />
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
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
