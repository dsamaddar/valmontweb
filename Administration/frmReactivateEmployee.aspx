<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmReactivateEmployee.aspx.vb" Inherits="Administration_frmReactivateEmployee"
    Title=".:ValmontWEB : Employee Reactivation:." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        window.onload = function() {
            var strCook = document.cookie;
            if (strCook.indexOf("!~") != 0) {
                var intS = strCook.indexOf("!~");
                var intE = strCook.indexOf("~!");
                var strPos = strCook.substring(intS + 2, intE);
                document.getElementById("divCandidate").scrollTop = strPos;
                }
        }
        function SetDivPosition() {
            var intY = document.getElementById("divCandidate").scrollTop;
            document.title = intY;
            document.cookie = "yPos=!~" + intY + "~!";
        }
    </script>

    <table style="width: 100%;">
        <tr>
            <td align="center">
                <asp:Panel ID="pnlSearchEmp" runat="server" SkinID="pnlInner" Width="70%">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td colspan="6">
                                <div class="widget-title">
                                    Search Worker/Employees for Uploading Documents</div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
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
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Name/Code
                            </td>
                            <td>
                                <asp:TextBox ID="txtNameorCode" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td class="label">
                                Mobile No
                            </td>
                            <td>
                                <asp:TextBox ID="txtMobileNo" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                National ID
                            </td>
                            <td>
                                <asp:TextBox ID="txtNationalID" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>
                                <asp:Button ID="btnSearch" runat="server" CssClass="styled-button-1" Text="Search" />
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:Panel ID="pnlListedEmployees" runat="server" SkinID="pnlInner" Width="70%">
                    <div id="divCandidate" onscroll="SetDivPosition()" style="max-height: 150px; max-width: 100%;
                        overflow: auto">
                        <asp:GridView ID="grdEmpList" runat="server" CssClass="mGrid" AutoGenerateColumns="False">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="EmployeeID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmployeeID" runat="server" Text='<%# Bind("EmployeeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="EmployeeName" HeaderText="Employee" />
                                <asp:BoundField DataField="EmpCode" HeaderText="Code" />
                                <asp:BoundField DataField="MobileNo" HeaderText="Mobile No" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td align="center">
                <asp:Panel ID="pnlReactivation" runat="server" Width="70%" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
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
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button ID="btnApplyChanges" runat="server" Text="Activate Employee" CssClass="styled-button-1" />
                            </td>
                        </tr>
                        <tr align="left">
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
    </table>
</asp:Content>
