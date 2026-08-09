package com.kodewala.academy;

import com.google.gson.Gson;
import com.kodewala.academy.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/api/register")
public class StudentApiServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        // Ensure the database table exists on startup.
        DatabaseSetup.createTables();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            BufferedReader reader = request.getReader();
            Student student = gson.fromJson(reader, Student.class);

            String sql = "INSERT INTO admissions (name, phone, email, qualification, payment_method, image_url) VALUES (?, ?, ?, ?, ?, ?)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, student.getName());
                pstmt.setString(2, student.getPhone());
                pstmt.setString(3, student.getEmail());
                pstmt.setString(4, student.getQualification());
                pstmt.setString(5, student.getPaymentMethod());
                pstmt.setString(6, student.getImageUrl());

                pstmt.executeUpdate();
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\":\"success\", \"message\":\"Registered successfully.\"}");

            } catch (SQLException e) {
                throw new ServletException("Database error during registration.", e);
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
