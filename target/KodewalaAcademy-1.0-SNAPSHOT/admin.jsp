<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.kodewala.academy.model.Student" %>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Admin Dashboard (Legacy)</h1>
    <table border="1">
        <tr>
            <th>Name</th>
            <th>Phone</th>
            <th>Status</th>
        </tr>
        <%
            List<Student> students = (List<Student>) request.getAttribute("students");
            if(students != null) {
                for(Student s : students) {
        %>
        <tr>
            <td><%= s.getName() %></td>
            <td><%= s.getPhone() %></td>
            <td><%= s.getStatus() %></td>
        </tr>
        <%      }
            }
        %>
    </table>
    <br>
    <a href="admin?action=logout">Logout</a>
</body>
</html>
