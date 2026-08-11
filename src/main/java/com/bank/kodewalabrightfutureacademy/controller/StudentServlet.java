package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.model.Student;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/students")
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
            System.err.println("[StudentServlet] StudentDAO is null!");
            response.sendRedirect(request.getContextPath() + "/login.jsp?db_error=true");
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
                int totalAmount = (amountStr != null && !amountStr.isEmpty()) ? Integer.parseInt(amountStr) : 35000;
                student.setTotalAmount(totalAmount);
                
                student.setStatus("Pending");
                student.setPaymentStatus("Manual Entry");
                
                studentDAO.addStudent(student);
                response.sendRedirect(request.getContextPath() + "/students");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    studentDAO.deleteStudent(Integer.parseInt(idStr));
                }
                response.sendRedirect(request.getContextPath() + "/students");
            }
        } catch (Exception e) {
            System.err.println("[StudentServlet] FATAL: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/students?error=true");
        }
    }
}
