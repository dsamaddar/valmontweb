<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frmLogin.aspx.vb" Inherits="frmLogin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <title>.::Valmonte Sweaters: Employee Info::.</title>
    <link href="Sources/jquery/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="Sources/css/ValmontLoginStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="login-card">
        <h2>
            Valmont Sweaters Ltd</h2>
        <br />
        <h1>
            Log-in</h1>
        <br />
        <form runat="server">
        <asp:DropDownList ID="drpModule" runat="server">
            <asp:ListItem Text="Administration Module" Value="Administration"></asp:ListItem>
            <asp:ListItem Text="Accounting Module" Value="Accounting"></asp:ListItem>
            <asp:ListItem Text="Attendance Module" Value="Attendance"></asp:ListItem>
            <asp:ListItem Text="Inventory Module" Value="Inventory"></asp:ListItem>
            <asp:ListItem Text="Production Module" Value="Production"></asp:ListItem>
            <asp:ListItem Text="Security Module" Value="Security"></asp:ListItem>
        </asp:DropDownList>
        <br />
        <asp:TextBox ID="txtUserID" runat="server" placeholder="User ID"></asp:TextBox>
        <asp:TextBox ID="txtUserPassword" runat="server" placeholder="Password" TextMode="Password"></asp:TextBox>
        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login login-submit" />
        </form>
        <div class="login-help">
            <a href="frmChangePassword.aspx">Change Password</a>
        </div>
    </div>
    <!-- <div id="error"><img src="https://dl.dropboxusercontent.com/u/23299152/Delete-icon.png" /> Your caps-lock is on.</div> -->

    <script src="Sources/jquery/jquery.min.js" type="text/javascript"></script>

    <script src="Sources/jquery/jquery-ui.min.js" type="text/javascript"></script>

</body>
</html>
