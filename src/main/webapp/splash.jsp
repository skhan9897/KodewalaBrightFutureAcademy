<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <meta http-equiv="refresh" content="4;url=login.jsp">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
            background: radial-gradient(circle, #1a237e, #0d1b3e);
        }

        .spinner-container {
            position: relative;
            width: 300px;
            height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .central-logo {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid #fbc02d; /* Gold/Yellow line around logo */
            padding: 5px;
            background: white;
            z-index: 10;
            box-shadow: 0 0 20px rgba(251, 192, 45, 0.4);
        }

        /* Orbiting and Spinning Star */
        .star-orbit {
            position: absolute;
            width: 100%;
            height: 100%;
            animation: orbit-rotate 4s linear infinite;
        }

        .star {
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 40px;
            height: 40px;
            background: #fbc02d; /* Same color as the logo's border line */
            clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
            animation: star-spin 2s linear infinite;
            box-shadow: 0 0 15px #fbc02d;
        }

        @keyframes orbit-rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @keyframes star-spin {
            from { transform: translateX(-50%) rotate(0deg); }
            to { transform: translateX(-50%) rotate(360deg); }
        }

        /* Pulsing effect for the logo border */
        @keyframes pulse-border {
            0% { box-shadow: 0 0 0 0 rgba(251, 192, 45, 0.7); }
            70% { box-shadow: 0 0 0 15px rgba(251, 192, 45, 0); }
            100% { box-shadow: 0 0 0 0 rgba(251, 192, 45, 0); }
        }

        .central-logo {
            animation: pulse-border 2s infinite;
        }
    </style>
</head>
<body>
    <div class="spinner-container">
        <div class="star-orbit">
            <div class="star"></div>
        </div>
        <img src="images/logo.png" class="central-logo" alt="Logo">
    </div>
</body>
</html>
