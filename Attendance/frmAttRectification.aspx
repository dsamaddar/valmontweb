<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false"
    CodeFile="frmAttRectification.aspx.vb" Inherits="Attendance_frmAttRectification"
    Title="Valmont::Att.Rectification :." Theme="CommonSkin" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlSelectEmp" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Attendance Rectification : Shifting Duty</div>
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
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px" class="label">
                                Select Employee
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEmployeeList" runat="server" CssClass="InputTxtBox" 
                                    Width="200px">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
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
                <asp:Panel ID="pnlAttRectification" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px" class="label">
                                Shift Type
                            </td>
                            <td style="width: 200px">
                                <asp:RadioButtonList ID="rdbtnShiftType" runat="server" RepeatDirection="Horizontal"
                                    CssClass="label" ValidationGroup="rectification">
                                    <asp:ListItem>Morning</asp:ListItem>
                                    <asp:ListItem>Evening</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Start Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtStartDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtStartDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtStartDate">
                                </cc1:CalendarExtender>
                            </td>
                            <td class="label">
                                End Date
                            </td>
                            <td>
                                <asp:TextBox ID="txtEndDate" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtEndDate_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtEndDate">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldStartDate" runat="server" ControlToValidate="txtStartDate"
                                    ErrorMessage="Error: Start Date Required" ValidationGroup="rectification"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldEndDate" runat="server" ControlToValidate="txtEndDate"
                                    ErrorMessage="Error: End Date Required" ValidationGroup="rectification"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnRunRectification" runat="server" Text="Run Rectification" ValidationGroup="rectification" />
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
