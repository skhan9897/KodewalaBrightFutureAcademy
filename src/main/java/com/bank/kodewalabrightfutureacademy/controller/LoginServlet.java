package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check for database connection error first
        if (getServletContext().getAttribute("dbConnectionError") != null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?db_error=true");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        UserDAO userDAO = (UserDAO) getServletContext().getAttribute("userDAO");

        if (("kodewala123".equals(username) && "Admin123".equals(password)) || 
            (userDAO != null && userDAO.isValidUser(username, password))) {

            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect(request.getContextPath() + "/students");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=true");
        }
    }
}