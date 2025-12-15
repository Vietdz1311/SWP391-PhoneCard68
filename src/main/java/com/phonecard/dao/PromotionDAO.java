package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.Promotion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {
    private Connection conn;

    public PromotionDAO() {
        conn = DBContext.getConnection();
    }

    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT * FROM Promotions ORDER BY promotion_id DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapPromotion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Promotion getPromotionById(int id) {
        String sql = "SELECT * FROM Promotions WHERE promotion_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapPromotion(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkCodeExists(String code) {
        String sql = "SELECT COUNT(*) FROM Promotions WHERE code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createPromotion(Promotion p) {
        String sql = "INSERT INTO Promotions (code, discount_type, discount_value, min_order_value, start_date, end_date, usage_limit, usage_per_user, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getCode().toUpperCase()); // Force Uppercase
            ps.setString(2, p.getDiscountType());
            ps.setBigDecimal(3, p.getDiscountValue());
            ps.setBigDecimal(4, p.getMinOrderValue());
            ps.setTimestamp(5, Timestamp.valueOf(p.getStartDate())); // LocalDateTime to SQL Timestamp
            ps.setTimestamp(6, Timestamp.valueOf(p.getEndDate()));
            ps.setInt(7, p.getUsageLimit());
            ps.setInt(8, p.getUsagePerUser());
            ps.setString(9, "Active");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePromotion(Promotion p) {
        String sql = "UPDATE Promotions SET discount_type=?, discount_value=?, min_order_value=?, start_date=?, end_date=?, usage_limit=?, usage_per_user=?, status=? " +
                     "WHERE promotion_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getDiscountType());
            ps.setBigDecimal(2, p.getDiscountValue());
            ps.setBigDecimal(3, p.getMinOrderValue());
            ps.setTimestamp(4, Timestamp.valueOf(p.getStartDate()));
            ps.setTimestamp(5, Timestamp.valueOf(p.getEndDate()));
            ps.setInt(6, p.getUsageLimit());
            ps.setInt(7, p.getUsagePerUser());
            ps.setString(8, p.getStatus());
            ps.setInt(9, p.getPromotionId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Promotion mapPromotion(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getInt("promotion_id"));
        p.setCode(rs.getString("code"));
        p.setDiscountType(rs.getString("discount_type"));
        p.setDiscountValue(rs.getBigDecimal("discount_value"));
        p.setMinOrderValue(rs.getBigDecimal("min_order_value"));
        p.setStartDate(rs.getTimestamp("start_date").toLocalDateTime());
        p.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
        p.setUsageLimit(rs.getInt("usage_limit"));
        p.setUsagePerUser(rs.getInt("usage_per_user"));
        p.setStatus(rs.getString("status"));
        return p;
    }
}

