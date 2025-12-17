package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.CardInventory;
import com.phonecard.model.CardProduct;
import com.phonecard.model.Provider;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class CardInventoryDAO {
    public CardInventory getAvailableCard(int productId) {
        try (Connection conn = DBContext.getConnection()) {
            return getAvailableCard(productId, conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public CardInventory getAvailableCard(int productId, Connection conn) throws SQLException {
        String sql = "SELECT ci.*, cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
                     "pr.provider_id, pr.provider_name, pr.logo_url " +
                     "FROM Card_Inventory ci " +
                     "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
                     "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
                     "WHERE ci.product_id = ? AND ci.status = 'Available' AND ci.expiry_date > CURDATE() " +
                     "ORDER BY ci.expiry_date ASC " +
                     "LIMIT 1 FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCardInventory(rs);
                }
            }
        }
        return null;
    }

    public CardInventory getCardById(long cardId) {
        String sql = "SELECT ci.*, cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
                     "pr.provider_id, pr.provider_name, pr.logo_url " +
                     "FROM Card_Inventory ci " +
                     "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
                     "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
                     "WHERE ci.card_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cardId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCardInventory(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCardStatus(long cardId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE Card_Inventory SET status = ? WHERE card_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, cardId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateCardStatus(long cardId, String status) {
        try (Connection conn = DBContext.getConnection()) {
            return updateCardStatus(cardId, status, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countAvailableCards(int productId) {
        String sql = "SELECT COUNT(*) FROM Card_Inventory WHERE product_id = ? AND status = 'Available' AND expiry_date > CURDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private CardInventory mapCardInventory(ResultSet rs) throws SQLException {
        CardInventory ci = new CardInventory();
        ci.setCardId(rs.getLong("card_id"));
        ci.setProductId(rs.getInt("product_id"));
        ci.setSerialNumber(rs.getString("serial_number"));
        ci.setCardCode(rs.getString("card_code"));
        if (rs.getDate("expiry_date") != null) {
            ci.setExpiryDate(rs.getDate("expiry_date").toLocalDate());
        }
        ci.setStatus(rs.getString("status"));
        if (rs.getTimestamp("imported_at") != null) {
            ci.setImportedAt(rs.getTimestamp("imported_at").toLocalDateTime());
        }

        CardProduct cp = new CardProduct();
        cp.setProductId(rs.getInt("product_id"));
        cp.setProductName(rs.getString("product_name"));
        cp.setFaceValue(rs.getDouble("face_value"));
        cp.setSellingPrice(rs.getDouble("selling_price"));
        cp.setDescription(rs.getString("description"));

        Provider pr = new Provider();
        pr.setProviderId(rs.getInt("provider_id"));
        pr.setProviderName(rs.getString("provider_name"));
        pr.setLogoUrl(rs.getString("logo_url"));
        cp.setProvider(pr);

        ci.setCardProduct(cp);
        return ci;
    }

    // ==================== STAFF INVENTORY MANAGEMENT ====================

    public boolean addCard(int productId, String serialNumber, String cardCode, LocalDate expiryDate) {
        String sql = "INSERT INTO Card_Inventory (product_id, serial_number, card_code, expiry_date, status) VALUES (?, ?, ?, ?, 'Available')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, serialNumber);
            ps.setString(3, cardCode);
            ps.setDate(4, Date.valueOf(expiryDate));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int addRandomCards(int productId, int quantity, LocalDate expiryDate) {
        String sql = "INSERT INTO Card_Inventory (product_id, serial_number, card_code, expiry_date, status) VALUES (?, ?, ?, ?, 'Available')";
        int successCount = 0;
        Random random = new Random();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < quantity; i++) {
                String serialNumber = generateRandomSerial(random);
                String cardCode = generateRandomCardCode(random);
                
                ps.setInt(1, productId);
                ps.setString(2, serialNumber);
                ps.setString(3, cardCode);
                ps.setDate(4, Date.valueOf(expiryDate));
                
                try {
                    if (ps.executeUpdate() > 0) {
                        successCount++;
                    }
                } catch (SQLException e) {
                    System.out.println("Skipped duplicate serial: " + serialNumber);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return successCount;
    }

    private String generateRandomSerial(Random random) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 14; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    private String generateRandomCardCode(Random random) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 12; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    public List<CardInventory> getInventoryByProductId(int productId, String statusFilter, int page, int pageSize) {
        List<CardInventory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ci.*, cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
            "pr.provider_id, pr.provider_name, pr.logo_url " +
            "FROM Card_Inventory ci " +
            "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
            "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
            "WHERE ci.product_id = ?"
        );
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND ci.status = ?");
        }
        
        sql.append(" ORDER BY ci.imported_at DESC LIMIT ? OFFSET ?");
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, productId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx++, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCardInventory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countInventoryByProductId(int productId, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Card_Inventory WHERE product_id = ?");
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, productId);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(2, statusFilter);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteCard(long cardId) {
        String sql = "DELETE FROM Card_Inventory WHERE card_id = ? AND status = 'Available'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cardId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isSerialExists(int productId, String serialNumber) {
        String sql = "SELECT COUNT(*) FROM Card_Inventory WHERE product_id = ? AND serial_number = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, serialNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int[] getInventoryStats(int productId) {
        int[] stats = new int[3];
        String sql = "SELECT status, COUNT(*) as cnt FROM Card_Inventory WHERE product_id = ? GROUP BY status";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                switch (status) {
                    case "Available" -> stats[0] = count;
                    case "Sold" -> stats[1] = count;
                    case "Error" -> stats[2] = count;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}

