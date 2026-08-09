<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bright Future Academy - Registration</title>
</head>
<body>
    <h1>Student Registration</h1>

    <% if ("true".equals(request.getParameter("success"))) { %>
        <p style="color:green;">Registration successful!</p>
    <% } %>

    <form action="students" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br>
        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" required><br>
        <button type="submit">Register</button>
    </form>
</body>
</html>