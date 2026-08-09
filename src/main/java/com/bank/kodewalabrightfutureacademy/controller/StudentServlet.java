package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.model.Student;
import java.io.IOException;
import java.util.List;
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
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        StudentDAO studentDAO = (StudentDAO) getServletContext().getAttribute("studentDAO");

        if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Generate a simple Student ID like KA01, KA02 based on the DB ID
            String studentId = "KA" + String.format("%03d", id);
            String batchNumber = "BATCH-" + java.time.LocalDate.now().getMonthValue() + java.time.LocalDate.now().getYear();
            
            studentDAO.updateStudentStatus(id, studentId, batchNumber, "Approved");
            response.sendRedirect(request.getContextPath() + "/students");
        } else if ("reject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            studentDAO.updateStudentStatus(id, "REJECTED", "NONE", "Rejected");
            response.sendRedirect(request.getContextPath() + "/students");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            studentDAO.deleteStudent(id);
            response.sendRedirect(request.getContextPath() + "/students");
        } else if ("confirmPayment".equals(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String paymentId = request.getParameter("razorpay_payment_id");
            
            Student student = new Student();
            student.setName(name);
            student.setEmail(email);
            student.setPhone(phone);
            student.setStatus("Pending");
            student.setPaymentMethod("Full Payment (Online)");
            student.setPaymentStatus("Paid - " + paymentId);
            student.setTotalAmount(35000);

            studentDAO.addStudent(student);
            
            response.sendRedirect(request.getContextPath() + "/index.jsp?success=true");
        } else {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            
            request.getRequestDispatcher("/payment.jsp").forward(request, response);
        }
    }
}