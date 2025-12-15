package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private Connection conn;

    public UserDAO() {
        conn = DBContext.getConnection();
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE (username = ? OR email=?) AND status = 'Active'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapUser(rs);
                    // Kiểm tra password với BCrypt
                    if (BCrypt.checkpw(password, user.getPassword())) {
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (username, email, password, phone, role, status, wallet_balance) VALUES (?, ?, ?, ?, 'Customer', 'Active', 0)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            // Hash password với BCrypt
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: Lỗi Register SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tạo tài khoản Staff (chỉ Admin dùng)
     */
    public boolean createStaff(User user) {
        String sql = "INSERT INTO Users (username, email, password, phone, role, status) VALUES (?, ?, ?, ?, 'Staff', 'Active')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái user (Lock/Active)
     */
    public boolean updateUserStatus(int userId, String newStatus) {
        String sql = "UPDATE Users SET status = ? WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin cập nhật thông tin user (phone, password)
     */
    public boolean adminUpdateUser(User user, String newPassword) {
        StringBuilder sql = new StringBuilder("UPDATE Users SET phone = ?");
        if (newPassword != null && !newPassword.isEmpty()) {
            sql.append(", password = ?");
        }
        sql.append(" WHERE user_id = ?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, user.getPhone());
            
            int index = 2;
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                ps.setString(index++, hashedPassword);
            }
            
            ps.setInt(index, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY user_id DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
     
    public boolean updateProfile(User user) {
        String sql = "UPDATE Users SET username = ?, email = ?, phone = ? WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changePassword(User user) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            // Hash password mới với BCrypt
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setInt(2, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật số dư ví của user
     * @param userId ID của user
     * @param amount Số tiền thay đổi (+ nạp, - trừ)
     * @param conn Connection (để dùng trong transaction)
     */
    public boolean updateWalletBalance(int userId, java.math.BigDecimal amount, Connection conn) throws SQLException {
        String sql = "UPDATE Users SET wallet_balance = wallet_balance + ? WHERE user_id = ? AND wallet_balance + ? >= 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, amount);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật số dư ví của user (tự quản lý connection)
     */
    public boolean updateWalletBalance(int userId, java.math.BigDecimal amount) {
        try (Connection conn = DBContext.getConnection()) {
            return updateWalletBalance(userId, amount, conn);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy số dư ví hiện tại
     */
    public java.math.BigDecimal getWalletBalance(int userId) {
        String sql = "SELECT wallet_balance FROM Users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("wallet_balance");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    /**
     * Refresh thông tin user từ database
     */
    public User refreshUser(int userId) {
        return getUserById(userId);
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setWalletBalance(rs.getBigDecimal("wallet_balance"));
        u.setPassword(rs.getString("password"));
        u.setStatus(rs.getString("status"));
        if (rs.getTimestamp("created_at") != null) {
            u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return u;
    }
}
