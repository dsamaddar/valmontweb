<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmRetrieveAttendanceLog.aspx.vb" Inherits="Attendance_frmRetrieveAttendanceLog"
    Title=".:E-HRM:Attendance Log:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr>
            <td align="left">
                <asp:Panel ID="pnlAttendanceLog" runat="server" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr>
                            <td class="widget-title">
                                Attendance Log
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="max-width: 100%; max-height: 400px; overflow: auto">
                                    <asp:GridView ID="grdAttendanceLog" runat="server" CssClass="mGrid" EmptyDataText="No Data Found"
                                        AutoGenerateColumns="False">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Select">
                                                <HeaderTemplate>
                                                    <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkSelectAll_CheckedChanged" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkItems" runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="LOGID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblLOGID" runat="server" Text='<%# Bind("LOGID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Badgenumber">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblBadgenumber" runat="server" Text='<%# Bind("Badgenumber") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblname" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="CHECKTIME">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCHECKTIME" runat="server" Text='<%# Bind("CHECKTIME") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="CHECKTYPE">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCHECKTYPE" runat="server" Text='<%# Bind("CHECKTYPE") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnImportData" runat="server" Text="Import Data" />
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
            </td>
        </tr>
    </table>
</asp:Content>
