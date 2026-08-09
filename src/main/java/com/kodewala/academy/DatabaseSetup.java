package com.kodewala.academy;

import java.sql.Connection;
import java.sql.Statement;

public class DatabaseSetup {
    public static void createTables() {
        String sql = "CREATE TABLE IF NOT EXISTS admissions ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "firebase_doc_id VARCHAR(100),"
                + "student_id VARCHAR(20),"
                + "batch_number VARCHAR(20),"
                + "name VARCHAR(100) NOT NULL,"
                + "phone VARCHAR(20) NOT NULL,"
                + "email VARCHAR(100),"
                + "qualification VARCHAR(100),"
                + "academic_gap VARCHAR(50),"
                + "payment_method VARCHAR(50),"
                + "total_amount INT DEFAULT 35000,"
                + "image_url TEXT,"
                + "status VARCHAR(20) DEFAULT 'Pending',"
                + "payment_status VARCHAR(20) DEFAULT 'Pending',"
                + "zoom_link TEXT,"
                + "zoom_recording_url TEXT,"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                + ")";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table 'admissions' created successfully!");
        } catch (Exception e) {
            System.err.println("Error creating table: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
