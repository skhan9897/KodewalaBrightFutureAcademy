package com.bank.kodewalabrightfutureacademy.listener;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.dao.UserDAO;
import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing Database and DAOs...");
        ServletContext ctx = sce.getServletContext();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // --- Schema Migration for 'students' table ---
            String createStudentsTable = "CREATE TABLE IF NOT EXISTS students (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100), " +
                    "phone VARCHAR(20), " +
                    "email VARCHAR(100)" +
                    ")";
            stmt.execute(createStudentsTable);

            // Get existing columns
            List<String> existingColumns = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery("SELECT * FROM students LIMIT 1")) {
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                    existingColumns.add(rs.getMetaData().getColumnName(i).toLowerCase());
                }
            }

            // Add missing columns one by one
            if (!existingColumns.contains("student_id")) stmt.executeUpdate("ALTER TABLE students ADD student_id VARCHAR(50)");
            if (!existingColumns.contains("batch_number")) stmt.executeUpdate("ALTER TABLE students ADD batch_number VARCHAR(50)");
            if (!existingColumns.contains("qualification")) stmt.executeUpdate("ALTER TABLE students ADD qualification VARCHAR(100)");
            if (!existingColumns.contains("academic_gap")) stmt.executeUpdate("ALTER TABLE students ADD academic_gap VARCHAR(50)");
            if (!existingColumns.contains("payment_method")) stmt.executeUpdate("ALTER TABLE students ADD payment_method VARCHAR(50)");
            if (!existingColumns.contains("total_amount")) stmt.executeUpdate("ALTER TABLE students ADD total_amount INT");
            if (!existingColumns.contains("image_url")) stmt.executeUpdate("ALTER TABLE students ADD image_url TEXT");
            if (!existingColumns.contains("status")) stmt.executeUpdate("ALTER TABLE students ADD status VARCHAR(50) DEFAULT 'Pending'");
            if (!existingColumns.contains("payment_status")) stmt.executeUpdate("ALTER TABLE students ADD payment_status VARCHAR(50) DEFAULT 'Pending'");
            if (!existingColumns.contains("is_blocked")) stmt.executeUpdate("ALTER TABLE students ADD is_blocked BOOLEAN DEFAULT FALSE");
            if (!existingColumns.contains("balance_amount")) stmt.executeUpdate("ALTER TABLE students ADD balance_amount INT DEFAULT 0");
            if (!existingColumns.contains("admin_message")) stmt.executeUpdate("ALTER TABLE students ADD admin_message TEXT");
            if (!existingColumns.contains("timestamp")) stmt.executeUpdate("ALTER TABLE students ADD timestamp BIGINT");
            if (!existingColumns.contains("referred_by")) stmt.executeUpdate("ALTER TABLE students ADD referred_by VARCHAR(100)");
            if (!existingColumns.contains("registration_date")) stmt.executeUpdate("ALTER TABLE students ADD registration_date BIGINT");

            System.out.println("Student table schema is up to date.");

            // --- Schema Migration for 'placements' table ---
            String createPlacementsTable = "CREATE TABLE IF NOT EXISTS placements (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(100)" +
                    ")";
            stmt.execute(createPlacementsTable);
            // You can add similar ALTER TABLE logic for the placements table if needed

            ctx.setAttribute("studentDAO", new StudentDAO());
            ctx.setAttribute("userDAO", new UserDAO());
            System.out.println("Database tables checked/created. DAOs initialized.");
            
        } catch (Exception e) {
            System.err.println("FATAL: Database initialization failed!");
            e.printStackTrace();
            ctx.setAttribute("dbConnectionError", "Failed to connect to the database: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}