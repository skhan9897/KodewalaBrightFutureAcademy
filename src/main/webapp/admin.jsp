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
        body { font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; height: 100vh; overflow: hidden; }
        .bg-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab); background-size: 400% 400%; animation: gradientBG 15s ease infinite; z-index: -1; }
        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        .sidebar { width: 280px; background: rgba(26, 35, 126, 0.92); backdrop-filter: blur(12px); color: white; display: flex; flex-direction: column; padding: 20px 0; box-shadow: 4px 0 15px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .sidebar-header h2 { font-size: 20px; margin: 0; font-weight: 800; color: #fbc02d; }

        .sidebar-menu { flex: 1; margin-top: 25px; }
        .menu-item { padding: 14px 25px; display: flex; align-items: center; color: rgba(255,255,255,0.8); text-decoration: none; transition: 0.3s; cursor: pointer; }
        .menu-item i { margin-right: 15px; width: 20px; text-align: center; }
        .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.15); color: #fbc02d; border-left: 5px solid #fbc02d; }

        .quick-pay { padding: 15px; background: rgba(0,0,0,0.2); margin: 10px; border-radius: 10px; }
        .quick-pay h4 { margin: 0 0 10px; font-size: 11px; color: #fbc02d; text-transform: uppercase; }
        .quick-pay input { width: 100%; padding: 8px; margin-bottom: 8px; border-radius: 5px; border: none; font-size: 12px; box-sizing: border-box; }
        .pay-link-btn { background: #25d366; color: white; width: 100%; border: none; padding: 10px; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 12px; }

        .main-content { flex: 1; overflow-y: auto; padding: 40px; background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(8px); }
        .content-card { background: rgba(255, 255, 255, 0.96); padding: 30px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2); }

        table { width: 100%; border-collapse: collapse; }
        th { background-color: #f8fafc; color: #64748b; text-transform: uppercase; font-size: 11px; font-weight: 800; padding: 15px; text-align: left; border-bottom: 2px solid #e2e8f0; }
        td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 14px; color: #334155; }

        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }

        .action-group { display: flex; gap: 8px; }
        .btn-icon { width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; border-radius: 8px; border: none; cursor: pointer; color: white; transition: 0.2s; text-decoration: none; }
        .approve { background: #22c55e; }
        .whatsapp { background: #25d366; }
        .pay-link { background: #673ab7; }
        .delete { background: #ef4444; }

        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.6); backdrop-filter: blur(5px); }
        .modal-content { background-color: #fff; margin: 5% auto; width: 90%; max-width: 600px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); overflow: hidden; }
        .modal-header { padding: 20px; background: #1a237e; color: white; display: flex; justify-content: space-between; align-items: center; }
        .modal-body { padding: 25px; display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group label { font-size: 12px; font-weight: bold; color: #64748b; }
        .form-group input { padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        .modal-footer { padding: 15px; background: #f8fafc; text-align: right; }
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
            <div class="menu-item active"><i class="fas fa-user-graduate"></i> Admissions</div>
            <div class="menu-item" onclick="document.getElementById('registerModal').style.display='block'">
                <i class="fas fa-user-plus"></i> New Student
            </div>

            <div class="quick-pay">
                <h4><i class="fas fa-bolt"></i> Quick Pay Link</h4>
                <input type="text" id="quick-phone" placeholder="Student Phone">
                <input type="number" id="quick-amount" placeholder="Amount (₹)" value="35000">
                <button class="pay-link-btn" onclick="sendQuickLink()">
                    <i class="fab fa-whatsapp"></i> Send Link
                </button>
            </div>
        </div>
        <div class="sidebar-footer" style="padding: 20px; border-top: 1px solid rgba(255,255,255,0.1);">
            <a href="login.jsp" style="color:white; text-decoration:none; font-weight:bold;"><i class="fas fa-power-off"></i> Logout</a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:25px;">
                <h1 style="color:#1a237e; font-size: 24px;">Student Admissions <span style="font-size: 10px; color:#22c55e;">● LIVE</span></h1>
                <div style="background:#1a237e; color:white; padding:8px 20px; border-radius:30px; font-size:13px; font-weight:bold;">
                    Total: <span id="total-count">0</span>
                </div>
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
                <tbody id="student-data-body"></tbody>
            </table>
        </div>
    </div>

    <!-- Registration Modal -->
    <div id="registerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Register Student</h3>
                <span style="cursor:pointer; font-size:24px;" onclick="document.getElementById('registerModal').style.display='none'">&times;</span>
            </div>
            <form action="students" method="post">
                <input type="hidden" name="action" value="register">
                <div class="modal-body">
                    <div class="form-group"><label>Full Name</label><input type="text" name="name" required></div>
                    <div class="form-group"><label>Phone</label><input type="text" name="phone" required></div>
                    <div class="form-group" style="grid-column: 1/-1;"><label>Email</label><input type="email" name="email" required></div>
                    <div class="form-group"><label>Qualification</label><input type="text" name="qualification"></div>
                    <div class="form-group"><label>Amount</label><input type="number" name="total_amount" value="35000"></div>
                </div>
                <div class="modal-footer">
                    <button type="submit" style="background:#1a237e; color:white; border:none; padding:10px 20px; border-radius:5px; cursor:pointer; font-weight:bold;">Submit</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const UPI_ID = "suresh-bishnoi-hdfc@ybl";
        const ADMIN_NAME = "Suresh Bishnoi";

        function sendQuickLink() {
            const phone = document.getElementById('quick-phone').value;
            const amount = document.getElementById('quick-amount').value;
            if(!phone) return alert('Enter phone number');
            const upiUrl = `upi://pay?pa=${UPI_ID}&pn=${encodeURIComponent(ADMIN_NAME)}&am=${amount}&cu=INR&tn=CourseAdmission`;
            const msg = encodeURIComponent(`Greetings from Kodewala Academy! Please complete your admission fee payment of ₹${amount} using this secure link: ${upiUrl}`);
            window.open(`https://wa.me/91${phone}?text=${msg}`, '_blank');
        }

        function sendDirectLink(phone, name, amount) {
            const upiUrl = `upi://pay?pa=${UPI_ID}&pn=${encodeURIComponent(ADMIN_NAME)}&am=${amount}&cu=INR&tn=AdmissionFee`;
            const msg = encodeURIComponent(`Hello ${name}! Kindly pay ₹${amount} for your admission at Kodewala Academy using this link: ${upiUrl}`);
            window.open(`https://wa.me/91${phone}?text=${msg}`, '_blank');
        }

        let lastHash = '';
        function refresh() {
            fetch('api/admissions').then(r => r.json()).then(data => {
                const currentHash = JSON.stringify(data);
                if (currentHash === lastHash) return;
                lastHash = currentHash;

                document.getElementById('total-count').innerText = data.length;
                let html = '';
                data.forEach(s => {
                    const statusClass = (s.status || 'pending').toLowerCase();
                    html += `<tr>
                        <td><strong>${s.studentId || 'WAITING'}</strong></td>
                        <td><div style="font-weight:700;">${s.name}</div><div style="font-size:11px; opacity:0.7;">${s.email}</div></td>
                        <td>${s.phone}</td>
                        <td><span class="status-badge status-${statusClass}">${s.status}</span></td>
                        <td>
                            <div class="action-group">
                                <button class="btn-icon pay-link" onclick="sendDirectLink('${s.phone}', '${s.name}', ${s.totalAmount || 35000})"><i class="fas fa-paper-plane"></i></button>
                                <a href="https://wa.me/91${s.phone}" target="_blank" class="btn-icon whatsapp"><i class="fab fa-whatsapp"></i></a>
                                <form action="students" method="post" style="margin:0;"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${s.id}"><button type="submit" class="btn-icon delete"><i class="fas fa-trash"></i></button></form>
                            </div>
                        </td>
                    </tr>`;
                });
                document.getElementById('student-data-body').innerHTML = html;
            });
        }
        setInterval(refresh, 1000);
        refresh();
    </script>
</body>
</html>
