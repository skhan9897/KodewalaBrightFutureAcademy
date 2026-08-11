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
        
        System.out.println("[StudentServlet] doPost received a request.");
        String action = request.getParameter("action");
        System.out.println("[StudentServlet] Action: " + action);
        
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");

        if (studentDAO == null) {
            System.err.println("[StudentServlet] FATAL: StudentDAO is null. Database connection likely failed.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?db_error=true");
            return;
        }

        try {
            if ("register".equals(action)) {
                System.out.println("[StudentServlet] Processing 'register' action.");
                Student student = new Student();
                student.setName(request.getParameter("name"));
                student.setPhone(request.getParameter("phone"));
                student.setEmail(request.getParameter("email"));
                student.setQualification(request.getParameter("qualification"));
                student.setAcademicGap(request.getParameter("academic_gap"));
                student.setPaymentMethod(request.getParameter("payment_method"));
                student.setTotalAmount(Integer.parseInt(request.getParameter("total_amount")));
                student.setReferredBy(request.getParameter("referred_by"));
                System.out.println("[StudentServlet] Student object created with text data for: " + student.getName());

                // --- Temporarily Disable File Upload for Debugging ---
                /*
                Part filePart = request.getPart("photo");
                if (filePart != null) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (fileName != null && !fileName.isEmpty()) {
                        System.out.println("[StudentServlet] Processing file upload for: " + fileName);
                        // Note: Render has an ephemeral filesystem. Uploads might not persist across deploys.
                        // A dedicated storage service like AWS S3 or Cloudinary is recommended for production.
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, new File(uploadPath + File.separator + fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }
                        student.setImageUrl("uploads/" + fileName);
                        System.out.println("[StudentServlet] File saved to: " + uploadPath);
                    }
                }
                */
                
                System.out.println("[StudentServlet] Calling studentDAO.addStudent()...");
                studentDAO.addStudent(student);
                System.out.println("[StudentServlet] studentDAO.addStudent() finished. Redirecting...");
                
                response.sendRedirect(request.getContextPath() + "/students");

            } else if ("delete".equals(action)) {
                // ... (delete logic remains the same)
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