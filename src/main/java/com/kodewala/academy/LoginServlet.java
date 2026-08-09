package com.kodewala.academy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String AUTH_ID = "Kodewala1234";
    private static final String AUTH_PASS = "Admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("/admin-web/dashboard");
        } else {
            request.getRequestDispatcher("/WEB-INF/templates/login.html").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputId = request.getParameter("adminId");
        String inputPass = request.getParameter("password");

        if (inputId != null) inputId = inputId.trim();
        if (inputPass != null) inputPass = inputPass.trim();

        if (AUTH_ID.equalsIgnoreCase(inputId) && AUTH_PASS.equals(inputPass)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", AUTH_ID);
            response.sendRedirect("/admin-web/dashboard");
        } else {
            request.setAttribute("error", "Invalid Admin ID or Password!");
            request.getRequestDispatcher("/WEB-INF/templates/login.html").forward(request, response);
        }
    }
}
