package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.model.Student;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/payment-success")
public class PaymentApiServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String phone = request.getParameter("phone");
        String paymentId = request.getParameter("payment_id");

        if (phone == null || paymentId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters.");
            return;
        }

        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");
        if (studentDAO == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database service not available.");
            return;
        }

        try {
            Student student = studentDAO.finalizeRegistration(phone, paymentId);
            if (student != null) {
                response.setContentType("application/json");
                new ObjectMapper().writeValue(response.getOutputStream(), student);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Student not found for the given phone number.");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during registration finalization.", e);
        }
    }
}