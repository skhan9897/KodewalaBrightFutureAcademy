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
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .spinner-container {
            position: relative;
            width: 400px;
            height: 400px;
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
            box-shadow: 0 0 25px rgba(251, 192, 45, 0.5);
            /* Logo now spins in the center and pulses */
            animation: logo-spin 8s linear infinite, pulse-border 2s infinite;
        }

        /* Large Transparent Spinning Star */
        .big-star {
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(251, 192, 45, 0.15); /* Transparent Gold/Yellow */
            clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
            animation: star-spin 5s linear infinite;
            z-index: 5;
            filter: drop-shadow(0 0 15px #fbc02d);
        }

        @keyframes star-spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @keyframes logo-spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Pulsing effect for the logo border */
        @keyframes pulse-border {
            0% { box-shadow: 0 0 0 0 rgba(251, 192, 45, 0.7); }
            70% { box-shadow: 0 0 0 20px rgba(251, 192, 45, 0); }
            100% { box-shadow: 0 0 0 0 rgba(251, 192, 45, 0); }
        }
    </style>
</head>
<body>
    <div class="spinner-container">
        <!-- The Large Transparent Spinning Star -->
        <div class="big-star"></div>

        <!-- The Logo spinning in the center -->
        <img src="images/logo.png" class="central-logo" alt="Logo">
    </div>
</body>
</html>
