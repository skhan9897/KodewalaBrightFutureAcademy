<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bank.kodewalabrightfutureacademy.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Kodewala Bright Future Academy</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Animated Gradient Background like Splash Screen */
        .bg-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            z-index: -1;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .sidebar {
            width: 260px;
            background: rgba(26, 35, 126, 0.92);
            backdrop-filter: blur(12px);
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            box-shadow: 4px 0 15px rgba(0,0,0,0.3);
            z-index: 100;
        }

        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        .sidebar-header h2 {
            font-size: 20px;
            margin: 0;
            font-weight: 800;
            color: #fbc02d;
            letter-spacing: 1px;
        }

        .sidebar-menu {
            flex: 1;
            margin-top: 25px;
        }

        .menu-item {
            padding: 14px 25px;
            display: flex;
            align-items: center;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .menu-item i {
            margin-right: 15px;
            width: 20px;
            font-size: 18px;
            text-align: center;
        }

        .menu-item:hover, .menu-item.active {
            background: rgba(255,255,255,0.15);
            color: #fbc02d;
            border-left: 5px solid #fbc02d;
        }

        .sidebar-footer {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .footer-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 12px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
            font-size: 14px;
            color: white;
        }

        .logout-btn { background: #d32f2f; }
        .logout-btn:hover { background: #b71c1c; }

        .support-btn { background: #25d366; }
        .support-btn:hover { background: #128c7e; }

        .main-content {
            flex: 1;
            overflow-y: auto;
            padding: 40px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(8px);
        }

        .content-card {
            background: rgba(255, 255, 255, 0.96);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f2f5;
        }

        .header h1 {
            color: #1a237e;
            margin: 0;
            font-size: 26px;
        }

        .stats-badge {
            background: #1a237e;
            color: white;
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: bold;
        }

        table { width: 100%; border-collapse: collapse; }
        th {
            background-color: #f8fafc;
            color: #64748b;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: 800;
            padding: 15px;
            border-bottom: 2px solid #e2e8f0;
        }
        td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; color: #334155; font-size: 14px; }
        tr:hover { background-color: #f8fafc; }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 800;
        }
        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }
        .status-rejected { background: #ffebee; color: #c62828; }

        .action-group { display: flex; gap: 8px; }
        .btn-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            color: white;
            transition: 0.2s;
            text-decoration: none;
        }
        .btn-icon:hover { transform: translateY(-3px); }
        .approve { background: #22c55e; }
        .reject { background: #f59e0b; }
        .delete { background: #ef4444; }
        .whatsapp { background: #25d366; }
    </style>
</head>
<body>
    <div class="bg-container"></div>

    <div class="sidebar">
        <div class="sidebar-header">
            <h2>KODEWALA</h2>
            <p style="font-size: 10px; opacity: 0.7; font-weight: bold;">BRIGHT FUTURE ACADEMY</p>
        </div>
        <div class="sidebar-menu">
            <a href="#" class="menu-item active"><i class="fas fa-user-graduate"></i> Admissions</a>
            <a href="#" class="menu-item"><i class="fas fa-book"></i> Assignments</a>
            <a href="#" class="menu-item"><i class="fas fa-video"></i> Live Session</a>
            <a href="#" class="menu-item"><i class="fas fa-play-circle"></i> Recordings</a>
            <a href="#" class="menu-item"><i class="fas fa-award"></i> Placements</a>
        </div>
        <div class="sidebar-footer">
            <a href="https://wa.me/919897123456" target="_blank" class="footer-btn support-btn">
                <i class="fab fa-whatsapp"></i> WhatsApp Support
            </a>
            <a href="login.jsp" class="footer-btn logout-btn">
                <i class="fas fa-power-off"></i> Logout
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-card">
            <div class="header">
                <h1>Admissions Management</h1>
                <div id="live-indicator" style="font-size: 10px; color: #22c55e; font-weight: bold; margin-left: 10px;">
                    <i class="fas fa-circle"></i> LIVE
                </div>
                <div class="stats-badge">
                    Total Applicants: <span id="total-count"><%= (request.getAttribute("students") != null) ? ((List)request.getAttribute("students")).size() : 0 %></span>
                </div>
            </div>

            <table id="student-table">
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
                <tbody id="student-data-body">
                    <%
                        List<Student> students = (List<Student>) request.getAttribute("students");
                        if (students != null && !students.isEmpty()) {
                            for (Student student : students) {
                                String cleanPhone = student.getPhone().replaceAll("[^0-9]", "");
                                if (!cleanPhone.startsWith("91") && cleanPhone.length() == 10) {
                                    cleanPhone = "91" + cleanPhone;
                                }
                                String waMessage = java.net.URLEncoder.encode("Hello " + student.getName() + ", this is regarding your admission at Kodewala Academy.", "UTF-8");
                    %>
                    <tr>
                        <td><strong><%= (student.getStudentId() == null || student.getStudentId().equals("PENDING")) ? "NEW" : student.getStudentId() %></strong></td>
                        <td>
                            <div style="font-weight: 700; color: #1e293b;"><%= student.getName() %></div>
                            <div style="font-size: 12px; color: #64748b;"><%= student.getEmail() %></div>
                        </td>
                        <td style="font-weight: 600;"><%= student.getPhone() %></td>
                        <td><span style="background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 12px;"><%= student.getPaymentMethod() %></span></td>
                        <td>
                            <span class="status-badge status-<%= student.getStatus().toLowerCase() %>">
                                <%= student.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="action-group">
                                <% if ("Pending".equals(student.getStatus())) { %>
                                    <form action="students" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="id" value="<%= student.getId() %>">
                                        <button type="submit" class="btn-icon approve" title="Approve"><i class="fas fa-check"></i></button>
                                    </form>
                                <% } %>

                                <a href="https://wa.me/<%= cleanPhone %>?text=<%= waMessage %>" target="_blank" class="btn-icon whatsapp" title="Chat with Student">
                                    <i class="fab fa-whatsapp"></i>
                                </a>

                                <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= student.getId() %>">
                                    <button type="submit" class="btn-icon delete" title="Delete"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr><td colspan="6" style="text-align:center; padding:50px; color:#94a3b8;">No records found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        let lastDataHash = '';

        // Smooth Live Refresh without full page reload
        function refreshData() {
            fetch('api/admissions')
                .then(response => response.json())
                .then(data => {
                    const currentHash = JSON.stringify(data);
                    if (currentHash === lastDataHash) return; // Don't re-render if data is same

                    lastDataHash = currentHash;
                    const tbody = document.getElementById('student-data-body');
                    document.getElementById('total-count').innerText = data.length;

                    let html = '';
                    data.forEach(student => {
                        const sid = (student.studentId === null || student.studentId === 'PENDING') ? '<span style="color:#94a3b8">WAITING</span>' : student.studentId;
                        const statusClass = student.status.toLowerCase();

                        html += `<tr>
                            <td><strong>${sid}</strong></td>
                            <td>
                                <div style="font-weight: 700; color: #1e293b;">${student.name}</div>
                                <div style="font-size: 12px; color: #64748b;">${student.email}</div>
                            </td>
                            <td style="font-weight: 600;">${student.phone}</td>
                            <td><span style="background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-size: 12px;">${student.paymentMethod}</span></td>
                            <td>
                                <span class="status-badge status-${statusClass}">${student.status}</span>
                                <div style="font-size: 10px; margin-top: 4px; color: #64748b;">${student.paymentStatus}</div>
                            </td>
                            <td>
                                <div class="action-group">
                                    <a href="https://wa.me/91${student.phone}" target="_blank" class="btn-icon whatsapp"><i class="fab fa-whatsapp"></i></a>
                                    <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${student.id}">
                                        <button type="submit" class="btn-icon delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>`;
                    });
                    tbody.innerHTML = html;
                });
        }

        // Refresh every 1 second for "Instant" feel
        setInterval(refreshData, 1000);
        refreshData();
    </script>
</body>
</html>
