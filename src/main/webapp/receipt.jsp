<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.dao.StudentDAO" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.model.Student" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Receipt</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; }
        .receipt-container { width: 80%; margin: auto; border: 1px solid #ccc; padding: 20px; }
        h1 { text-align: center; }
        .details-table { width: 100%; margin-top: 20px; }
        .details-table td { padding: 10px; }
    </style>
</head>
<body>
    <%
        String studentId = request.getParameter("studentId");
        StudentDAO studentDAO = (StudentDAO) application.getAttribute("studentDAO");
        Student student = null;
        if (studentId != null && studentDAO != null) {
            try {
                student = studentDAO.getStudentByStudentId(studentId);
            } catch (Exception e) {
                // Handle exception
            }
        }
    %>
    <div class="receipt-container">
        <h1>Payment Receipt</h1>
        <% if (student != null) { %>
            <table class="details-table">
                <tr><td><strong>Student ID:</strong></td><td><%= student.getStudentId() %></td></tr>
                <tr><td><strong>Name:</strong></td><td><%= student.getName() %></td></tr>
                <tr><td><strong>Email:</strong></td><td><%= student.getEmail() %></td></tr>
                <tr><td><strong>Batch Number:</strong></td><td><%= student.getBatchNumber() %></td></tr>
                <tr><td><strong>Payment Status:</strong></td><td><%= student.getPaymentStatus() %></td></tr>
                <tr><td><strong>Total Amount:</strong></td><td><%= student.getTotalAmount() %></td></tr>
            </table>
        <% } else { %>
            <p>Student not found.</p>
        <% } %>
    </div>
</body>
</html>