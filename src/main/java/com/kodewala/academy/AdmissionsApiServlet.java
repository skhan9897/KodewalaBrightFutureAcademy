package com.kodewala.academy;

import com.google.gson.Gson;
import com.kodewala.academy.model.Student;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/admissions")
public class AdmissionsApiServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Student> students = FirebaseService.getAllStudents();
            response.getWriter().write(gson.toJson(students));
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("[]");
        }
    }
}
