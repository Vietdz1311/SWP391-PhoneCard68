package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    /**
     * Tạo giao dịch mới
     * @return trans_id của giao dịch vừa tạo, -1 nếu thất bại
     */
    public long createTransaction(Transaction trans, Connection conn) throws SQLException {
        String sql = "INSERT INTO Transactions (user_id, order_id, type, amount, description, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, trans.getUserId());
            if (trans.getOrderId() != null) {
                ps.setLong(2, trans.getOrderId());
            } else {
                ps.setNull(2, Types.BIGINT);
            }
            ps.setString(3, trans.getType());
            ps.setBigDecimal(4, trans.getAmount());
            ps.setString(5, trans.getDescription());
            ps.setString(6, trans.getStatus());

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
     * Tạo giao dịch mới (tự quản lý connection)
     */
    public long createTransaction(Transaction trans) {
        try (Connection conn = DBContext.getConnection()) {
            return createTransaction(trans, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Cập nhật trạng thái giao dịch
     */
    public boolean updateTransactionStatus(long transId, String status, Connection conn) throws SQLException {
        String sql = "UPDATE Transactions SET status = ? WHERE trans_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, transId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật trạng thái giao dịch (tự quản lý connection)
     */
    public boolean updateTransactionStatus(long transId, String status) {
        try (Connection conn = DBContext.getConnection()) {
            return updateTransactionStatus(transId, status, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy giao dịch theo ID
     */
    public Transaction getTransactionById(long transId) {
        String sql = "SELECT * FROM Transactions WHERE trans_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, transId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTransaction(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy giao dịch pending theo vnp_TxnRef (trans_id)
     */
    public Transaction getPendingTransactionById(long transId) {
        String sql = "SELECT * FROM Transactions WHERE trans_id = ? AND status = 'Pending'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, transId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTransaction(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách giao dịch theo user_id
     */
    public List<Transaction> getTransactionsByUserId(int userId, int page, int size) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM Transactions WHERE user_id = ? ORDER BY created_at DESC LIMIT ?, ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, (page - 1) * size);
            ps.setInt(3, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số giao dịch của user
     */
    public int countTransactionsByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM Transactions WHERE user_id = ?";
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

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction trans = new Transaction();
        trans.setTransId(rs.getLong("trans_id"));
        trans.setUserId(rs.getInt("user_id"));
        trans.setOrderId(rs.getObject("order_id") != null ? rs.getLong("order_id") : null);
        trans.setType(rs.getString("type"));
        trans.setAmount(rs.getBigDecimal("amount"));
        trans.setDescription(rs.getString("description"));
        trans.setStatus(rs.getString("status"));
        if (rs.getTimestamp("created_at") != null) {
            trans.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return trans;
    }
}

