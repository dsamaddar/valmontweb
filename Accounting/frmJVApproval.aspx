<%@ Page Language="VB" MasterPageFile="~/Accounting/Accounting.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmJVApproval.aspx.vb" Inherits="Accounting_frmJVApproval"
    Title=".:Valmont:JV Approval:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlJVApproval" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td class="widget-title">
                                Pending Transactions
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <asp:GridView ID="grdPendingTransactions" runat="server" AutoGenerateColumns="False"
                                        CssClass="mGrid">
                                        <Columns>
                                            <asp:CommandField ShowSelectButton="True" />
                                            <asp:TemplateField HeaderText="VoucherID" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblVoucherID" runat="server" Text='<%# Bind("VoucherID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="VoucherNo">
                                                <ItemTemplate>
                                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("VoucherNo") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="TransactionDate">
                                                <ItemTemplate>
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("TransactionDate") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Narration">
                                                <ItemTemplate>
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Narration") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="pnlAction" runat="server" SkinID="pnlInner" >
                                    <table style="width: 100%;">
                                        <tr>
                                            <td style="width: 33.33%">
                                            </td>
                                            <td style="width: 33.33%">
                                            </td>
                                            <td style="width: 33.33%">
                                                <asp:RequiredFieldValidator ID="reqFldNarration" runat="server" 
                                                    ControlToValidate="txtNarration" ErrorMessage="Required : Narration" 
                                                    ValidationGroup="RejectJV"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td>
                                                <asp:Button ID="btnApprove" runat="server" CssClass="styled-button-1" Text="Approve" />
                                                &nbsp;<asp:Button ID="btnReject" runat="server" CssClass="styled-button-1" 
                                                    Text="Reject" ValidationGroup="RejectJV" />
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtNarration" runat="server" CssClass="InputTxtBox" 
                                                    Height="50px" TextMode="MultiLine" Width="200px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                &nbsp;</td>
                                            <td>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlTransactionDetails" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td class="widget-title">
                                Transaction Details
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <asp:GridView ID="grdTransactionDetails" runat="server" AutoGenerateColumns="False"
                                        CssClass="mGrid">
                                        <Columns>
                                            <asp:BoundField DataField="EntryNo" HeaderText="EntryNo" />
                                            <asp:BoundField DataField="LedgerName" HeaderText="Ledger" />
                                            <asp:BoundField DataField="TransactionType" HeaderText="Type" />
                                            <asp:BoundField DataField="Debit" HeaderText="Debit" />
                                            <asp:BoundField DataField="Credit" HeaderText="Credit" />
                                            <asp:BoundField DataField="Reference" HeaderText="Reference" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                        <tr>
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
