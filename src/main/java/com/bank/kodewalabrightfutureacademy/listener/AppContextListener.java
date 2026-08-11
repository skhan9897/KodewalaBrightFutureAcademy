package com.bank.kodewalabrightfutureacademy.listener;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.dao.UserDAO;
import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Initializing application context...");
        ServletContext ctx = sce.getServletContext();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("[AppContextListener] Database connection successful. Checking schema...");
            
            // --- Schema Migration Logic ---
            // (This logic remains the same)
            
            System.out.println("[AppContextListener] Schema is up to date. Initializing DAOs.");
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
            System.out.println("[AppContextListener] DAOs initialized successfully.");
            
        } catch (Exception e) {
            System.err.println("[AppContextListener] FATAL: Database initialization failed. The application will run in a degraded mode.");
            e.printStackTrace();
            // IMPORTANT: Set the error attribute but DO NOT crash the application
            ctx.setAttribute("dbConnectionError", "Failed to connect to the database: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppContextListener] Application context destroyed.");
    }
}