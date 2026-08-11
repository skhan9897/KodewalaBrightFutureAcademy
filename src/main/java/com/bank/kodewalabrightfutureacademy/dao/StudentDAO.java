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

    public Student getStudentByStudentId(String studentId) throws SQLException {
        Student student = null;
        String sql = "SELECT * FROM students WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    student = new Student();
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
                    student.setBlocked(rs.getBoolean("is_blocked"));
                    student.setBalanceAmount(rs.getInt("balance_amount"));
                    student.setAdminMessage(rs.getString("admin_message"));
                    if (hasColumn(rs, "timestamp")) student.setTimestamp(rs.getLong("timestamp"));
                    if (hasColumn(rs, "referred_by")) student.setReferredBy(rs.getString("referred_by"));
                    if (hasColumn(rs, "registration_date")) student.setRegistrationDate(rs.getLong("registration_date"));
                }
            }
        }
        return student;
    }

    public List<Student> getAllStudents() throws SQLException {
        // ... (code remains the same)
        return new ArrayList<>();
    }

    public void addStudent(Student student) throws SQLException {
        // ... (code remains the same)
    }

    public void deleteStudent(int id) throws SQLException {
        // ... (code remains the same)
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
    
    // ... other methods remain the same ...
}