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
            width: 300px;
            height: 300px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .central-logo {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            animation: spin-in-place 10s linear infinite;
            z-index: 10;
        }

        @keyframes spin-in-place {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* A single, star-shaped object */
        .star {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 50px;
            height: 50px;
            background: gold; /* A beautiful gold color for the star */
            /* Using clip-path to create a perfect 5-point star shape */
            clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
            animation: single-orbit 5s linear infinite;
        }

        @keyframes single-orbit {
            from {
                transform: rotate(0deg) translateX(140px) rotate(0deg);
            }
            to {
                transform: rotate(360deg) translateX(140px) rotate(-360deg);
            }
        }
    </style>
</head>
<body>
    <div class="spinner-container">
        <img src="images/logo.png" class="central-logo" alt="Logo">

        <!-- This div is now a star shape -->
        <div class="star"></div>
    </div>
</body>
</html>