<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Secure Payment | Kodewala Academy</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .payment-card {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 400px;
            width: 90%;
        }
        h2 { color: #1a237e; margin-bottom: 10px; }
        p { color: #666; margin-bottom: 30px; }
        .amount { font-size: 32px; font-weight: bold; color: #333; margin-bottom: 20px; }
        .pay-btn {
            background: #23a6d5;
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 30px;
            cursor: pointer;
            transition: 0.3s;
            width: 100%;
        }
        .pay-btn:hover { background: #1a237e; transform: translateY(-2px); }
    </style>
</head>
<body>
    <div class="payment-card">
        <img src="images/logo.png" style="width: 80px; margin-bottom: 20px;" alt="Logo">
        <h2>Complete Registration</h2>
        <p>You are almost there! Please complete the payment to secure your seat.</p>

        <div class="amount">₹ 35,000</div>

        <button id="rzp-button1" class="pay-btn">PAY NOW</button>
    </div>

    <form id="paymentForm" action="students" method="post">
        <input type="hidden" name="action" value="confirmPayment">
        <input type="hidden" name="name" value="<%= request.getAttribute("name") %>">
        <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
        <input type="hidden" name="phone" value="<%= request.getAttribute("phone") %>">
        <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
    </form>

    <script>
    var options = {
        "key": "rzp_test_YOUR_KEY_HERE", // अपनी Razorpay Key यहाँ डालें
        "amount": "3500000", // पैसे पैसों में (35000 * 100)
        "currency": "INR",
        "name": "Kodewala Academy",
        "description": "Course Admission Fee",
        "image": "images/logo.png",
        "handler": function (response){
            document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
            document.getElementById('paymentForm').submit();
        },
        "prefill": {
            "name": "<%= request.getAttribute("name") %>",
            "email": "<%= request.getAttribute("email") %>",
            "contact": "<%= request.getAttribute("phone") %>"
        },
        "theme": { "color": "#1a237e" }
    };
    var rzp1 = new Razorpay(options);
    document.getElementById('rzp-button1').onclick = function(e){
        rzp1.open();
        e.preventDefault();
    }
    </script>
</body>
</html>
