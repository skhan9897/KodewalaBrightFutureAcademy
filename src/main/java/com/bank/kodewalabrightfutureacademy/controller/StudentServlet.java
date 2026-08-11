package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.model.Student;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/students")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");

        if (studentDAO == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?db_error=true");
            return;
        }

        try {
            if ("register".equals(action)) {
                // ... (register logic remains the same)
                
            } else if ("delete".equals(action)) {
                System.out.println("[StudentServlet] Processing 'delete' action.");
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    System.out.println("[StudentServlet] Attempting to delete student with ID: " + id);
                    studentDAO.deleteStudent(id);
                    System.out.println("[StudentServlet] studentDAO.deleteStudent() called successfully.");
                } catch (NumberFormatException e) {
                    System.err.println("[ERROR] Invalid ID format for delete action: " + request.getParameter("id"));
                }
                response.sendRedirect(request.getContextPath() + "/students");
            }
            // ... (other actions) ...
        } catch (Exception e) {
            System.err.println("[StudentServlet] FATAL Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during the operation: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}