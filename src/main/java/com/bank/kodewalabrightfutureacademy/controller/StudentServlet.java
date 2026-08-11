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
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/students")
@MultipartConfig
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("\n--- [StudentServlet] NEW POST REQUEST RECEIVED ---");
        System.out.println("Request Content-Type: " + request.getContentType());

        String action = request.getParameter("action");
        System.out.println("Action Parameter: " + action);

        // Log all parameters for debugging
        String parameters = request.getParameterMap().entrySet().stream()
            .map(e -> e.getKey() + " = " + String.join(", ", e.getValue()))
            .collect(Collectors.joining("\n"));
        System.out.println("--- All Request Parameters ---\n" + parameters + "\n------------------------------");

        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");
        if (studentDAO == null) {
            System.err.println("FATAL: StudentDAO is null. DB connection likely failed at startup.");
            request.setAttribute("errorMessage", "Database service is not available.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
                student.setReferredBy(request.getParameter("referred_by"));
                
                String amountStr = request.getParameter("total_amount");
                student.setTotalAmount((amountStr != null && !amountStr.isEmpty()) ? Integer.parseInt(amountStr) : 0);

                System.out.println("Processing registration for: " + student.getName());

                Part filePart = request.getPart("photo");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    System.out.println("File part 'photo' found. Filename: " + fileName + ", Size: " + filePart.getSize());
                    
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, new File(uploadDir, fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        student.setImageUrl("uploads/" + fileName);
                        System.out.println("File successfully saved to: " + uploadPath + File.separator + fileName);
                    }
                } else {
                    System.out.println("No file part named 'photo' found or file is empty.");
                }
                
                System.out.println("Calling studentDAO.addStudent()...");
                studentDAO.addStudent(student);
                System.out.println("DAO call complete. Redirecting to dashboard.");
                
                response.sendRedirect(request.getContextPath() + "/students");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                studentDAO.deleteStudent(id);
                response.sendRedirect(request.getContextPath() + "/students");
            } else {
                System.out.println("No valid action found. Redirecting to dashboard.");
                response.sendRedirect(request.getContextPath() + "/students");
            }
        } catch (Exception e) {
            System.err.println("FATAL ERROR in StudentServlet doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An operation failed: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}