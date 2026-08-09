<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.model.Student" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Kodewala Academy</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #1a237e; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #1a237e; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .status-pending { color: #fbc02d; font-weight: bold; }
        .status-approved { color: #4caf50; font-weight: bold; }
        .status-rejected { color: #e53935; font-weight: bold; }
        .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 12px; color: white; margin-right: 5px; }
        .btn-approve { background-color: #4caf50; }
        .btn-reject { background-color: #fbc02d; }
        .btn-delete { background-color: #e53935; }
        .btn-whatsapp { background-color: #25d366; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard - Registered Students</h1>
        <table>
            <thead>
                <tr>
                    <th>DB ID</th>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Payment Mode</th>
                    <th>Status</th>
                    <th>Batch</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Student> students = (List<Student>) request.getAttribute("students");
                    if (students != null) {
                        for (Student student : students) {
                %>
                <tr>
                    <td><%= student.getId() %></td>
                    <td><%= (student.getStudentId() == null || student.getStudentId().equals("PENDING")) ? "---" : student.getStudentId() %></td>
                    <td><%= student.getName() %></td>
                    <td><%= student.getPhone() %></td>
                    <td><%= student.getPaymentMethod() %></td>
                    <td class="status-<%= student.getStatus().toLowerCase() %>"><%= student.getStatus() %></td>
                    <td><%= (student.getBatchNumber() == null || student.getBatchNumber().equals("PENDING")) ? "---" : student.getBatchNumber() %></td>
                    <td>
                        <% if ("Pending".equals(student.getStatus())) { %>
                            <form action="students" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="id" value="<%= student.getId() %>">
                                <button type="submit" class="btn btn-approve">Approve</button>
                            </form>
                            <form action="students" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="id" value="<%= student.getId() %>">
                                <button type="submit" class="btn btn-reject">Reject</button>
                            </form>
                        <% } %>
                        <a href="https://wa.me/<%= student.getPhone() %>" target="_blank" class="btn btn-whatsapp">WhatsApp</a>
                        <form action="students" method="post" style="display:inline;" onsubmit="return confirm('Are you sure?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= student.getId() %>">
                            <button type="submit" class="btn btn-delete">Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="8">No records found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
