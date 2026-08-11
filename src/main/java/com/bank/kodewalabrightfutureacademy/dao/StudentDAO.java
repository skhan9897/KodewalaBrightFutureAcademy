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

    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
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
        student.setBlocked(rs.getBoolean("is_blocked"));
        student.setBalanceAmount(rs.getInt("balance_amount"));
        student.setAdminMessage(rs.getString("admin_message"));
        if (hasColumn(rs, "timestamp")) student.setTimestamp(rs.getLong("timestamp"));
        if (hasColumn(rs, "referred_by")) student.setReferredBy(rs.getString("referred_by"));
        if (hasColumn(rs, "registration_date")) student.setRegistrationDate(rs.getLong("registration_date"));
        return student;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                students.add(extractStudentFromResultSet(rs));
            }
        }
        return students;
    }

    public Student getStudentById(int id) throws SQLException {
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractStudentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public Student getStudentByStudentId(String studentId) throws SQLException {
        String sql = "SELECT * FROM students WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractStudentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public void addStudent(Student student) throws SQLException {
        String insertSql = "INSERT INTO students (name, phone, email, qualification, academic_gap, payment_method, total_amount, image_url, status, payment_status, is_blocked, balance_amount, admin_message, timestamp, referred_by, registration_date, student_id, batch_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE students SET student_id = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement insertStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            
            insertStmt.setString(1, student.getName());
            insertStmt.setString(2, student.getPhone());
            insertStmt.setString(3, student.getEmail());
            insertStmt.setString(4, student.getQualification());
            insertStmt.setString(5, student.getAcademicGap());
            insertStmt.setString(6, student.getPaymentMethod());
            insertStmt.setInt(7, student.getTotalAmount());
            insertStmt.setString(8, student.getImageUrl());
            insertStmt.setString(9, "Pending");
            insertStmt.setString(10, "Pending");
            insertStmt.setBoolean(11, false);
            insertStmt.setInt(12, 0);
            insertStmt.setString(13, null);
            insertStmt.setLong(14, System.currentTimeMillis());
            insertStmt.setString(15, student.getReferredBy());
            insertStmt.setLong(16, System.currentTimeMillis());
            insertStmt.setString(17, "PENDING");
            insertStmt.setString(18, "PENDING");

            int affectedRows = insertStmt.executeUpdate();

            if (affectedRows > 0) {
                generatedKeys = insertStmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    String studentId = "KA" + String.format("%03d", newId);
                    
                    updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, studentId);
                    updateStmt.setInt(2, newId);
                    updateStmt.executeUpdate();
                }
            }
            
            conn.commit();
            
        } catch (SQLException e) {
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

    public void deleteStudent(int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public void updateStudentStatus(int id, String studentId, String batchNumber, String status) throws SQLException {
        String sql = "UPDATE students SET student_id = ?, batch_number = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            stmt.setString(2, batchNumber);
            stmt.setString(3, status);
            stmt.setInt(4, id);
            stmt.executeUpdate();
        }
    }

    public Student finalizeRegistration(String phone, String paymentId) throws SQLException {
        String findSql = "SELECT id FROM students WHERE phone = ? ORDER BY id DESC LIMIT 1";
        String updateSql = "UPDATE students SET status = 'Approved', payment_status = ?, student_id = ?, batch_number = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            int dbId = 0;
            try (PreparedStatement findStmt = conn.prepareStatement(findSql)) {
                findStmt.setString(1, phone);
                ResultSet rs = findStmt.executeQuery();
                if (rs.next()) {
                    dbId = rs.getInt("id");
                }
            }
            
            if (dbId > 0) {
                String studentId = "KA" + String.format("%03d", dbId);
                String batchNumber = "BATCH-" + java.time.LocalDate.now().getYear();

                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, "Paid - " + paymentId);
                    updateStmt.setString(2, studentId);
                    updateStmt.setString(3, batchNumber);
                    updateStmt.setInt(4, dbId);
                    updateStmt.executeUpdate();
                }
                return getStudentById(dbId);
            }
        }
        return null;
    }
}