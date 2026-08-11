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

        .sidebar-menu { flex: 1; margin-top: 25px; overflow-y: auto; }
        .menu-item { padding: 14px 25px; display: flex; align-items: center; color: rgba(255,255,255,0.8); text-decoration: none; transition: all 0.3s ease; font-weight: 500; cursor: pointer; }
        .menu-item i { margin-right: 15px; width: 20px; text-align: center; }
        .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.15); color: #fbc02d; border-left: 4px solid #fbc02d; }

        .sidebar-footer { padding: 20px; display: flex; flex-direction: column; gap: 10px; }
        .logout-btn { background: #d32f2f; color: white; padding: 12px; border-radius: 8px; text-decoration: none; font-weight: bold; text-align: center; transition: 0.3s; }
        .logout-btn:hover { background: #b71c1c; }

        .main-content { flex: 1; overflow-y: auto; padding: 40px; background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(8px); }
        .content-card { background: rgba(255, 255, 255, 0.96); padding: 30px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2); }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #f0f2f5; }
        .header h1 { color: #1a237e; margin: 0; font-size: 24px; }

        .btn-add { background: #22c55e; color: white; border: none; padding: 10px 20px; border-radius: 30px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.3s; }
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
        .btn-icon:hover { transform: translateY(-3px); }
        .whatsapp { background: #25d366; }
        .pay-link { background: #673ab7; }
        .delete { background: #ef4444; }

        /* Modal Styling */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.6); backdrop-filter: blur(5px); overflow-y: auto; }
        .modal-content { background-color: #fff; margin: 2% auto; width: 90%; max-width: 650px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); overflow: hidden; animation: slide-up 0.4s ease; }
        @keyframes slide-up { from { transform: translateY(100px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px; background: #1a237e; color: white; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h3 { margin: 0; }
        .modal-body { padding: 25px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { font-size: 12px; font-weight: bold; color: #64748b; }
        .form-group input, .form-group select { padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .modal-footer { padding: 15px 25px; background: #f8fafc; text-align: right; border-top: 1px solid #eee; }
        .btn-submit { background: #1a237e; color: white; border: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .btn-submit:hover { background: #283593; }
    </style>
</head>
<body>
    <div class="bg-container"></div>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>KODEWALA</h2>
            <p style="font-size: 10px; opacity: 0.7; font-weight: bold;">ACADEMY ADMIN</p>
        </div>
        <div class="sidebar-menu">
            <div class="menu-item active"><i class="fas fa-user-graduate"></i> Admissions</div>
            <div class="menu-item"><i class="fas fa-tasks"></i> Assignments</div>
            <div class="menu-item"><i class="fas fa-video"></i> Live Classes</div>
            <div class="menu-item"><i class="fas fa-play-circle"></i> Recordings</div>
            <div class="menu-item" onclick="openModal()"><i class="fas fa-user-plus"></i> Add Student</div>
            <div class="menu-item"><i class="fas fa-trophy"></i> Placements</div>
            <div class="menu-item"><i class="fas fa-cog"></i> Settings</div>
        </div>
        <div class="sidebar-footer">
            <a href="login.jsp" class="logout-btn"><i class="fas fa-power-off"></i> Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="content-card">
            <div class="header">
                <h1>Admissions Management <span style="font-size: 10px; color:#22c55e;">● LIVE</span></h1>
                <button class="btn-add" onclick="openModal()">
                    <i class="fas fa-plus"></i> Register Student
                </button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>KA-ID</th>
                        <th>Student Details</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="student-data-body">
                    <tr><td colspan="5" style="text-align:center; padding:50px;">Loading student records...</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Student Modal -->
    <div id="registerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>New Student Registration</h3>
                <span style="cursor:pointer; font-size:24px;" onclick="closeModal()">&times;</span>
            </div>
            <form action="students" method="post">
                <input type="hidden" name="action" value="register">
                <div class="modal-body">
                    <div class="form-group"><label>Full Name</label><input type="text" name="name" required placeholder="Full Name"></div>
                    <div class="form-group"><label>Phone Number</label><input type="text" name="phone" required placeholder="Phone Number"></div>
                    <div class="form-group full-width"><label>Email Address</label><input type="email" name="email" required placeholder="email@example.com"></div>
                    <div class="form-group"><label>Highest Qualification</label><input type="text" name="qualification" placeholder="B.Tech, MBA, etc."></div>
                    <div class="form-group"><label>Academic Gap (Years)</label><input type="text" name="academic_gap" placeholder="e.g. 1 Year"></div>
                    <div class="form-group"><label>Total Amount (₹)</label><input type="number" name="total_amount" value="35000"></div>
                    <div class="form-group"><label>Referred By</label><input type="text" name="referred_by" placeholder="Referred Person Name"></div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn-submit">Register Student</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const UPI_ID = "suresh-bishnoi-hdfc@ybl";
        const ADMIN_NAME = "Suresh Bishnoi";

        function openModal() { document.getElementById('registerModal').style.display = 'block'; }
        function closeModal() { document.getElementById('registerModal').style.display = 'none'; }

        function sendPaymentLink(phone, name, amount) {
            const upiUrl = `upi://pay?pa=${UPI_ID}&pn=${encodeURIComponent(ADMIN_NAME)}&am=${amount}&cu=INR&tn=AdmissionFee`;
            const msg = encodeURIComponent(`Hello ${name}! Please complete your admission payment of ₹${amount} at Kodewala Academy using this link: ${upiUrl}`);
            window.open(`https://wa.me/91${phone}?text=${msg}`, '_blank');
        }

        let lastDataHash = '';
        function refreshData() {
            fetch('<%=request.getContextPath()%>/api/admissions')
                .then(r => r.json())
                .then(data => {
                    const currentHash = JSON.stringify(data);
                    if (currentHash === lastDataHash) return;
                    lastDataHash = currentHash;

                    const tbody = document.getElementById('student-data-body');
                    let html = '';

                    if(data.length === 0) {
                        html = '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">No records found.</td></tr>';
                    } else {
                        data.forEach(s => {
                            const statusClass = (s.status || 'pending').toLowerCase();
                            const amount = s.totalAmount || 35000;
                            html += `<tr>
                                <td><strong>${s.studentId || 'WAITING'}</strong></td>
                                <td>
                                    <div style="font-weight: 700; color: #1e293b;">${s.name}</div>
                                    <div style="font-size: 11px; color: #64748b;">${s.email}</div>
                                </td>
                                <td>${s.phone}</td>
                                <td><span class="status-badge status-${statusClass}">${s.status}</span></td>
                                <td>
                                    <div class="action-group">
                                        <button class="btn-icon pay-link" onclick="sendPaymentLink('${s.phone}', '${s.name}', ${amount})" title="Send Payment Link"><i class="fas fa-paper-plane"></i></button>
                                        <a href="https://wa.me/91${s.phone}" target="_blank" class="btn-icon whatsapp" title="WhatsApp Chat"><i class="fab fa-whatsapp"></i></a>
                                        <form action="students" method="post" style="margin:0;" onsubmit="return confirm('Delete permanently?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.id}">
                                            <button type="submit" class="btn-icon delete" title="Delete"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>`;
                        });
                    }
                    tbody.innerHTML = html;
                }).catch(e => console.error("Sync Error:", e));
        }

        setInterval(refreshData, 1000);
        refreshData();
    </script>
</body>
</html>
