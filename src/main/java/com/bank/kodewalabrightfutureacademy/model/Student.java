package com.bank.kodewalabrightfutureacademy.model;

public class Student {
    private int id;
    private String studentId;
    private String batchNumber;
    private String name;
    private String phone;
    private String email;
    private String qualification;
    private String academicGap;
    private String paymentMethod;
    private int totalAmount;
    private String imageUrl;
    private String status;
    private String paymentStatus;
    private boolean isBlocked;
    private int balanceAmount;
    private String adminMessage;
    private long timestamp;

    public Student() {
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getBatchNumber() { return batchNumber; }
    public void setBatchNumber(String batchNumber) { this.batchNumber = batchNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public String getAcademicGap() { return academicGap; }
    public void setAcademicGap(String academicGap) { this.academicGap = academicGap; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public boolean isIsBlocked() { return isBlocked; }
    public void setIsBlocked(boolean isBlocked) { this.isBlocked = isBlocked; }

    public int getBalanceAmount() { return balanceAmount; }
    public void setBalanceAmount(int balanceAmount) { this.balanceAmount = balanceAmount; }

    public String getAdminMessage() { return adminMessage; }
    public void setAdminMessage(String adminMessage) { this.adminMessage = adminMessage; }

    public long getTimestamp() { return timestamp; }
    public void setTimestamp(long timestamp) { this.timestamp = timestamp; }
}
