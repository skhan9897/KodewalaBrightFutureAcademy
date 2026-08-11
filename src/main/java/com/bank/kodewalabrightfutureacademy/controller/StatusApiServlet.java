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

@WebServlet("/api/status/*")
public class StatusApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing student ID.");
            return;
        }

        String studentId = pathInfo.substring(1);
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");
        
        if (studentDAO == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database service is not available.");
            return;
        }

        response.setContentType("application/json");
        ObjectMapper mapper = new ObjectMapper();

        try {
            Student student = studentDAO.getStudentByStudentId(studentId);
            if (student != null) {
                mapper.writeValue(response.getOutputStream(), student);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                mapper.writeValue(response.getOutputStream(), "{\"error\":\"Student not found\"}");
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in StatusApiServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            mapper.writeValue(response.getOutputStream(), "{\"error\":\"Database error occurred.\"}");
        }
    }
}