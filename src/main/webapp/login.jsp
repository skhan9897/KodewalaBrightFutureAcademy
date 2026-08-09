<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('images/login-bg.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .login-container {
            position: relative;
            width: 400px;
            height: 400px;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            box-shadow: 0 0 50px rgba(0,0,0,0.5);
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .login-logo {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 20px;
        }

        .input-group {
            width: 70%;
            margin-bottom: 20px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            background: transparent;
            border: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            color: #fff;
            font-size: 16px;
            text-align: center;
            outline: none;
        }

        input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        button {
            width: 70%;
            padding: 12px;
            background: #23a6d5;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #23d5ab;
        }

        .error-message {
            color: #ffdddd;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <img src="images/logo.png" class="login-logo" alt="Logo">

        <% if ("true".equals(request.getParameter("error"))) { %>
            <p class="error-message">Invalid username or password.</p>
        <% } %>

        <form action="login" method="post" style="width:100%; text-align:center;">
            <div class="input-group" style="margin:auto; width:70%; margin-bottom:20px;">
                <input type="text" id="username" name="username" placeholder="Username" required>
            </div>
            <div class="input-group" style="margin:auto; width:70%; margin-bottom:20px;">
                <input type="password" id="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>