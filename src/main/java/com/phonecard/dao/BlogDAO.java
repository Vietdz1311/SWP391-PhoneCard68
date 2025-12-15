/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.phonecard.dao;

import com.phonecard.config.DBContext;
import com.phonecard.model.BlogPost;
import com.phonecard.model.User;


import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO {
    private static final int PAGE_SIZE = 9;
    private UserDAO userDAO = new UserDAO();

    public List<BlogPost> getAllBlogs(String search, int page, boolean onlyActive) {
        List<BlogPost> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM Blog_Posts " +
            (onlyActive ? "WHERE is_active = TRUE " : "WHERE 1=1 ")
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR content LIKE ?) ");
        }

        sql.append("ORDER BY published_at DESC LIMIT ?, ?");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeParam = "%" + search.trim() + "%";
                ps.setString(index++, likeParam);
                ps.setString(index++, likeParam);
            }
            ps.setInt(index++, (page - 1) * PAGE_SIZE);
            ps.setInt(index++, PAGE_SIZE);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPost(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalBlogs(String search, boolean onlyActive) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Blog_Posts " +
            (onlyActive ? "WHERE is_active = TRUE " : "WHERE 1=1 ")
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (title LIKE ? OR content LIKE ?) ");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeParam = "%" + search.trim() + "%";
                ps.setString(index++, likeParam);
                ps.setString(index++, likeParam);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BlogPost getBlogBySlug(String slug) {
        String sql = "SELECT * FROM Blog_Posts WHERE slug = ? AND is_active = TRUE";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapPost(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean createBlog(BlogPost post) {
        String sql = "INSERT INTO Blog_Posts (user_id, title, slug, content, thumbnail_url, is_active, published_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getSlug());
            ps.setString(4, post.getContent());
            ps.setString(5, post.getThumbnailUrl());
            ps.setBoolean(6, post.isActive());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
    
public List<BlogPost> getLatestBlogs(int limit) {
    List<BlogPost> list = new ArrayList<>();
    String sql = 
        "SELECT * FROM Blog_Posts " +
        "WHERE is_active = TRUE " +
        "ORDER BY published_at DESC " +
        "LIMIT ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);  // LIMIT ở cuối
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BlogPost post = mapPost(rs);
                list.add(post);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


    private BlogPost mapPost(ResultSet rs) throws SQLException {
        BlogPost post = new BlogPost();
        post.setPostId(rs.getInt("post_id"));
        post.setUserId(rs.getInt("user_id"));
        post.setTitle(rs.getString("title"));
        post.setSlug(rs.getString("slug"));
        post.setContent(rs.getString("content"));
        post.setThumbnailUrl(rs.getString("thumbnail_url"));
        post.setActive(rs.getBoolean("is_active"));
        post.setPublishedAt(rs.getObject("published_at", LocalDateTime.class));
        User author = userDAO.getUserById(post.getUserId()); 
        post.setAuthor(author);
        return post;
    }
}