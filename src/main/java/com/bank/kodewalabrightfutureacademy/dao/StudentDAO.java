package com.bank.kodewalabrightfutureacademy.dao;

import com.bank.kodewalabrightfutureacademy.model.Student;
import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // ... other methods remain the same ...

    public void addStudent(Student student) throws SQLException {
        String insertSql = "INSERT INTO students (name, phone, email, qualification, academic_gap, payment_method, total_amount, image_url, status, payment_status, is_blocked, balance_amount, admin_message, timestamp, referred_by, registration_date, student_id, batch_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE students SET student_id = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement insertStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBConnection.getConnection();
            System.out.println("[addStudent] Database connection obtained.");
            conn.setAutoCommit(false);
            System.out.println("[addStudent] Auto-commit set to false.");

            insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            
            insertStmt.setString(1, student.getName());
            insertStmt.setString(2, student.getPhone());
            insertStmt.setString(3, student.getEmail());
            insertStmt.setString(4, student.getQualification());
            insertStmt.setString(5, student.getAcademicGap());
            insertStmt.setString(6, student.getPaymentMethod());
            insertStmt.setInt(7, student.getTotalAmount() > 0 ? student.getTotalAmount() : 35000);
            insertStmt.setString(8, student.getImageUrl());
            insertStmt.setString(9, student.getStatus() != null ? student.getStatus() : "Pending");
            insertStmt.setString(10, student.getPaymentStatus() != null ? student.getPaymentStatus() : "Pending");
            insertStmt.setBoolean(11, student.isBlocked());
            insertStmt.setInt(12, student.getBalanceAmount());
            insertStmt.setString(13, student.getAdminMessage());
            insertStmt.setLong(14, System.currentTimeMillis());
            insertStmt.setString(15, student.getReferredBy());
            insertStmt.setLong(16, student.getRegistrationDate() > 0 ? student.getRegistrationDate() : System.currentTimeMillis());
            insertStmt.setString(17, "PENDING");
            insertStmt.setString(18, "PENDING");

            System.out.println("[addStudent] Executing INSERT statement for student: " + student.getName());
            int affectedRows = insertStmt.executeUpdate();
            System.out.println("[addStudent] INSERT statement executed. Rows affected: " + affectedRows);

            if (affectedRows > 0) {
                generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    System.out.println("[addStudent] Generated new student ID: " + newId);
                    String studentId = "KA" + String.format("%03d", newId);
                    
                    updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, studentId);
                    updateStmt.setInt(2, newId);
                    
                    System.out.println("[addStudent] Executing UPDATE statement to set student_id to: " + studentId);
                    updateStmt.executeUpdate();
                    System.out.println("[addStudent] UPDATE statement executed.");
                } else {
                    System.err.println("[addStudent] WARNING: INSERT was successful, but no generated key was returned.");
                }
            } else {
                 System.err.println("[addStudent] WARNING: INSERT statement affected 0 rows.");
            }
            
            System.out.println("[addStudent] Attempting to commit transaction...");
            conn.commit();
            System.out.println("[addStudent] Transaction committed successfully.");
            
        } catch (SQLException e) {
            System.err.println("[addStudent] SQLException occurred! Rolling back transaction.");
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (generatedKeys != null) generatedKeys.close();
            if (insertStmt != null) insertStmt.close();
            if (updateStmt != null) updateStmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    // ... other methods remain the same ...
}