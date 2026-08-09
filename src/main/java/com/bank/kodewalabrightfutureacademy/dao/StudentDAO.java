package com.bank.kodewalabrightfutureacademy.dao;

import com.bank.kodewalabrightfutureacademy.model.Student;
import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY timestamp DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentId(rs.getString("student_id"));
                student.setBatchNumber(rs.getString("batch_number"));
                student.setName(rs.getString("name"));
                student.setPhone(rs.getString("phone"));
                student.setEmail(rs.getString("email"));
                student.setQualification(rs.getString("qualification"));
                student.setAcademicGap(rs.getString("academic_gap"));
                student.setPaymentMethod(rs.getString("payment_method"));
                student.setTotalAmount(rs.getInt("total_amount"));
                student.setImageUrl(rs.getString("image_url"));
                student.setStatus(rs.getString("status"));
                student.setPaymentStatus(rs.getString("payment_status"));
                student.setIsBlocked(rs.getBoolean("is_blocked"));
                student.setBalanceAmount(rs.getInt("balance_amount"));
                student.setAdminMessage(rs.getString("admin_message"));
                student.setTimestamp(rs.getLong("timestamp"));
                students.add(student);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public void addStudent(Student student) {
        String sql = "INSERT INTO students (student_id, batch_number, name, phone, email, qualification, academic_gap, payment_method, total_amount, image_url, status, payment_status, is_blocked, balance_amount, admin_message, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, student.getStudentId());
            stmt.setString(2, student.getBatchNumber());
            stmt.setString(3, student.getName());
            stmt.setString(4, student.getPhone());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getQualification());
            stmt.setString(7, student.getAcademicGap());
            stmt.setString(8, student.getPaymentMethod());
            stmt.setInt(9, student.getTotalAmount());
            stmt.setString(10, student.getImageUrl());
            stmt.setString(11, student.getStatus());
            stmt.setString(12, student.getPaymentStatus());
            stmt.setBoolean(13, student.isIsBlocked());
            stmt.setInt(14, student.getBalanceAmount());
            stmt.setString(15, student.getAdminMessage());
            stmt.setLong(16, System.currentTimeMillis());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
