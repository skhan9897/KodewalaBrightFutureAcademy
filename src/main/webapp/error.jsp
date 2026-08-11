<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f8f8;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        .error-container {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 600px;
            width: 90%;
        }
        h1 {
            color: #d32f2f;
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        p {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .error-details {
            background-color: #ffebee;
            border-left: 5px solid #ef5350;
            padding: 15px;
            margin-top: 20px;
            text-align: left;
            font-family: 'Consolas', 'Monaco', monospace;
            white-space: pre-wrap;
            word-break: break-all;
            font-size: 0.9em;
            color: #c62828;
        }
        a {
            color: #1a237e;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #3f51b5;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Oops! Something went wrong.</h1>
        <p>We encountered an unexpected error while processing your request.</p>
        <p>Please try again later or contact support if the problem persists.</p>

        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="error-details">
                <strong>Error Details:</strong><br>
                <%= errorMessage %>
            </div>
        <% } %>

        <p><a href="<%= request.getContextPath() %>/students">Go back to Dashboard</a></p>
    </div>
</body>
</html>