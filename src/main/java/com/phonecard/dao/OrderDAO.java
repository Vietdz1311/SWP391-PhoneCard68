package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.CardInventory;
import com.phonecard.model.CardProduct;
import com.phonecard.model.Order;
import com.phonecard.model.Provider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Tạo đơn hàng mới
     * @return order_id của đơn hàng vừa tạo, -1 nếu thất bại
     */
    public long createOrder(Order order, Connection conn) throws SQLException {
        String sql = "INSERT INTO Orders (user_id, promotion_id, card_id, price, discount_amount, final_amount, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUserId());
            if (order.getPromotionId() != null) {
                ps.setInt(2, order.getPromotionId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setLong(3, order.getCardId());
            ps.setBigDecimal(4, order.getPrice());
            ps.setBigDecimal(5, order.getDiscountAmount());
            ps.setBigDecimal(6, order.getFinalAmount());
            ps.setString(7, order.getStatus());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        }
        return -1;
    }

    /**
     * Tạo đơn hàng mới (tự quản lý connection)
     */
    public long createOrder(Order order) {
        try (Connection conn = DBContext.getConnection()) {
            return createOrder(order, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(long orderId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng (tự quản lý connection)
     */
    public boolean updateOrderStatus(long orderId, String status) {
        try (Connection conn = DBContext.getConnection()) {
            return updateOrderStatus(orderId, status, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy đơn hàng theo ID
     */
    public Order getOrderById(long orderId) {
        String sql = "SELECT o.*, ci.serial_number, ci.card_code, ci.expiry_date, ci.status as card_status, " +
                     "cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
                     "pr.provider_id, pr.provider_name, pr.logo_url " +
                     "FROM Orders o " +
                     "JOIN Card_Inventory ci ON o.card_id = ci.card_id " +
                     "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
                     "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
                     "WHERE o.order_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách đơn hàng theo user_id
     */
    public List<Order> getOrdersByUserId(int userId, int page, int size) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, ci.serial_number, ci.card_code, ci.expiry_date, ci.status as card_status, " +
                     "cp.product_name, cp.face_value, cp.selling_price, cp.description, " +
                     "pr.provider_id, pr.provider_name, pr.logo_url " +
                     "FROM Orders o " +
                     "JOIN Card_Inventory ci ON o.card_id = ci.card_id " +
                     "JOIN Card_Products cp ON ci.product_id = cp.product_id " +
                     "JOIN Providers pr ON cp.provider_id = pr.provider_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.order_date DESC " +
                     "LIMIT ?, ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, (page - 1) * size);
            ps.setInt(3, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số đơn hàng của user
     */
    public int countOrdersByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
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

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getLong("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setPromotionId(rs.getObject("promotion_id") != null ? rs.getInt("promotion_id") : null);
        order.setCardId(rs.getLong("card_id"));
        order.setPrice(rs.getBigDecimal("price"));
        order.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        order.setFinalAmount(rs.getBigDecimal("final_amount"));
        order.setStatus(rs.getString("status"));
        if (rs.getTimestamp("order_date") != null) {
            order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
        }

        // Map CardInventory
        CardInventory ci = new CardInventory();
        ci.setCardId(rs.getLong("card_id"));
        ci.setSerialNumber(rs.getString("serial_number"));
        ci.setCardCode(rs.getString("card_code"));
        ci.setExpiryDate(rs.getDate("expiry_date").toLocalDate());
        ci.setStatus(rs.getString("card_status"));
        order.setCardInventory(ci);

        // Map CardProduct
        CardProduct cp = new CardProduct();
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

        order.setCardProduct(cp);
        return order;
    }
}

