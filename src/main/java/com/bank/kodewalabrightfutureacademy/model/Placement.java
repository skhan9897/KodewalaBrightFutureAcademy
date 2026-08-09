package com.bank.kodewalabrightfutureacademy.model;

public class Placement {
    private int id;
    private String name;
    private String ctc;
    private String role;
    private String education;
    private String imageUrl;
    private boolean isHighest;
    private long timestamp;

    public Placement() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCtc() { return ctc; }
    public void setCtc(String ctc) { this.ctc = ctc; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public boolean isIsHighest() { return isHighest; }
    public void setIsHighest(boolean isHighest) { this.isHighest = isHighest; }
    public long getTimestamp() { return timestamp; }
    public void setTimestamp(long timestamp) { this.timestamp = timestamp; }
}
