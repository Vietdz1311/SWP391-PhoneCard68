package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.Provider;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProviderDAO {
    public List<Provider> getAllActiveProviders() {
        List<Provider> list = new ArrayList<>();
        String sql = "SELECT * FROM Providers WHERE is_active = TRUE ORDER BY provider_name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Provider p = new Provider();
                p.setProviderId(rs.getInt("provider_id"));
                p.setProviderName(rs.getString("provider_name"));
                p.setLogoUrl(rs.getString("logo_url"));
                p.setIsActive(rs.getBoolean("is_active"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Provider getProviderById(int id) {
        String sql = "SELECT * FROM Providers WHERE provider_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Provider p = new Provider();
                    p.setProviderId(rs.getInt("provider_id"));
                    p.setProviderName(rs.getString("provider_name"));
                    p.setLogoUrl(rs.getString("logo_url"));
                    p.setIsActive(rs.getBoolean("is_active"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}