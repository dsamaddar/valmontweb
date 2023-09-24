<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmNoWorkDayDeclaration.aspx.vb" Inherits="Attendance_frmNoWorkDayDeclaration"
    Title=".:Valmont:No Working Day:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="left">
            <td>
                <asp:Panel ID="pnlNoWorkDaySettings" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="4">
                                <div class="widget-title">
                                    No Work Day Declaration
                                </div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
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
        <tr align="left">
            <td>
                <asp:Panel ID="pnlSearchEmployees" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
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
                            <td>
                            </td>
                            <td class="label">
                                Select Section
                            </td>
                            <td>
                                <asp:DropDownList ID="drpSections" runat="server" CssClass="InputTxtBox" Width="200px"
                                    AutoPostBack="True">
                                </asp:DropDownList>
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
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr align="left">
            <td>
                <asp:Panel ID="pnlEmployeeList" runat="server" SkinID="pnlInner">
                    <div style="max-height: 150px; max-width: 100%; overflow: auto">
                        <asp:GridView ID="grdEmpList" runat="server" AutoGenerateColumns="False" EmptyDataText="Empty Employee List"
                            CssClass="mGrid">
                            <Columns>
                                <asp:TemplateField HeaderText="Select">
                                    <HeaderTemplate>
                                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkItems" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmployeeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeID" runat="server" Text='<%# Bind("EmployeeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EmployeeName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeName" runat="server" Text='<%# Bind("EmployeeName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr align="left">
            <td>
                <asp:Panel ID="pnlLeaveSubmission" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
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
                            <td class="label">
                                No Work Day Starts
                            </td>
                            <td>
                                <asp:TextBox ID="txtLeaveStarts" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtLeaveStarts_CalendarExtender0" runat="server" Enabled="True"
                                    TargetControlID="txtLeaveStarts">
                                </cc1:CalendarExtender>
                            </td>
                            <td class="label">
                                No Work Day Ends
                            </td>
                            <td>
                                <asp:TextBox ID="txtLeaveEnds" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtLeaveEnds_CalendarExtender0" runat="server" Enabled="True"
                                    TargetControlID="txtLeaveEnds">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnSubmit" runat="server" CssClass="styled-button-1" Text="Apply for No Work Day" />
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
        <tr align="left">
            <td>
                <table style="width: 100%;">
                    <tr>
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
                            Select Employee
                        </td>
                        <td>
                            <asp:DropDownList ID="drpEmployeeList" runat="server" CssClass="InputTxtBox" Width="200px"
                                AutoPostBack="True">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr align="left">
            <td>
                <asp:GridView ID="grdNoWorkDays" runat="server" AutoGenerateColumns="False" 
                    CssClass="mGrid">
                    <Columns>
                        <asp:TemplateField HeaderText="NoWorkDayID" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblNoWorkDayID" runat="server" Text='<%# Bind("NoWorkDayID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Employee">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("EmployeeName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EmpCode">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("EmpCode") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="NoWorkDay">
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("NoWorkDay") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <asp:ImageButton Width="30" ID="imgDelete" CommandName="Delete" runat="server" OnClientClick="return confirm('Are You Sure You Want to Delete?')"
                                    ImageUrl="../Sources/img/erase.png" CausesValidation="False" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
    </table>
</asp:Content>
