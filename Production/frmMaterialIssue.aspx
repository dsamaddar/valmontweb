<%@ Page Language="VB" MasterPageFile="~/Production/Production.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmMaterialIssue.aspx.vb" Inherits="Production_frmMaterialIssue"
    Title=".:Valmont:Material Issue:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlRateSetup" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="7">
                                <div class="widget-title">
                                    Material Issue</div>
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
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Select Employee
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEmpList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldEmpList" runat="server" ControlToValidate="drpEmpList"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
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
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
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
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Style
                            </td>
                            <td>
                                <asp:DropDownList ID="drpStyleList" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                                &nbsp;
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldStyleList" runat="server" ControlToValidate="drpStyleList"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
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
                            <td>
                            </td>
                            <td>
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
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
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
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
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
                                Issue Quantity (lbs)
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssueQuantity" runat="server" CssClass="InputTxtBox" AutoPostBack="True"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldIssueQuantity" runat="server" ControlToValidate="txtIssueQuantity"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Issue Quantity(pcs)
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssuePiece" runat="server" AutoPostBack="True" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldIssuePiece" runat="server" 
                                    ControlToValidate="txtIssuePiece" ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Issue Remarks
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssueRemarks" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldIssueRemarks" runat="server" ControlToValidate="txtIssueRemarks"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                            <td class="label">
                                Issue Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtIssueDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtIssueDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtIssueDate">
                                </cc1:CalendarExtender>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldIssueDate" runat="server" ControlToValidate="txtIssueDate"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnIssueMaterial" runat="server" CssClass="styled-button-1" Text="Issue Material"
                                    ValidationGroup="material" />
                            </td>
                            <td>
                            </td>
                            <td class="label">
                                Rate /p
                            </td>
                            <td>
                                <asp:TextBox ID="txtRate" runat="server" CssClass="InputTxtBox" Enabled="False" 
                                    Visible="False"></asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldRate" runat="server" ControlToValidate="txtRate"
                                    ErrorMessage="*" ValidationGroup="material"></asp:RequiredFieldValidator>
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
                            <td class="label">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
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
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlMaterialIssueList" runat="server" SkinID="pnlInner">
                    <div style="height:200px;width:100%;overflow:auto">
                        <asp:GridView ID="grdMaterialIssueList" runat="server" CssClass="mGrid" AutoGenerateColumns="False">
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
                                <asp:BoundField DataField="IssueQuantity" HeaderText="I.Qty" />
                                <asp:BoundField DataField="IssueRemarks" HeaderText="I.Remarks" />
                                <asp:BoundField DataField="IssueBy" HeaderText="I.By" />
                                <asp:BoundField DataField="IssueDate" HeaderText="I.Date" />
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
