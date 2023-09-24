<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frmChangePassword.aspx.vb"
    Inherits="frmChangePassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="UTF-8">
    <title>.::Valmonte Sweaters: Change Password::.</title>
    <link href="Sources/jquery/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="Sources/css/ValmontLoginStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="login-card">
        <h2>
            Valmont Sweaters Ltd</h2>
        <br />
        <h3>
            Change Password</h3>
        <form id="Form1" runat="server">
        <asp:TextBox ID="txtUserID" runat="server" placeholder="User ID"></asp:TextBox>
        <asp:TextBox ID="txtCurrentPassword" runat="server" placeholder="Current Password"
            TextMode="Password"></asp:TextBox>
        <asp:TextBox ID="txtNewPassword" runat="server" placeholder="New Password" TextMode="Password"></asp:TextBox>
        <asp:TextBox ID="txtNewPasswordConfirm" runat="server" placeholder="Confirm Password"
            TextMode="Password"></asp:TextBox>
        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="login login-submit" />
        </form>
        <div class="login-help">
            <a href="frmLogin.aspx">Login</a>
        </div>
    </div>
    <!-- <div id="error"><img src="https://dl.dropboxusercontent.com/u/23299152/Delete-icon.png" /> Your caps-lock is on.</div> -->

    <script src="Sources/jquery/jquery.min.js" type="text/javascript"></script>

    <script src="Sources/jquery/jquery-ui.min.js" type="text/javascript"></script>

</body>
</html>
