<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmUploadFiles.aspx.vb" Inherits="frmUploadFiles"
    Title=".::Valmonte Sweaters: Upload Files::." %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
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
        <tr align="center">
            <td>
                <asp:Panel ID="pnlListedEmployees" runat="server" SkinID="pnlInner" Width="70%">
                    <div style="max-height: 150px; max-width: 100%; overflow: auto">
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
        <tr align="center">
            <td>
                <asp:Panel ID="pnlUploadParameters" runat="server" SkinID="pnlInner" Width="70%">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                File Type
                            </td>
                            <td>
                                <asp:DropDownList ID="drpFileType" runat="server" CssClass="InputTxtBox">
                                    <asp:ListItem Value="APP">Application</asp:ListItem>
                                    <asp:ListItem Value="WINC">Wage Increment</asp:ListItem>
                                    <asp:ListItem Value="NID">NationalID</asp:ListItem>
                                    <asp:ListItem Value="PH">Photo</asp:ListItem>
                                    <asp:ListItem Value="SIG">Signature</asp:ListItem>
                                    <asp:ListItem>Others</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:FileUpload ID="flupDocuments" runat="server" />
                            </td>
                            <td>
                                <asp:Button ID="btnUpload" runat="server" CssClass="styled-button-1" Text="Upload" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td class="label">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
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
            <td>
                <asp:Panel ID="pnlUploadedFiles" runat="server" SkinID="pnlInner" Width="70%">
                    <div>
                        <asp:GridView ID="grdUploadedFilesByEmp" runat="server" AutoGenerateColumns="False"
                            CssClass="mGrid">
                            <Columns>
                                <asp:BoundField DataField="FileType" HeaderText="FileType" />
                                <asp:BoundField DataField="FileTitle" HeaderText="FileTitle" />
                                <asp:BoundField DataField="EntryBy" HeaderText="EntryBy" />
                                <asp:BoundField DataField="UploadedOn" HeaderText="UploadedOn" />
                                <asp:TemplateField HeaderText="View" ShowHeader="true">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="hpDocument" runat="server" CssClass="linkbtn" NavigateUrl='<%#"~/Attachments/"+ Eval("FileTitle") %>'
                                            Target="_blank">View</asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </td>
        </tr>
        <tr align="center">
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
