<%@ Page Language="VB" Theme="CommonSkin" MasterPageFile="~/Accounting/Accounting.master"
    AutoEventWireup="false" CodeFile="frmChartOfAccounts.aspx.vb" Inherits="Accounting_frmChartOfAccounts"
    Title=".:Chart Of Accounts:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
            </td>
            <td>
                <asp:Panel ID="pnlDefineLedgerType" runat="server" Width="800px" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="4">
                                <div class="widgettitle">
                                    Ledger Type Definition<asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                                &nbsp;
                            </td>
                            <td class="label" style="width: 250px">
                                Available Ledger Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpAvailableLedgerType" runat="server" CssClass="InputTxtBox"
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td class="label">
                                Ledger Type
                            </td>
                            <td>
                                <asp:TextBox ID="txtLedgerType" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldLedgerType" runat="server" ControlToValidate="txtLedgerType"
                                    Display="None" ErrorMessage="Required: Ledger Type" ValidationGroup="LedgerType"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                        ID="reqFldLedgerType_ValidatorCalloutExtender" runat="server" CloseImageUrl="~/Sources/images/valClose.png"
                                        CssClass="customCalloutStyle" Enabled="True" TargetControlID="reqFldLedgerType"
                                        WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                    </cc1:ValidatorCalloutExtender>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                                &nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnInsertLedgerType" runat="server" Text="Insert" CssClass="styled-button-1"
                                    ValidationGroup="LedgerType" />
                                &nbsp;<asp:Button ID="btnCancelLedgerType" runat="server" Text="Cancel" CssClass="styled-button-1" />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
            <td>
            </td>
        </tr>
        <tr align="center">
            <td>
            </td>
            <td>
                <asp:Panel ID="pnlCOADefinition" runat="server" Width="800px" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="4">
                                <div class="widgettitle">
                                    Define Chart Of Accounts</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 250px">
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
                                Select Ledger Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSelectLedgerType" runat="server" CssClass="InputTxtBox"
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Ledger Name
                            </td>
                            <td>
                                <asp:TextBox ID="txtLedgerName" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldLedgerName" runat="server" ControlToValidate="txtLedgerName"
                                    Display="None" ErrorMessage="Required: Ledger Name" ValidationGroup="LedgerName"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                        ID="reqFldLedgerName_ValidatorCalloutExtender" runat="server" CloseImageUrl="~/Sources/images/valClose.png"
                                        CssClass="customCalloutStyle" Enabled="True" TargetControlID="reqFldLedgerName"
                                        WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                    </cc1:ValidatorCalloutExtender>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Parent Ledger
                            </td>
                            <td>
                                <asp:DropDownList ID="drpParentLedger" runat="server" CssClass="InputTxtBox" Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Ledger Code
                            </td>
                            <td>
                                <asp:TextBox ID="txtLedgerCode" runat="server" CssClass="InputTxtBox" Width="100px"></asp:TextBox>
                                &nbsp;<asp:RequiredFieldValidator ID="reqFldLedgerCode" runat="server" ControlToValidate="txtLedgerCode"
                                    Display="None" ErrorMessage="Required: Ledger Code" ValidationGroup="LedgerName"></asp:RequiredFieldValidator><cc1:ValidatorCalloutExtender
                                        ID="reqFldLedgerCode_ValidatorCalloutExtender" runat="server" CloseImageUrl="~/Sources/images/valClose.png"
                                        CssClass="customCalloutStyle" Enabled="True" TargetControlID="reqFldLedgerCode"
                                        WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                    </cc1:ValidatorCalloutExtender>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Is Bank Account
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsBankAccount" runat="server" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Balance Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpBalanceType" runat="server" Width="100px" CssClass="InputTxtBox">
                                    <asp:ListItem Value="D">Debit</asp:ListItem>
                                    <asp:ListItem Value="C">Credit</asp:ListItem>
                                </asp:DropDownList>
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
                                <asp:Button ID="btnInsertLedgerName" runat="server" Text="Insert" CssClass="styled-button-1"
                                    ValidationGroup="LedgerName" />
                                &nbsp;<asp:Button ID="btnCancelLedgerName" runat="server" Text="Cancel" CssClass="styled-button-1" />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
            <td>
            </td>
        </tr>
        <tr align="center">
            <td>
            </td>
            <td>
                <asp:Panel ID="pnlCOA" runat="server" Width="800px">
                    <asp:TreeView ID="tvCOA" runat="server">
                    </asp:TreeView>
                </asp:Panel>
            </td>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
