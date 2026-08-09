package com.bank.kodewalabrightfutureacademy.controller;

import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/db-check")
public class DBHealthCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        out.println("--- Database Health Check ---");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                out.println("Result: SUCCESS");
                out.println("Successfully connected to the database.");
            } else {
                out.println("Result: FAILED");
                out.println("Failed to get a database connection, but no exception was thrown.");
            }
        } catch (Exception e) {
            out.println("Result: FAILED");
            out.println("An exception occurred while trying to connect to the database.");
            out.println("\n--- Error Details ---");
            e.printStackTrace(out);
        }
    }
}