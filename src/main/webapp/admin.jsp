<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Kodewala Academy</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; display: flex; height: 100vh; overflow: hidden; }
        .bg-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab); background-size: 400% 400%; animation: gradientBG 15s ease infinite; z-index: -1; }
        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        .sidebar { width: 260px; background: rgba(26, 35, 126, 0.95); backdrop-filter: blur(10px); color: white; display: flex; flex-direction: column; padding: 20px 0; z-index: 100; }
        .sidebar-header { padding: 0 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .sidebar-header h2 { font-size: 20px; color: #fbc02d; margin: 0; }

        .sidebar-menu { flex: 1; margin-top: 25px; }
        .menu-item { padding: 15px 25px; display: flex; align-items: center; color: white; text-decoration: none; cursor: pointer; transition: 0.3s; }
        .menu-item i { margin-right: 15px; width: 20px; text-align: center; }
        .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.1); color: #fbc02d; border-left: 4px solid #fbc02d; }

        .main-content { flex: 1; overflow-y: auto; padding: 40px; background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(8px); }
        .content-card { background: white; padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { color: #1a237e; margin: 0; font-size: 24px; }

        .btn-add { background: #22c55e; color: white; border: none; padding: 12px 25px; border-radius: 30px; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 10px; }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid #eee; color: #666; font-size: 12px; text-transform: uppercase; }
        td { padding: 15px; border-bottom: 1px solid #f1f1f1; font-size: 14px; }

        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; }
        .status-pending { background: #fff3e0; color: #ef6c00; }
        .status-approved { background: #e8f5e9; color: #2e7d32; }

        .action-group { display: flex; gap: 10px; }
        .btn-icon { width: 34px; height: 34px; border-radius: 8px; border: none; cursor: pointer; color: white; display: flex; align-items: center; justify-content: center; text-decoration: none; }
        .whatsapp { background: #25d366; }
        .pay-link { background: #673ab7; }
        .delete { background: #ef4444; }

        /* Modal */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); }
        .modal-content { background: white; margin: 5% auto; width: 90%; max-width: 600px; border-radius: 15px; overflow: hidden; }
        .modal-header { padding: 20px; background: #1a237e; color: white; display: flex; justify-content: space-between; }
        .modal-body { padding: 30px; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group label { font-size: 12px; font-weight: bold; color: #666; }
        .form-group input { padding: 10px; border: 1px solid #ddd; border-radius: 8px; }
        .modal-footer { padding: 20px; background: #f8fafc; text-align: right; }
        .btn-submit { background: #1a237e; color: white; border: none; padding: 12px 30px; border-radius: 10px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <div class="bg-container"></div>
    <div class="sidebar">
        <div class="sidebar-header"><h2>KODEWALA ACADEMY</h2></div>
        <div class="sidebar-menu">
            <div class="menu-item active"><i class="fas fa-users"></i> Admissions</div>
            <div class="menu-item" onclick="openModal()"><i class="fas fa-user-plus"></i> Add Student</div>
            <a href="login.jsp" class="menu-item" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="main-content">
        <div class="content-card">
            <div class="header">
                <h1>Admission List <span style="font-size: 10px; color: #22c55e;">● LIVE</span></h1>
                <button class="btn-add" onclick="openModal()"><i class="fas fa-plus"></i> Register Student</button>
            </div>
            <table>
                <thead>
                    <tr><th>KA-ID</th><th>Student</th><th>Phone</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody id="student-list">
                    <tr><td colspan="5" style="text-align:center; padding:50px;">Fetching records...</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Registration Modal -->
    <div id="regModal" class="modal">
        <div class="modal-content">
            <div class="modal-header"><h3>Register New Student</h3><span onclick="closeModal()" style="cursor:pointer;">&times;</span></div>
            <form action="students" method="post">
                <input type="hidden" name="action" value="register">
                <div class="modal-body">
                    <div class="form-group"><label>Full Name</label><input type="text" name="name" required></div>
                    <div class="form-group"><label>Phone</label><input type="text" name="phone" required></div>
                    <div class="form-group" style="grid-column: 1/-1;"><label>Email</label><input type="email" name="email" required></div>
                    <div class="form-group"><label>Qualification</label><input type="text" name="qualification"></div>
                    <div class="form-group"><label>Academic Gap</label><input type="text" name="academic_gap"></div>
                    <div class="form-group"><label>Referred By</label><input type="text" name="referred_by"></div>
                    <div class="form-group"><label>Fee (₹)</label><input type="number" name="total_amount" value="35000"></div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn-submit">Submit Registration</button></div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { document.getElementById('regModal').style.display='block'; }
        function closeModal() { document.getElementById('regModal').style.display='none'; }

        function sendPaymentLink(phone, name, amount) {
            const url = `upi://pay?pa=suresh-bishnoi-hdfc@ybl&pn=Suresh%20Bishnoi&am=${amount}&cu=INR&tn=AdmissionFee`;
            const msg = encodeURIComponent(`Hello ${name}! Please pay ₹${amount} for your admission: ${url}`);
            window.open(`https://wa.me/91${phone}?text=${msg}`, '_blank');
        }

        let lastData = '';
        function refresh() {
            fetch('api/admissions').then(r => r.json()).then(data => {
                const current = JSON.stringify(data);
                if (current === lastData) return;
                lastData = current;

                let html = '';
                if(data.length === 0) { html = '<tr><td colspan="5" style="text-align:center; padding:30px;">No students found.</td></tr>'; }
                else {
                    data.forEach(s => {
                        const statusClass = (s.status || 'pending').toLowerCase();
                        html += `<tr>
                            <td><strong>${s.studentId || 'PENDING'}</strong></td>
                            <td><div style="font-weight:bold;">${s.name}</div><div style="font-size:11px; opacity:0.6;">${s.email}</div></td>
                            <td>${s.phone}</td>
                            <td><span class="status-badge status-${statusClass}">${s.status}</span></td>
                            <td>
                                <div class="action-group">
                                    <button class="btn-icon pay-link" onclick="sendPaymentLink('${s.phone}', '${s.name}', ${s.totalAmount || 35000})"><i class="fas fa-paper-plane"></i></button>
                                    <a href="https://wa.me/91${s.phone}" target="_blank" class="btn-icon whatsapp"><i class="fab fa-whatsapp"></i></a>
                                    <form action="students" method="post" style="margin:0;"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${s.id}"><button type="submit" class="btn-icon delete"><i class="fas fa-trash"></i></button></form>
                                </div>
                            </td>
                        </tr>`;
                    });
                }
                document.getElementById('student-list').innerHTML = html;
            }).catch(e => {
                document.getElementById('student-list').innerHTML = '<tr><td colspan="5" style="text-align:center; color:red;">Error connecting to server.</td></tr>';
            });
        }
        setInterval(refresh, 2000);
        refresh();
    </script>
</body>
</html>
