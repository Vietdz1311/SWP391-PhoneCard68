package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.CardInventory;
import com.phonecard.model.CardProduct;
import com.phonecard.model.Provider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CardInventoryDAO {

    /**
     * Lấy một thẻ khả dụng từ kho theo product_id
     * @param productId ID của sản phẩm
     * @return CardInventory hoặc null nếu không có thẻ khả dụng
     */
    public CardInventory getAvailableCard(int productId) {
        String sql = "SELECT ci.*, cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
                     "pr.provider_id, pr.provider_name, pr.logo_url " +
                     "FROM Card_Inventory ci " +
                     "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
                     "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
                     "WHERE ci.product_id = ? AND ci.status = 'Available' AND ci.expiry_date > CURDATE() " +
                     "ORDER BY ci.expiry_date ASC " +
                     "LIMIT 1 FOR UPDATE";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
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

    /**
     * Lấy thẻ theo ID
     */
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

    /**
     * Cập nhật trạng thái thẻ
     */
    public boolean updateCardStatus(long cardId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE Card_Inventory SET status = ? WHERE card_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, cardId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật trạng thái thẻ (tự quản lý connection)
     */
    public boolean updateCardStatus(long cardId, String status) {
        try (Connection conn = DBContext.getConnection()) {
            return updateCardStatus(cardId, status, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đếm số thẻ khả dụng theo product_id
     */
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
        ci.setExpiryDate(rs.getDate("expiry_date").toLocalDate());
        ci.setStatus(rs.getString("status"));
        if (rs.getTimestamp("imported_at") != null) {
            ci.setImportedAt(rs.getTimestamp("imported_at").toLocalDateTime());
        }

        // Map CardProduct
        CardProduct cp = new CardProduct();
        cp.setProductId(rs.getInt("product_id"));
        cp.setProductName(rs.getString("product_name"));
        cp.setFaceValue(rs.getDouble("face_value"));
        cp.setSellingPrice(rs.getDouble("selling_price"));
        cp.setDescription(rs.getString("description"));

        // Map Provider
        Provider pr = new Provider();
        pr.setProviderId(rs.getInt("provider_id"));
        pr.setProviderName(rs.getString("provider_name"));
        pr.setLogoUrl(rs.getString("logo_url"));
        cp.setProvider(pr);

        ci.setCardProduct(cp);
        return ci;
    }
}

