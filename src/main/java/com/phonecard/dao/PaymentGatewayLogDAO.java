package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.PaymentGatewayLog;

import java.sql.*;

public class PaymentGatewayLogDAO {

    /**
     * Tạo log giao dịch với cổng thanh toán
     */
    public long createLog(PaymentGatewayLog log, Connection conn) throws SQLException {
        String sql = "INSERT INTO Payment_Gateway_Logs (trans_id, gateway_name, gateway_trans_id, response_code) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, log.getTransId());
            ps.setString(2, log.getGatewayName());
            ps.setString(3, log.getGatewayTransId());
            ps.setString(4, log.getResponseCode());

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
     * Tạo log giao dịch (tự quản lý connection)
     */
    public long createLog(PaymentGatewayLog log) {
        try (Connection conn = DBContext.getConnection()) {
            return createLog(log, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Lấy log theo trans_id
     */
    public PaymentGatewayLog getLogByTransId(long transId) {
        String sql = "SELECT * FROM Payment_Gateway_Logs WHERE trans_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, transId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PaymentGatewayLog log = new PaymentGatewayLog();
                    log.setLogId(rs.getLong("log_id"));
                    log.setTransId(rs.getLong("trans_id"));
                    log.setGatewayName(rs.getString("gateway_name"));
                    log.setGatewayTransId(rs.getString("gateway_trans_id"));
                    log.setResponseCode(rs.getString("response_code"));
                    if (rs.getTimestamp("created_at") != null) {
                        log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    return log;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

