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

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing Database and DAOs...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create Students table if not exists with all required columns
            String createStudentsTable = "CREATE TABLE IF NOT EXISTS students (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "student_id VARCHAR(50), " +
                    "batch_number VARCHAR(50), " +
                    "name VARCHAR(100), " +
                    "phone VARCHAR(20), " +
                    "email VARCHAR(100), " +
                    "qualification VARCHAR(100), " +
                    "academic_gap VARCHAR(50), " +
                    "payment_method VARCHAR(50), " +
                    "total_amount INT, " +
                    "image_url TEXT, " +
                    "status VARCHAR(50) DEFAULT 'Pending', " +
                    "payment_status VARCHAR(50) DEFAULT 'Pending', " +
                    "is_blocked BOOLEAN DEFAULT FALSE, " +
                    "balance_amount INT DEFAULT 0, " +
                    "admin_message TEXT, " +
                    "timestamp BIGINT" +
                    ")";
            stmt.execute(createStudentsTable);

            // Create Placements table if not exists
            String createPlacementsTable = "CREATE TABLE IF NOT EXISTS placements (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100), " +
                    "ctc VARCHAR(20), " +
                    "role VARCHAR(50), " +
                    "education VARCHAR(100), " +
                    "image_url TEXT, " +
                    "is_highest BOOLEAN DEFAULT FALSE, " +
                    "timestamp BIGINT" +
                    ")";
            stmt.execute(createPlacementsTable);

            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
            System.out.println("Database tables checked/created. DAOs initialized.");
            
        } catch (Exception e) {
            System.err.println("Database initialization failed!");
            e.printStackTrace();
            // Still initialize DAOs so app doesn't crash completely
            ServletContext ctx = sce.getServletContext();
            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}
