package com.phonecard.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.phonecard.config.DBContext;
import com.phonecard.model.CardProduct;

public class CardProductDAO {
    private static final int PAGE_SIZE_DEFAULT = 12;

public List<CardProduct> getAllCardProducts(String search, Integer filterProvider, String sortBy, int page, int size) {
    List<CardProduct> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
        "SELECT p.*, pr.provider_name, pr.logo_url, " +
        "(SELECT COUNT(*) FROM Card_Inventory ci WHERE ci.product_id = p.product_id AND ci.status = 'Available') AS available_count " +
        "FROM Card_Products p " +
        "JOIN Providers pr ON p.provider_id = pr.provider_id " +
        "WHERE 1=1 "
    );

    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND p.product_name LIKE ?");
    }
    if (filterProvider != null) {
        sql.append(" AND p.provider_id = ?");
    }

    sql.append(" ORDER BY ");
    String order = (sortBy != null && !sortBy.isEmpty()) ? sortBy : "p.face_value DESC";
    sql.append(order);

    sql.append(" LIMIT ?, ?");

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int index = 1;
        if (search != null && !search.trim().isEmpty()) {
            ps.setString(index++, "%" + search.trim() + "%");
        }
        if (filterProvider != null) {
            ps.setInt(index++, filterProvider);
        }
        ps.setInt(index++, (page - 1) * size);
        ps.setInt(index++, size);        

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CardProduct cp = new CardProduct();
                cp.setProductId(rs.getInt("product_id"));
                cp.setProviderId(rs.getInt("provider_id"));
                cp.setProductName(rs.getString("product_name"));
                cp.setFaceValue(rs.getDouble("face_value"));
                cp.setSellingPrice(rs.getDouble("selling_price"));
                cp.setDescription(rs.getString("description"));
                cp.setAvailableCount(rs.getInt("available_count"));


                list.add(cp);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public int getTotalCardProducts(String search, Integer filterProvider) {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Card_Products p WHERE 1=1 ");
    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND p.product_name LIKE ?");
    }
    if (filterProvider != null) {
        sql.append(" AND p.provider_id = ?");
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int index = 1;
        if (search != null && !search.trim().isEmpty()) {
            ps.setString(index++, "%" + search.trim() + "%");
        }
        if (filterProvider != null) {
            ps.setInt(index++, filterProvider);
        }
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

public CardProduct getCardProductById(int id) {
    CardProduct cp = null;
    String sql = 
        "SELECT p.*, pr.provider_name, pr.logo_url, " +
        "(SELECT COUNT(*) FROM Card_Inventory ci WHERE ci.product_id = p.product_id AND ci.status = 'Available') AS available_count " +
        "FROM Card_Products p " +
        "JOIN Providers pr ON p.provider_id = pr.provider_id " +
        "WHERE p.product_id = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                cp = new CardProduct();
                cp.setProductId(rs.getInt("product_id"));
                cp.setProviderId(rs.getInt("provider_id"));
                cp.setProductName(rs.getString("product_name"));
                cp.setFaceValue(rs.getDouble("face_value"));
                cp.setSellingPrice(rs.getDouble("selling_price"));
                cp.setDescription(rs.getString("description"));
                cp.setAvailableCount(rs.getInt("available_count"));

            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return cp;
}
    
public List<CardProduct> getFeaturedProducts(int limit) {
    List<CardProduct> list = new ArrayList<>();
    String sql = 
        "SELECT p.*, pr.provider_name, pr.logo_url, " +
        "(SELECT COUNT(*) FROM Card_Inventory ci WHERE ci.product_id = p.product_id AND ci.status = 'Available') AS available_count " +
        "FROM Card_Products p " +
        "JOIN Providers pr ON p.provider_id = pr.provider_id " +
        "WHERE (SELECT COUNT(*) FROM Card_Inventory ci WHERE ci.product_id = p.product_id AND ci.status = 'Available') > 0 " +
        "ORDER BY p.face_value DESC " +
        "LIMIT ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);  // LIMIT ở cuối
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CardProduct cp = new CardProduct();
                cp.setProductId(rs.getInt("product_id"));
                cp.setProviderId(rs.getInt("provider_id"));
                cp.setProductName(rs.getString("product_name"));
                cp.setFaceValue(rs.getDouble("face_value"));
                cp.setSellingPrice(rs.getDouble("selling_price"));
                cp.setDescription(rs.getString("description"));
                cp.setAvailableCount(rs.getInt("available_count"));

                list.add(cp);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}