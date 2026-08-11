<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.model.Student" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.dao.StudentDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Kodewala Bright Future Academy</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; display: flex; height: 100vh; overflow: hidden; }
        .bg-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab); background-size: 400% 400%; animation: gradientBG 15s ease infinite; z-index: -1; }
        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
        .sidebar { width: 260px; background: rgba(26, 35, 126, 0.92); backdrop-filter: blur(12px); color: white; display: flex; flex-direction: column; padding: 20px 0; box-shadow: 4px 0 15px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .sidebar-header h2 { font-size: 20px; margin: 0; font-weight: 800; color: #fbc02d; letter-spacing: 1px; }
        .sidebar-menu { flex: 1; margin-top: 25px; }
        .menu-item { padding: 14px 25px; display: flex; align-items: center; color: rgba(255,255,255,0.8); text-decoration: none; transition: all 0.3s ease; font-weight: 500; }
        .menu-item i { margin-right: 15px; width: 20px; font-size: 18px; text-align: center; }
        .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.15); color: #fbc02d; border-left: 5px solid #fbc02d; }
        .sidebar-footer { padding: 20px; display: flex; flex-direction: column; gap: 10px; }
        .footer-btn { display: flex; align-items: center; justify-content: center; padding: 12px; border-radius: 8px; text-decoration: none; font-weight: bold; transition: 0.3s; font-size: 14px; color: white; }
        .logout-btn { background: #d32f2f; }
        .logout-btn:hover { background: #b71c1c; }
        .support-btn { background: #25d366; }
        .support-btn:hover { background: #128c7e; }
        .main-content { flex: 1; overflow-y: auto; padding: 40px; background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(8px); }
        .content-card { background: rgba(255, 255, 255, 0.96); padding: 30px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #f0f2f5; }
        .header h1 { color: #1a237e; margin: 0; font-size: 26px; }
        .stats-badge { background: #1a237e; color: white; padding: 10px 22px; border-radius: 30px; font-size: 14px; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f8fafc; color: #64748b; text-transform: uppercase; font-size: 11px; font-weight: 800; padding: 15px; text-align: left; border-bottom: 2px solid #e2e8f0; }
        td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; color: #334155; font-size: 14px; }
        tr:hover { background-color: #f8fafc; }
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 800; }
        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }
        .action-group { display: flex; gap: 8px; }
        .btn-icon { width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 10px; border: none; cursor: pointer; color: white; transition: 0.2s; text-decoration: none; }
        .btn-icon:hover { transform: translateY(-3px); }
        .approve { background: #22c55e; }
        .delete { background: #ef4444; }
        .whatsapp { background: #25d366; }
        .error-box { background-color: #ffebee; border: 2px solid #c62828; color: #c62828; padding: 30px; margin: 20px; border-radius: 12px; text-align: center; font-size: 16px; }
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.6); backdrop-filter: blur(5px); }
        .modal-content { background-color: #ffffff; margin: 5% auto; padding: 0; border: none; width: 90%; max-width: 600px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); animation: slide-down 0.5s ease; }
        @keyframes slide-down { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px 30px; background-color: #1a237e; color: white; border-top-left-radius: 10px; border-top-right-radius: 10px; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h2 { margin: 0; font-size: 22px; }
        .close-btn { color: #fff; font-size: 30px; font-weight: bold; transition: 0.3s; }
        .close-btn:hover, .close-btn:focus { color: #fbc02d; text-decoration: none; cursor: pointer; }
        .modal-body { padding: 30px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-size: 14px; color: #64748b; margin-bottom: 5px; font-weight: 600; }
        .form-group input, .form-group select { padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: border-color 0.3s, box-shadow 0.3s; }
        .form-group input:focus { outline: none; border-color: #1a237e; box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1); }
        .form-group input[type="file"] { padding: 10px; }
        .modal-footer { padding: 20px 30px; text-align: right; background-color: #f8fafc; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; }
        .submit-btn { background-color: #1a237e; color: white; padding: 12px 25px; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; transition: background-color 0.3s; }
        .submit-btn:hover { background-color: #283593; }
    </style>
</head>
<body>
    <%
        String dbError = (String) application.getAttribute("dbConnectionError");
        List<Student> students = null;
        if (dbError == null) {
            StudentDAO studentDAO = (StudentDAO) application.getAttribute("studentDAO");
            if (studentDAO != null) {
                try {
                    students = studentDAO.getAllStudents();
                } catch (Exception e) {
                    dbError = "Error fetching students: " + e.getMessage();
                }
            } else {
                dbError = "CRITICAL: StudentDAO not found. The application is not properly initialized.";
            }
        }
    %>
    <div class="bg-container"></div>
    <div class="sidebar">
        <div class="sidebar-header"><h2>KODEWALA</h2><p style="font-size: 10px; opacity: 0.7; font-weight: bold;">BRIGHT FUTURE ACADEMY</p></div>
        <div class="sidebar-menu">
            <a href="#" class="menu-item active"><i class="fas fa-user-graduate"></i> Admissions</a>
            <a href="#" class="menu-item"><i class="fas fa-book"></i> Assignments</a>
            <a href="#" class="menu-item"><i class="fas fa-video"></i> Live Session</a>
            <a href="#" class="menu-item"><i class="fas fa-play-circle"></i> Recordings</a>
            <a href="#" class="menu-item"><i class="fas fa-award"></i> Placements</a>
        </div>
        <div class="sidebar-footer">
            <a href="https://wa.me/919897123456" target="_blank" class="footer-btn support-btn"><i class="fab fa-whatsapp"></i> WhatsApp Support</a>
            <a href="login.jsp" class="footer-btn logout-btn"><i class="fas fa-power-off"></i> Logout</a>
        </div>
    </div>
    <div class="main-content">
        <% if (dbError != null) { %>
            <div class="error-box">
                <h2>FATAL: Application Error</h2>
                <p>Could not load dashboard data. Please check the server logs for details.</p>
                <p><strong>Error Details:</strong> <%= dbError %></p>
            </div>
        <% } else { %>
            <div class="content-card">
                <div class="header">
                    <h1>Admissions Management</h1>
                    <button id="registerBtn" class="stats-badge" style="cursor:pointer; border:none; background-color: #22c55e;">+ Register Student</button>
                    <div class="stats-badge">Total Applicants: <%= (students != null) ? students.size() : 0 %></div>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Details</th>
                            <th>Phone</th>
                            <th>Plan</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (students != null && !students.isEmpty()) { for (Student student : students) { %>
                        <tr>
                            <td><strong><%= (student.getStudentId() == null || student.getStudentId().equals("PENDING")) ? "NEW" : student.getStudentId() %></strong></td>
                            <td>
                                <div style="font-weight: 700; color: #1e293b;"><%= student.getName() %></div>
                                <div style="font-size: 12px; color: #64748b;"><%= student.getEmail() %></div>
                            </td>
                            <td style="font-weight: 600;"><%= student.getPhone() %></td>
                            <td><span style="background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 12px;"><%= student.getPaymentMethod() %></span></td>
                            <td><span class="status-badge status-<%= student.getStatus() != null ? student.getStatus().toLowerCase() : "pending" %>"><%= student.getStatus() %></span></td>
                            <td>
                                <div class="action-group">
                                    <% if ("Pending".equals(student.getStatus())) { %>
                                        <form action="students" method="post" style="margin:0;"><input type="hidden" name="action" value="approve"><input type="hidden" name="id" value="<%= student.getId() %>"><button type="submit" class="btn-icon approve" title="Approve"><i class="fas fa-check"></i></button></form>
                                    <% } %>
                                    <a href="https://wa.me/91<%= student.getPhone() %>" target="_blank" class="btn-icon whatsapp" title="Chat"><i class="fab fa-whatsapp"></i></a>
                                    <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= student.getId() %>"><button type="submit" class="btn-icon delete" title="Delete"><i class="fas fa-trash"></i></button></form>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" style="text-align:center; padding:50px; color:#94a3b8;">No records found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    <div id="registerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h2>Register New Student</h2><span class="close-btn">&times;</span></div>
            <form action="students" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group"><label for="name">Full Name</label><input type="text" id="name" name="name" required></div>
                        <div class="form-group"><label for="phone">Phone Number</label><input type="text" id="phone" name="phone" required></div>
                        <div class="form-group" style="grid-column: 1 / -1;"><label for="email">Email Address</label><input type="email" id="email" name="email" required></div>
                        <div class="form-group"><label for="qualification">Qualification</label><input type="text" id="qualification" name="qualification"></div>
                        <div class="form-group"><label for="academic_gap">Academic Gap (Years)</label><input type="text" id="academic_gap" name="academic_gap"></div>
                        <div class="form-group"><label for="payment_method">Payment Method</label><input type="text" id="payment_method" name="payment_method"></div>
                        <div class="form-group"><label for="total_amount">Total Amount</label><input type="number" id="total_amount" name="total_amount" value="35000"></div>
                        <div class="form-group"><label for="referred_by">Referred By</label><input type="text" id="referred_by" name="referred_by"></div>
                        <div class="form-group" style="grid-column: 1 / -1;"><label for="photo">Student Photo</label><input type="file" id="photo" name="photo"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" name="action" value="register">
                    <button type="submit" class="submit-btn">Register Student</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        var modal = document.getElementById("registerModal");
        var btn = document.getElementById("registerBtn");
        var span = document.getElementsByClassName("close-btn")[0];
        if(btn) { btn.onclick = function() { modal.style.display = "block"; } }
        if(span) { span.onclick = function() { modal.style.display = "none"; } }
        window.onclick = function(event) { if (event.target == modal) { modal.style.display = "none"; } }
    </script>
</body>
</html>