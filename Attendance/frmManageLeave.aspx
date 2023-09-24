<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false" Theme="CommonSkin" 
    CodeFile="frmManageLeave.aspx.vb" Inherits="Attendance_frmManageLeave" Title=".:Valmont:Manage Leave App:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td>
                <asp:Panel ID="pnlLeaveApp" runat="server" SkinID="pnlInner" >
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="5">
                                <div class="widget-title">
                                    Manage Leave Application</div>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
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
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                Select Employee
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEmployeeList" runat="server" CssClass="InputTxtBox" Width="200px"
                                    AutoPostBack="True">
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
                            <td class="label">
                                Leave Starts
                            </td>
                            <td>
                                <asp:TextBox ID="txtLeaveStarts" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtLeaveStarts_CalendarExtender" runat="server" Enabled="True"
                                    TargetControlID="txtLeaveStarts">
                                </cc1:CalendarExtender>
                            </td>
                            <td class="label">
                                Leave Ends
                            </td>
                            <td>
                                <asp:TextBox ID="txtLeaveEnds" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="txtLeaveEnds_CalendarExtender" runat="server" Enabled="True"
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
                                <asp:Button ID="btnSubmit" runat="server" CssClass="styled-button-1" Text="Submit" />
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
                <div>
                    <asp:GridView ID="grdLeaveDetails" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="LeaveDetailsID" Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblLeaveDetailID" runat="server" Text='<%# Bind("LeaveDetailID") %>'></asp:Label>
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
                            <asp:TemplateField HeaderText="LeaveDate">
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("LeaveDate") %>'></asp:Label>
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
                </div>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
