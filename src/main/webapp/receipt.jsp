<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.dao.StudentDAO" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.model.Student" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Receipt</title>
    <!-- Include html2pdf.js library from a CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"></script>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .actions-bar { text-align: center; margin-bottom: 20px; }
        .btn { background-color: #1a237e; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin: 0 10px; }
        .btn-print { background-color: #007bff; }
        .receipt-container { position: relative; width: 800px; margin: 20px auto; background: #fff; border: 1px solid #dcdcdc; box-shadow: 0 0 20px rgba(0,0,0,0.1); padding: 50px; overflow: hidden; }
        .watermark { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%) rotate(-45deg); font-size: 80px; font-weight: bold; color: rgba(0, 0, 0, 0.05); z-index: 1; pointer-events: none; white-space: nowrap; }
        .receipt-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #fbc02d; padding-bottom: 20px; position: relative; z-index: 2; }
        .receipt-header img { width: 100px; height: 100px; }
        .receipt-header .academy-info { text-align: right; color: #1a237e; }
        .receipt-header h1 { margin: 0; font-size: 28px; }
        .receipt-details { margin-top: 30px; position: relative; z-index: 2; }
        .details-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .details-table td { padding: 15px; border-bottom: 1px solid #eee; }
        .details-table td:first-child { font-weight: bold; color: #555; width: 200px; }
        .payment-summary { margin-top: 40px; text-align: right; position: relative; z-index: 2; }
        .total-amount { font-size: 24px; font-weight: bold; color: #1a237e; }
        .receipt-footer { margin-top: 50px; text-align: center; font-size: 12px; color: #888; position: relative; z-index: 2; }

        /* Print-specific styles */
        @media print {
            body { background-color: #fff; padding: 0; }
            .actions-bar { display: none; }
            .receipt-container { margin: 0; border: none; box-shadow: none; width: 100%; }
        }
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

    <div class="actions-bar">
        <button class="btn" onclick="downloadPDF()">Download as PDF</button>
        <button class="btn btn-print" onclick="window.print()">Print Receipt</button>
    </div>

    <div id="receipt" class="receipt-container">
        <div class="watermark">Kodewala Bright Future Academy</div>

        <div class="receipt-header">
            <img src="images/logo.png" alt="Academy Logo">
            <div class="academy-info">
                <h1>Payment Receipt</h1>
                <p>Date: <%= new SimpleDateFormat("dd MMM, yyyy").format(new Date()) %></p>
            </div>
        </div>

        <% if (student != null) { %>
            <div class="receipt-details">
                <h2>Student Details</h2>
                <table class="details-table">
                    <tr><td>Student ID:</td><td><%= student.getStudentId() %></td></tr>
                    <tr><td>Name:</td><td><%= student.getName() %></td></tr>
                    <tr><td>Email:</td><td><%= student.getEmail() %></td></tr>
                    <tr><td>Batch Number:</td><td><%= student.getBatchNumber() %></td></tr>
                </table>
            </div>

            <div class="payment-summary">
                <h2>Payment Summary</h2>
                <table class="details-table">
                    <tr><td>Payment Status:</td><td><%= student.getPaymentStatus() %></td></tr>
                    <tr><td>Total Amount Paid:</td><td class="total-amount">₹ <%= student.getTotalAmount() %></td></tr>
                </table>
            </div>
        <% } else { %>
            <p style="text-align:center; color:red; z-index: 2; position: relative;">Receipt could not be generated. Student not found.</p>
        <% } %>

        <div class="receipt-footer">
            <p>This is a computer-generated receipt and does not require a signature.</p>
            <p>&copy; <%= new SimpleDateFormat("yyyy").format(new Date()) %> Kodewala Bright Future Academy. All rights reserved.</p>
        </div>
    </div>

    <script>
        function downloadPDF() {
            const element = document.getElementById('receipt');
            const opt = {
                margin:       0.5,
                filename:     'receipt_<%= student != null ? student.getStudentId() : "student" %>.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2 },
                jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
            };
            // Use html2pdf library to generate the PDF
            html2pdf().from(element).set(opt).save();
        }
    </script>
</body>
</html>