<%@ Page Language="VB" MasterPageFile="~/Attendance/Attendance.master" AutoEventWireup="false"
    CodeFile="frmLeaveException.aspx.vb" Inherits="Attendance_frmLeaveException" Title=".:Valmont:Leave/Holiday Excepiton:."
    Theme="CommonSkin" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../Sources/css/UltraCssClass.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        window.onload = function() {
            var strCook = document.cookie;
            if (strCook.indexOf("!~") != 0) {
                var intS = strCook.indexOf("!~");
                var intE = strCook.indexOf("~!");
                var strPos = strCook.substring(intS + 2, intE);
                document.getElementById("divgrd").scrollTop = strPos;
            }
        }
        function SetDivPosition() {
            var intY = document.getElementById("divgrd").scrollTop;
            document.title = intY;
            document.cookie = "yPos=!~" + intY + "~!";
        }

        window.scrollBy(100, 100); 
    </script>

    <table style="width: 100%;">
        <tr align="center">
            <td>
                <asp:Panel ID="pnlInputFormHoliday" runat="server" SkinID="pnlInner" Width="800px">
                    <table style="width: 100%;">
                        <tr>
                            <td align="left" colspan="6">
                                <div class="widgettitle">
                                    Leave Exception<asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 300px">
                                <asp:RequiredFieldValidator ID="reqFldStartDate" runat="server" 
                                    ControlToValidate="txtLeaveExpDate" Display="None" 
                                    ErrorMessage="Required: Holiday Start Date" ValidationGroup="exp"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldStartDate_ValidatorCalloutExtender" 
                                    runat="server" CloseImageUrl="~/Sources/images/valClose.png" 
                                    CssClass="customCalloutStyle" Enabled="True" TargetControlID="reqFldStartDate" 
                                    WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                            <td style="width: 20px">
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldHolidayPurpose" runat="server" 
                                    ControlToValidate="txtPurpose" Display="None" 
                                    ErrorMessage="Required: Holiday Purpose" ValidationGroup="exp"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldHolidayPurpose_ValidatorCalloutExtender" 
                                    runat="server" CloseImageUrl="../Sources/img/valClose.png" 
                                    CssClass="customCalloutStyle" Enabled="True" 
                                    TargetControlID="reqFldHolidayPurpose" 
                                    WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td class="label">
                            </td>
                            <td class="label">
                                <asp:Label ID="lblDateFrom" runat="server" Text="Date From"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtLeaveExpDate" runat="server" CssClass="InputTxtBox" 
                                    Width="120px" ValidationGroup="exp"></asp:TextBox>
                                <cc1:CalendarExtender ID="dtDateFm_CalendarExtender" Format="dd-MMM-yy" runat="server"
                                    Enabled="True" TargetControlID="txtLeaveExpDate">
                                </cc1:CalendarExtender>
                                &nbsp;
                                </td>
                            <td>
                            </td>
                            <td class="label" runat="server" id="IDDateto">
                                Remarks
                            </td>
                            <td runat="server" id="tdDateto">
                                <asp:TextBox ID="txtPurpose" runat="server" CssClass="InputTxtBox" 
                                    Width="200px" ValidationGroup="exp"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;</td>
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
                            <td align="left">
                                &nbsp;<asp:Button ID="btnInputExp" runat="server" CssClass="styled-button-1" 
                                    Text="Save" ValidationGroup="exp" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="styled-button-1" />
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
        <tr align="center">
            <td></td>
        </tr>
        <tr align="center">
            <td>
                <asp:Panel ID="pnlLeaveExceptionList" runat="server" SkinID="pnlInner" Width="800px">
                    <table style="width: 100%;">
                        <tr>
                            <td align="left">
                                <div class="widget-title">Exception Leave List</div></td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divgrd" onscroll="SetDivPosition()" style="max-height: 150px; width: 100%;
                                    overflow: auto">
                                    <asp:GridView ID="grdLeaveExceptionList" runat="server" AutoGenerateColumns="False" DataKeyNames="ExceptionID"
                                        Width="100%" AllowSorting="True" CssClass="mGrid">
                                        <Columns>
                                            <asp:TemplateField HeaderText="ExceptionID" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblExceptionID" runat="server" Text='<%# Bind("ExceptionID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Date">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblExceptionDate" runat="server" Text='<%# Bind("ExceptionDate") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Remarks">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRemarks" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label>
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
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td></td>
        </tr>
        <tr align="center">
            <td>
                <asp:Panel ID="Panel1" runat="server" SkinID="pnlInner" Width="800px">
                    <table style="width: 100%;">
                        <tr>
                            <td align="left" colspan="6">
                                <div class="widgettitle">
                                    Compensatory Leave</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td style="width: 300px">
                                <asp:RequiredFieldValidator ID="reqFldComLeaveDt" runat="server" 
                                    ControlToValidate="txtComLeaveDt" Display="None" 
                                    ErrorMessage="Required: Holiday Start Date" ValidationGroup="com"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" 
                                    runat="server" CloseImageUrl="~/Sources/images/valClose.png" 
                                    CssClass="customCalloutStyle" Enabled="True" TargetControlID="reqFldStartDate" 
                                    WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                            <td style="width: 20px">
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldComLeavePurpose" runat="server" 
                                    ControlToValidate="txtCompLeavePurpose" Display="None" 
                                    ErrorMessage="Required: Holiday Purpose" ValidationGroup="com"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender2" 
                                    runat="server" CloseImageUrl="../Sources/img/valClose.png" 
                                    CssClass="customCalloutStyle" Enabled="True" 
                                    TargetControlID="reqFldHolidayPurpose" 
                                    WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr align="left">
                            <td class="label">
                            </td>
                            <td class="label">
                                <asp:Label ID="Label1" runat="server" Text="Date From"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtComLeaveDt" runat="server" CssClass="InputTxtBox" 
                                    Width="120px" ValidationGroup="com"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" Format="dd-MMM-yy" runat="server"
                                    Enabled="True" TargetControlID="txtComLeaveDt">
                                </cc1:CalendarExtender>
                                &nbsp;
                                </td>
                            <td>
                            </td>
                            <td class="label" runat="server" id="Td1">
                                Purpose
                            </td>
                            <td runat="server" id="td2">
                                <asp:TextBox ID="txtCompLeavePurpose" runat="server" CssClass="InputTxtBox" 
                                    Width="200px" ValidationGroup="com"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;</td>
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
                            <td align="left">
                                <asp:Button ID="btnInsertCompLeave" runat="server" Text="Insert" CssClass="styled-button-1"
                                    ValidationGroup="com" />
                                &nbsp;<asp:Button ID="btnCancelCompLeave" runat="server" Text="Cancel" 
                                    CssClass="styled-button-1" />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td></td>
        </tr>
        <tr align="center">
            <td>
                <asp:Panel ID="Panel2" runat="server" SkinID="pnlInner" Width="800px">
                    <table style="width: 100%;">
                        <tr>
                            <td align="left">
                            <div class="widget-title">Compensatory Leave List</div>
                                </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="div1" onscroll="SetDivPosition()" style="max-height: 150px; width: 100%;
                                    overflow: auto">
                                    <asp:GridView ID="grdCompensatoryLeaveList" runat="server" AutoGenerateColumns="False" DataKeyNames="CompensatoryLeaveID"
                                        Width="100%" AllowSorting="True" CssClass="mGrid">
                                        <Columns>
                                            <asp:TemplateField HeaderText="CompensatoryLeaveID" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCompensatoryLeaveID" runat="server" Text='<%# Bind("CompensatoryLeaveID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Date">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCompensatoryDate" runat="server" Text='<%# Bind("CompensatoryDate") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Remarks">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblComRemarks" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label>
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
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>
