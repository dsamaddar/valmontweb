<%@ Page Language="VB" MasterPageFile="~/Accounting/Accounting.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmJVEntry.aspx.vb" Inherits="Accounting_frmJVEntry"
    Title=".:Valmont:JV Entry:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlJVEntry" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="5">
                                <div class="widget-title">
                                    Journal Voucher Entry<asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldTransactionDate" runat="server" ControlToValidate="txtVoucherDate"
                                    ErrorMessage="Required: Transaction Date" ValidationGroup="JV"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldVoucherNo" runat="server" ControlToValidate="txtVoucherNo"
                                    ErrorMessage="Required: Voucher No" ValidationGroup="JV"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Transaction Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtVoucherDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtDateFrom_txtVoucherDate" runat="server" CssClass="MyCalendarCss"
                                    Enabled="True" TargetControlID="txtVoucherDate">
                                </cc1:CalendarExtender>
                            </td>
                            <td class="label">
                                Voucher No
                            </td>
                            <td>
                                <asp:TextBox ID="txtVoucherNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Narration
                            </td>
                            <td>
                                <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" Width="200px"
                                    CssClass="InputTxtBox" Height="50px"></asp:TextBox>
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
                                Ledger Head
                            </td>
                            <td>
                                <asp:DropDownList ID="drpLedger" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Amount
                            </td>
                            <td style="margin-left: 40px">
                                <asp:TextBox ID="txtAmount" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Transaction Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpTransactionType" runat="server" CssClass="InputTxtBox">
                                    <asp:ListItem Value="D">Debit</asp:ListItem>
                                    <asp:ListItem Value="C">Credit</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Reference
                            </td>
                            <td style="margin-left: 40px">
                                <asp:TextBox ID="txtReference" runat="server" CssClass="InputTxtBox">.</asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                            </td>
                            <td>
                                <asp:Button ID="btnAddTransaction" runat="server" Text="ADD" CssClass="styled-button-1" />
                            </td>
                            <td>
                                <asp:Button ID="btnSubmit" runat="server" CssClass="styled-button-1" 
                                    Text="Submit JV" ValidationGroup="JV" />
                            </td>
                            <td style="margin-left: 40px">
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlVoucherDetails" runat="server" SkinID="pnlInner">
                    <div>
                        <asp:GridView ID="grdJVDetails" runat="server" CssClass="mGrid" AutoGenerateColumns="False"
                            ShowFooter="True">
                            <Columns>
                                <asp:TemplateField HeaderText="LedgerID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLedgerID" runat="server" Text='<%# Bind("LedgerID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="LedgerName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblLedgerName" runat="server" Text='<%# Bind("LedgerName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Type" Visible="True">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionType" runat="server" Text='<%# Bind("TransactionType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Debit">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDebit" runat="server" Text='<%# Bind("Debit","{0:N2}") %>' DataFormatString="{0:N2}"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Credit">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCredit" runat="server" Text='<%# Bind("Credit","{0:N2}") %>' DataFormatString="{0:N2}"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reference">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReference" runat="server" Text='<%# Bind("Reference") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ReferenceType" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReferenceType" runat="server" Text='<%# Bind("ReferenceType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgbtnDelete" Height="20px" ImageUrl="~/Sources/img/erase.png"
                                            OnClientClick="if (!confirm('Are you Sure to Delete The Requisition ?')) return false"
                                            CommandName="Delete" runat="server" />
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
                <asp:Panel ID="pnlJVSubmission" runat="server" SkinID="">
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>
