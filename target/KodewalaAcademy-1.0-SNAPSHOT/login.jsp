<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Login</title>
</head>
<body>
    <h2>Admin Login</h2>
    <form action="login" method="post">
        ID: <input type="text" name="adminId"><br>
        Password: <input type="password" name="password"><br>
        <input type="submit" value="Login">
    </form>
    <% if(request.getAttribute("error") != null) { %>
        <p style="color:red;"><%= request.getAttribute("error") %></p>
    <% } %>
</body>
</html>
