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
        // This method is crucial for displaying the dashboard.
        // It forwards the request to the JSP, which handles the data fetching and rendering.
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");

        if (studentDAO == null) {
            // ... (error handling remains the same)
            return;
        }

        try {
            if ("register".equals(action)) {
                Student student = new Student();
                student.setName(request.getParameter("name"));
                student.setPhone(request.getParameter("phone"));
                student.setEmail(request.getParameter("email"));
                student.setQualification(request.getParameter("qualification"));
                student.setAcademicGap(request.getParameter("academic_gap"));
                student.setPaymentMethod(request.getParameter("payment_method"));
                student.setTotalAmount(Integer.parseInt(request.getParameter("total_amount")));
                student.setReferredBy(request.getParameter("referred_by"));

                // --- Handle File Upload ---
                Part filePart = request.getPart("photo");
                if (filePart != null) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (fileName != null && !fileName.isEmpty()) {
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, new File(uploadPath + File.separator + fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }
                        student.setImageUrl("uploads/" + fileName);
                    }
                }
                
                studentDAO.addStudent(student);
                response.sendRedirect(request.getContextPath() + "/students");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                studentDAO.deleteStudent(id);
                response.sendRedirect(request.getContextPath() + "/students");
            }
            // ... (other actions) ...
        } catch (SQLException | NumberFormatException e) {
            System.err.println("Exception in StudentServlet doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}