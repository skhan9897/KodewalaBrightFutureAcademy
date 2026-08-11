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
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; display: flex; height: 100vh; overflow: hidden; color: #333; }
        .bg-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab); background-size: 400% 400%; animation: gradientBG 15s ease infinite; z-index: -1; }
        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
        .sidebar { width: 260px; background: rgba(26, 35, 126, 0.92); backdrop-filter: blur(12px); color: white; display: flex; flex-direction: column; padding: 20px 0; box-shadow: 4px 0 15px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .sidebar-header h2 { font-size: 20px; margin: 0; font-weight: 800; color: #fbc02d; letter-spacing: 1px; }
        .sidebar-menu { flex: 1; margin-top: 25px; overflow-y: auto; }
        .menu-item { padding: 14px 25px; display: flex; align-items: center; color: rgba(255,255,255,0.8); text-decoration: none; transition: all 0.3s ease; font-weight: 500; cursor: pointer; }
        .menu-item i { margin-right: 15px; width: 20px; text-align: center; }
        .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.15); color: #fbc02d; border-left: 5px solid #fbc02d; }
        .sidebar-footer { padding: 20px; display: flex; flex-direction: column; gap: 10px; }
        .logout-btn { background: #d32f2f; color: white; padding: 12px; border-radius: 8px; text-decoration: none; font-weight: bold; text-align: center; transition: 0.3s; }
        .main-content { flex: 1; overflow-y: auto; padding: 40px; background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(8px); }
        .content-card { background: rgba(255, 255, 255, 0.96); padding: 30px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #f0f2f5; }
        .header h1 { color: #1a237e; margin: 0; font-size: 24px; }
        .btn-add { background: #22c55e; color: white; border: none; padding: 12px 25px; border-radius: 30px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 10px; transition: 0.3s; box-shadow: 0 4px 15px rgba(34, 197, 94, 0.3); }
        .btn-add:hover { background: #16a34a; transform: translateY(-2px); }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f8fafc; color: #64748b; text-transform: uppercase; font-size: 11px; font-weight: 800; padding: 15px; text-align: left; border-bottom: 2px solid #e2e8f0; }
        td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; color: #334155; font-size: 14px; }
        tr:hover { background-color: #f8fafc; }
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }
        .action-group { display: flex; gap: 8px; }
        .btn-icon { width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; border-radius: 8px; border: none; cursor: pointer; color: white; transition: 0.2s; text-decoration: none; }
        .whatsapp { background: #25d366; }
        .pay-link { background: #673ab7; }
        .delete { background: #ef4444; }
        .receipt { background: #007bff; }
        .modal { display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.7); backdrop-filter: blur(8px); overflow-y: auto; }
        .modal-content { background-color: #ffffff; margin: 30px auto; width: 90%; max-width: 650px; border-radius: 15px; box-shadow: 0 15px 50px rgba(0,0,0,0.5); overflow: hidden; animation: slide-up 0.4s ease-out; border: 1px solid #eee; }
        @keyframes slide-up { from { transform: translateY(100px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 25px; background: #1a237e; color: white; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h3 { margin: 0; font-size: 20px; font-weight: bold; }
        .modal-header span { cursor: pointer; font-size: 28px; line-height: 1; transition: 0.3s; }
        .modal-header span:hover { color: #fbc02d; }
        .modal-body { padding: 30px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; background: #fff; }
        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { font-size: 13px; font-weight: 700; color: #1a237e; }
        .form-group input, .form-group select { padding: 12px; border: 2px solid #e2e8f0; border-radius: 10px; font-size: 14px; color: #333; background: #f8fafc; transition: 0.3s; outline: none; }
        .form-group input:focus { border-color: #1a237e; background: #fff; }
        .modal-footer { padding: 20px 30px; background: #f8fafc; text-align: right; border-top: 1px solid #eee; }
        .btn-submit { background: #1a237e; color: white; border: none; padding: 12px 35px; border-radius: 10px; font-weight: bold; cursor: pointer; font-size: 15px; transition: 0.3s; box-shadow: 0 4px 10px rgba(26, 35, 126, 0.2); }
        .btn-submit:hover { background: #283593; transform: scale(1.02); }
        .error-box { background-color: #ffebee; border: 2px solid #c62828; color: #c62828; padding: 30px; margin: 20px; border-radius: 12px; text-align: center; font-size: 16px; }
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
                dbError = "CRITICAL: StudentDAO not found.";
            }
        }
    %>
    <div class="bg-container"></div>
    <div class="sidebar">
        <div class="sidebar-header"><h2>KODEWALA</h2><p style="font-size: 10px; opacity: 0.7; font-weight: bold;">ACADEMY ADMIN</p></div>
        <div class="sidebar-menu">
            <div class="menu-item active"><i class="fas fa-user-graduate"></i> Admissions</div>
            <div id="addStudentSidebarBtn" class="menu-item"><i class="fas fa-user-plus"></i> Add Student</div>
            <div class="menu-item"><i class="fas fa-tasks"></i> Assignments</div>
            <div class="menu-item"><i class="fas fa-video"></i> Live Classes</div>
            <div class="menu-item"><i class="fas fa-play-circle"></i> Recordings</div>
            <div class="menu-item"><i class="fas fa-trophy"></i> Placements</div>
            <div class="menu-item"><i class="fas fa-cog"></i> Settings</div>
        </div>
        <div class="sidebar-footer">
            <a href="https://wa.me/919900508043" target="_blank" class="footer-btn support-btn"><i class="fab fa-whatsapp"></i> WhatsApp Support</a>
            <a href="login.jsp" class="footer-btn logout-btn"><i class="fas fa-power-off"></i> Logout</a>
        </div>
    </div>
    <div class="main-content">
        <% if (dbError != null) { %>
            <div class="error-box"><h2>FATAL: Application Error</h2><p>Could not load dashboard data.</p><p><strong>Error Details:</strong> <%= dbError %></p></div>
        <% } else { %>
            <div class="content-card">
                <div class="header">
                    <h1>Admissions Management <span style="font-size: 10px; color:#22c55e;">● LIVE</span></h1>
                    <button id="registerStudentHeaderBtn" class="btn-add"><i class="fas fa-plus"></i> Register Student</button>
                </div>
                <table>
                    <thead><tr><th>KA-ID</th><th>Student Details</th><th>Phone</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% if (students != null && !students.isEmpty()) { for (Student student : students) { %>
                        <tr>
                            <td><strong><%= (student.getStudentId() == null || student.getStudentId().equals("PENDING")) ? "WAITING" : student.getStudentId() %></strong></td>
                            <td><div style="font-weight:700;"><%= student.getName() %></div><div style="font-size:11px; opacity:0.7;"><%= student.getEmail() %></div></td>
                            <td><%= student.getPhone() %></td>
                            <td><span class="status-badge status-<%= student.getStatus() != null ? student.getStatus().toLowerCase() : "pending" %>"><%= student.getStatus() %></span></td>
                            <td>
                                <div class="action-group">
                                    <button class="btn-icon pay-link" onclick="sendPaymentLink('<%= student.getPhone() %>', '<%= student.getName() %>', <%= student.getTotalAmount() %>)" title="Send Payment Link"><i class="fas fa-paper-plane"></i></button>
                                    <a href="https://wa.me/91<%= student.getPhone() %>" target="_blank" class="btn-icon whatsapp" title="Chat"><i class="fab fa-whatsapp"></i></a>
                                    <a href="receipt.jsp?studentId=<%= student.getStudentId() %>" target="_blank" class="btn-icon receipt" title="View Receipt"><i class="fas fa-receipt"></i></a>
                                    <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= student.getId() %>"><button type="submit" class="btn-icon delete" title="Delete"><i class="fas fa-trash"></i></button></form>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">No records found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    <div id="registerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>New Student Registration</h3>
                <span id="closeModalBtn" style="cursor:pointer; font-size:28px;">&times;</span>
            </div>
            <form action="<%=request.getContextPath()%>/students" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="register">
                <div class="modal-body">
                    <div class="form-grid">
                        <div class="form-group full-width"><label for="name">Full Name *</label><input type="text" id="name" name="name" required placeholder="e.g., John Doe"></div>
                        <div class="form-group"><label for="phone">Mobile Number *</label><input type="text" id="phone" name="phone" required placeholder="e.g., 9900508043"></div>
                        <div class="form-group"><label for="email">Gmail ID *</label><input type="email" id="email" name="email" required placeholder="e.g., student@gmail.com"></div>
                        <div class="form-group"><label for="qualification">Highest Qualification</label><input type="text" id="qualification" name="qualification" placeholder="e.g., B.Tech, MCA"></div>
                        <div class="form-group"><label for="academic_gap">Academic Gap</label><input type="text" id="academic_gap" name="academic_gap" placeholder="e.g., 1 Year, None"></div>
                        <div class="form-group"><label for="referred_by">Referred By</label><input type="text" id="referred_by" name="referred_by" placeholder="e.g., Friend's Name, Social Media"></div>
                        <div class="form-group"><label for="total_amount">Course Fee (₹)</label><input type="number" id="total_amount" name="total_amount" value="35000"></div>
                        <div class="form-group full-width"><label for="photo">Student Photo</label><input type="file" id="photo" name="photo"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn-submit">Submit & Register</button>
                    <button type="button" id="editBtn" class="btn-submit" style="background-color: #f0ad4e; display: none;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const modal = document.getElementById('registerModal');
            const sidebarBtn = document.getElementById('addStudentSidebarBtn');
            const headerBtn = document.getElementById('registerStudentHeaderBtn');
            const closeBtn = document.getElementById('closeModalBtn');
            function openModal() { if (modal) modal.style.display = 'block'; }
            function closeModal() { if (modal) modal.style.display = 'none'; }
            if (sidebarBtn) sidebarBtn.addEventListener('click', openModal);
            if (headerBtn) headerBtn.addEventListener('click', openModal);
            if (closeBtn) closeBtn.addEventListener('click', closeModal);
            window.addEventListener('click', function(event) { if (event.target == modal) closeModal(); });
        });
        const UPI_ID = "suresh-bishnoi-hdfc@ybl";
        const ADMIN_NAME = "Suresh Bishnoi";
        function sendPaymentLink(phone, name, amount) { /* ... */ }
        let lastHash = '';
        function refreshData() { /* ... */ }
        setInterval(refreshData, 1500);
        refreshData();
    </script>
</body>
</html>