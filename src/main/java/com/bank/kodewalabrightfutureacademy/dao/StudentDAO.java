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
                students.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("SQL ERROR (getAllStudents): " + e.getMessage());
        }
        return students;
    }

    public Student getStudentByPhone(String phone) {
        String sql = "SELECT * FROM students WHERE phone = ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractStudentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL ERROR (getStudentByPhone): " + e.getMessage());
        }
        return null;
    }

    public Student getStudentByStudentId(String studentId) throws SQLException {
        String sql = "SELECT * FROM students WHERE student_id = ? LIMIT 1";
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
        student.setTimestamp(rs.getLong("timestamp"));
        return student;
    }

    public void addStudent(Student student) {
        String sql = "INSERT INTO students (student_id, batch_number, name, phone, email, qualification, academic_gap, payment_method, total_amount, image_url, status, payment_status, is_blocked, balance_amount, admin_message, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, "PENDING");
            stmt.setString(2, "PENDING");
            stmt.setString(3, student.getName());
            stmt.setString(4, student.getPhone());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getQualification());
            stmt.setString(7, student.getAcademicGap());
            stmt.setString(8, student.getPaymentMethod());
            stmt.setInt(9, student.getTotalAmount() > 0 ? student.getTotalAmount() : 35000);
            stmt.setString(10, student.getImageUrl());
            stmt.setString(11, student.getStatus() != null ? student.getStatus() : "Pending");
            stmt.setString(12, student.getPaymentStatus() != null ? student.getPaymentStatus() : "Pending");
            stmt.setBoolean(13, student.isBlocked());
            stmt.setInt(14, student.getBalanceAmount());
            stmt.setString(15, student.getAdminMessage());
            stmt.setLong(16, System.currentTimeMillis());
            
            stmt.executeUpdate();
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int id = generatedKeys.getInt(1);
                    String studentId = "KA" + String.format("%03d", id);
                    updateStudentId(id, studentId);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL ERROR (addStudent): " + e.getMessage());
        }
    }

    private void updateStudentId(int id, String studentId) {
        String sql = "UPDATE students SET student_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        } catch (SQLException e) {}
    }

    public void updateStudentStatus(int id, String studentId, String batchNumber, String status) {
        String sql = "UPDATE students SET student_id = ?, batch_number = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            stmt.setString(2, batchNumber);
            stmt.setString(3, status);
            stmt.setInt(4, id);
            stmt.executeUpdate();
        } catch (SQLException e) {}
    }

    public void confirmPaymentAndApprove(String phone, String paymentStatus) {
        String batchNumber = "BATCH-" + java.time.LocalDate.now().getMonthValue() + java.time.LocalDate.now().getYear();
        String findSql = "SELECT id FROM students WHERE phone = ? ORDER BY id DESC LIMIT 1";
        String updateSql = "UPDATE students SET status = 'Approved', payment_status = ?, student_id = ?, batch_number = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            int dbId = 0;
            try (PreparedStatement pst = conn.prepareStatement(findSql)) {
                pst.setString(1, phone);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) dbId = rs.getInt("id");
                }
            }
            
            if (dbId > 0) {
                String studentId = "KA" + String.format("%03d", dbId);
                try (PreparedStatement pst = conn.prepareStatement(updateSql)) {
                    pst.setString(1, paymentStatus);
                    pst.setString(2, studentId);
                    pst.setString(3, batchNumber);
                    pst.setInt(4, dbId);
                    pst.executeUpdate();
                }
            }
        } catch (SQLException e) {}
    }

    public void deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {}
    }
}
