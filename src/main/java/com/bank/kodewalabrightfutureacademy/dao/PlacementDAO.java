package com.bank.kodewalabrightfutureacademy.dao;

import com.bank.kodewalabrightfutureacademy.model.Placement;
import com.bank.kodewalabrightfutureacademy.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlacementDAO {

    public List<Placement> getAllPlacements() {
        List<Placement> placements = new ArrayList<>();
        String sql = "SELECT * FROM placements ORDER BY timestamp DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Placement p = new Placement();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCtc(rs.getString("ctc"));
                p.setRole(rs.getString("role"));
                p.setEducation(rs.getString("education"));
                p.setImageUrl(rs.getString("image_url"));
                p.setIsHighest(rs.getBoolean("is_highest"));
                p.setTimestamp(rs.getLong("timestamp"));
                placements.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return placements;
    }
}
