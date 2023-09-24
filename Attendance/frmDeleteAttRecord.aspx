<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmDeleteAttRecord.aspx.vb" Inherits="Attendance_frmDeleteAttRecord"
    Title=".:Valmont:Delete Attendance Records:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="left">
            <td>
                <asp:Panel ID="pnlSelectEmp" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td colspan="4">
                                <div class="widget-title">
                                    Delete Attendance Records</div>
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
                            <td style="width: 150px">
                                Select Employee
                            </td>
                            <td>
                                <asp:DropDownList ID="drpEmployeeList" runat="server" CssClass="InputTxtBox" Width="200px"
                                    AutoPostBack="True">
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
                <asp:Panel ID="pnlAttRecord" runat="server" SkinID="pnlInner">
                    <div style="max-height: 300px; max-width: 100%; overflow: auto">
                        <asp:GridView ID="grdAttRecord" runat="server" AutoGenerateColumns="False" CssClass="mGrid">
                            <Columns>
                                <asp:TemplateField HeaderText="UserAttendanceID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUserAttendanceID" runat="server" Text='<%# Bind("UserAttendanceID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="LogTime" HeaderText="LogTime" />
                                <asp:BoundField DataField="IdealLogTime" HeaderText="IdealLogTime" />
                                <asp:BoundField DataField="IdealLogOutTime" HeaderText="IdealLogOutTime" />
                                <asp:BoundField DataField="AttSystem" HeaderText="AttSystem" />
                                <asp:BoundField DataField="AuthStatus" HeaderText="AuthStatus" />
                                <asp:BoundField DataField="EntryDate" HeaderText="EntryDate" />
                                <asp:TemplateField HeaderText="Activate">
                                    <ItemTemplate>
                                        <asp:ImageButton Width="30" ID="imgCheck" CommandName="Update" runat="server" OnClientClick="return confirm('Are You Sure You Want to Activate?')"
                                            ImageUrl="../Sources/img/check.png" CausesValidation="False" />
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
                </asp:Panel>
            </td>
        </tr>
        <tr align="left">
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
