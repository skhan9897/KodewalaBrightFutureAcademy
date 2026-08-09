<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Payment</title>
</head>
<body>
    <h1>Confirm Your Registration</h1>
    <p>Please confirm the payment to complete your registration.</p>

    <form action="students" method="post">
        <input type="hidden" name="action" value="confirmPayment">
        <input type="hidden" name="name" value="<%= request.getAttribute("name") %>">
        <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
        <input type="hidden" name="phone" value="<%= request.getAttribute("phone") %>">
        <button type="submit">Pay Now</button>
    </form>
</body>
</html>