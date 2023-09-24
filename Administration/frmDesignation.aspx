<%@ Page Language="VB" MasterPageFile="~/Administration/Administration.master" AutoEventWireup="false"
    Theme="CommonSkin" CodeFile="frmDesignation.aspx.vb" Inherits="Administration_frmDesignation"
    Title=".:Valmont:Designation Settings:." %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table style="width: 100%;">
        <tr align="center">
            <td>
                <asp:Panel ID="pnlDesignationSettings" runat="server" Width="70%" SkinID="pnlInner">
                    <table style="width: 100%;">
                        <tr align="left">
                            <td align="left" class="label" style="height: 20px" colspan="5">
                                <div class="widgettitle">
                                    Designation Settings<asp:ScriptManager ID="ScriptManager1" runat="server">
                                    </asp:ScriptManager>
                                </div>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td style="width: 150px">
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="reqFldDesignationName" runat="server" ControlToValidate="txtDesignationName"
                                    Display="None" ErrorMessage="Required" ValidationGroup="InputDesignation"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="reqFldDesignationName_ValidatorCalloutExtender0"
                                    runat="server" CloseImageUrl="~/Sources/images/valClose.png" CssClass="customCalloutStyle"
                                    Enabled="True" TargetControlID="reqFldDesignationName" WarningIconImageUrl="~/Sources/images/Valwarning.png">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                            <td>
                                <asp:HiddenField ID="hdFldDesignationID" runat="server" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td style="width: 20px">
                            </td>
                            <td class="label">
                                Designation
                            </td>
                            <td>
                                <asp:TextBox ID="txtDesignationName" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                            <td class="label">
                                Designation In Bangla
                            </td>
                            <td>
                                <asp:TextBox ID="txtDesignationInBangla" runat="server" CssClass="InputTxtBox" Width="200px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Designation Label
                            </td>
                            <td align="left">
                                <asp:DropDownList ID="ddlDesigLabel" runat="server" CssClass="InputTxtBox">
                                    <asp:ListItem Value="0" Selected="True">-Select-</asp:ListItem>
                                    <asp:ListItem Value="Management">Management</asp:ListItem>
                                    <asp:ListItem Value="Non-Management">Non-Management</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="label">
                                Designation Type
                            </td>
                            <td>
                                <asp:RadioButtonList ID="rdoDesignationType" runat="server" AutoPostBack="True" CssClass="rbdText"
                                    RepeatDirection="Horizontal">
                                    <asp:ListItem Enabled="true">Official</asp:ListItem>
                                    <asp:ListItem>Functional</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Order
                            </td>
                            <td>
                                <asp:TextBox ID="txtOrder" runat="server" CssClass="InputTxtBox" Width="50px"></asp:TextBox>
                            </td>
                            <td class="label">
                                Short Code
                            </td>
                            <td>
                                <asp:TextBox ID="txtShortCode" runat="server" CssClass="InputTxtBox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td class="label">
                                Is Active
                            </td>
                            <td>
                                <asp:CheckBox ID="chkIsDesigActive" runat="server" CssClass="chkText" Text="         Is Active  " />
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr align="left">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td align="left">
                                <asp:Button ID="btnInsertDesignation" runat="server" CssClass="styled-button-1" Text="Insert"
                                    ValidationGroup="InputDesignation" />
                                &nbsp;<asp:Button ID="btnUpdateDesignation" runat="server" CssClass="styled-button-1"
                                    Text="Update" ValidationGroup="InputDesignation" />
                                &nbsp;<asp:Button ID="btnCancelSelection" runat="server" CssClass="styled-button-1"
                                    Text="Cancel" />
                            </td>
                            <td align="left">
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
            <td>
                <asp:Panel ID="pnlDesignationList" runat="server" Width="70%" SkinID="pnlInner">
                    <div style="max-height: 250px; max-width: 100%; overflow: auto">
                        <asp:GridView ID="grdDesignationList" runat="server" AutoGenerateColumns="False"
                            CssClass="mGrid">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" />
                                <asp:TemplateField HeaderText="DesignationID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignationID" runat="server" Text='<%# Bind("DesignationID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignation" runat="server" Text='<%# Bind("Designation") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DesignationBangla">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignationBangla" runat="server" Text='<%# Bind("DesignationBangla") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ShortCode">
                                    <ItemTemplate>
                                        <asp:Label ID="lblShortCode" runat="server" Text='<%# Bind("ShortCode") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DesignationLevel">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignationLevel" runat="server" Text='<%# Bind("DesignationLevel") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DesignationType">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesignationType" runat="server" Text='<%# Bind("DesignationType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IntOrder">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIntOrder" runat="server" Text='<%# Bind("IntOrder") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IsActive">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsActive" runat="server" Text='<%# Bind("IsActive") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="EntryBy">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEntryBy" runat="server" Text='<%# Bind("EntryBy") %>'></asp:Label>
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
