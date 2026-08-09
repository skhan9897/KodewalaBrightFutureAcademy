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
            background-image: url('images/Dashboard-bg.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 260px;
            background: rgba(26, 35, 126, 0.95);
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.3);
            z-index: 100;
        }

        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        .sidebar-header h2 {
            font-size: 18px;
            margin: 0;
            letter-spacing: 1px;
            color: #fbc02d;
        }

        .sidebar-menu {
            flex: 1;
            margin-top: 20px;
        }

        .menu-item {
            padding: 15px 25px;
            display: flex;
            align-items: center;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: 0.3s;
            cursor: pointer;
        }

        .menu-item i {
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }

        .menu-item:hover, .menu-item.active {
            background: rgba(255,255,255,0.1);
            color: #fbc02d;
            border-left: 4px solid #fbc02d;
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.85);
            padding: 30px;
        }

        .content-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            color: #1a237e;
            margin: 0;
            font-size: 24px;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: #f8f9fa;
            color: #1a237e;
            text-transform: uppercase;
            font-size: 12px;
            font-weight: bold;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }

        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }
        .status-rejected { background: #ffebee; color: #c62828; }

        .btn {
            padding: 6px 10px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 11px;
            font-weight: bold;
            color: white;
            text-decoration: none;
            margin-right: 5px;
        }

        .btn-approve { background-color: #4caf50; }
        .btn-reject { background-color: #ffa000; }
        .btn-delete { background-color: #d32f2f; }
        .btn-whatsapp { background-color: #25d366; }

        .logout-btn {
            display: block;
            text-align: center;
            background: #e53935;
            color: white;
            padding: 10px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>KODEWALA ACADEMY</h2>
            <p style="font-size: 10px; opacity: 0.6;">ADMIN DASHBOARD</p>
        </div>
        <div class="sidebar-menu">
            <a href="#" class="menu-item active">
                <i class="fas fa-users"></i>
                Student Admission
            </a>
            <a href="#" class="menu-item">
                <i class="fas fa-tasks"></i>
                Assignments
            </a>
            <a href="#" class="menu-item">
                <i class="fas fa-video"></i>
                Live Classes
            </a>
            <a href="#" class="menu-item">
                <i class="fas fa-play-circle"></i>
                Recordings
            </a>
            <a href="#" class="menu-item">
                <i class="fas fa-trophy"></i>
                Placements
            </a>
            <a href="#" class="menu-item">
                <i class="fas fa-cog"></i>
                Settings
            </a>
        </div>
        <div class="sidebar-footer">
            <a href="login.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="content-card">
            <div class="header">
                <h1><i class="fas fa-user-graduate"></i> Student Admissions</h1>
                <div class="stats">
                    <span style="background:#1a237e; color:white; padding:5px 15px; border-radius:20px; font-size:12px;">
                        Total Applicants: <%= (request.getAttribute("students") != null) ? ((List)request.getAttribute("students")).size() : 0 %>
                    </span>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Details</th>
                        <th>Phone</th>
                        <th>Plan</th>
                        <th>Status</th>
                        <th>Batch</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Student> students = (List<Student>) request.getAttribute("students");
                        if (students != null && !students.isEmpty()) {
                            for (Student student : students) {
                    %>
                    <tr>
                        <td><strong><%= (student.getStudentId() == null || student.getStudentId().equals("PENDING")) ? "NEW" : student.getStudentId() %></strong></td>
                        <td>
                            <strong><%= student.getName() %></strong><br>
                            <small style="color:#666;"><%= student.getEmail() %></small>
                        </td>
                        <td><%= student.getPhone() %></td>
                        <td><%= student.getPaymentMethod() %></td>
                        <td>
                            <span class="status-badge status-<%= student.getStatus().toLowerCase() %>">
                                <%= student.getStatus() %>
                            </span>
                        </td>
                        <td><%= (student.getBatchNumber() == null || student.getBatchNumber().equals("PENDING")) ? "---" : student.getBatchNumber() %></td>
                        <td>
                            <div style="display:flex;">
                                <% if ("Pending".equals(student.getStatus())) { %>
                                    <form action="students" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="id" value="<%= student.getId() %>">
                                        <button type="submit" class="btn btn-approve" title="Approve"><i class="fas fa-check"></i></button>
                                    </form>
                                    <form action="students" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="reject">
                                        <input type="hidden" name="id" value="<%= student.getId() %>">
                                        <button type="submit" class="btn btn-reject" title="Reject"><i class="fas fa-times"></i></button>
                                    </form>
                                <% } %>
                                <a href="https://wa.me/91<%= student.getPhone() %>" target="_blank" class="btn btn-whatsapp" title="WhatsApp"><i class="fab fa-whatsapp"></i></a>
                                <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= student.getId() %>">
                                    <button type="submit" class="btn btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding:30px; color:#999;">No admissions found.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
