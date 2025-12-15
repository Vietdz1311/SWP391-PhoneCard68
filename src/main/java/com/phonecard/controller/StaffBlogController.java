package com.phonecard.controller;

import com.phonecard.dao.BlogDAO;
import com.phonecard.model.BlogPost;
import com.phonecard.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Controller quản lý Blog cho Staff/Admin
 * URL: /staff/blogs
 */
@WebServlet(name = "StaffBlogController", urlPatterns = {"/staff/blogs"})
public class StaffBlogController extends HttpServlet {
    
    private BlogDAO blogDAO = new BlogDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền Staff/Admin
        if (!checkStaffPermission(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) action = "list";
        
        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBlog(request, response);
                break;
            default:
                listBlogs(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền Staff/Admin
        if (!checkStaffPermission(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBlog(request, response);
        } else if ("edit".equals(action)) {
            updateBlog(request, response);
        }
    }
    
    /**
     * Kiểm tra quyền Staff hoặc Admin
     */
    private boolean checkStaffPermission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return false;
        }
        
        if (!"Staff".equals(user.getRole()) && !"Admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        
        return true;
    }
    
    /**
     * Hiển thị danh sách bài viết
     */
    private void listBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception ignored) {}
        
        // Lấy tất cả bài viết (cả active và inactive)
        List<BlogPost> posts = blogDAO.getAllBlogs(search, page, false);
        int total = blogDAO.getTotalBlogs(search, false);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        
        request.setAttribute("posts", posts);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/web-page/staff/blog-list.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form tạo bài viết mới
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form chỉnh sửa bài viết
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            BlogPost post = blogDAO.getBlogById(postId);
            
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/staff/blogs?error=" + 
                    URLEncoder.encode("Bài viết không tồn tại", StandardCharsets.UTF_8));
                return;
            }
            
            request.setAttribute("post", post);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
        }
    }
    
    /**
     * Xử lý tạo bài viết mới
     */
    private void createBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String thumbnailUrl = request.getParameter("thumbnailUrl");
        boolean isActive = "on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive"));
        
        // Validate
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề không được để trống");
            request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
            return;
        }
        
        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Nội dung không được để trống");
            request.setAttribute("title", title);
            request.setAttribute("thumbnailUrl", thumbnailUrl);
            request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
            return;
        }
        
        // Tạo slug từ title
        String slug = blogDAO.generateSlug(title);
        
        BlogPost post = new BlogPost();
        post.setUserId(user.getUserId());
        post.setTitle(title.trim());
        post.setSlug(slug);
        post.setContent(content.trim());
        post.setThumbnailUrl(thumbnailUrl != null ? thumbnailUrl.trim() : null);
        post.setActive(isActive);
        
        if (blogDAO.createBlog(post)) {
            response.sendRedirect(request.getContextPath() + "/staff/blogs?success=" + 
                URLEncoder.encode("Tạo bài viết thành công", StandardCharsets.UTF_8));
        } else {
            request.setAttribute("error", "Không thể tạo bài viết, vui lòng thử lại");
            request.setAttribute("title", title);
            request.setAttribute("content", content);
            request.setAttribute("thumbnailUrl", thumbnailUrl);
            request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý cập nhật bài viết
     */
    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String thumbnailUrl = request.getParameter("thumbnailUrl");
            boolean isActive = "on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive"));
            
            BlogPost existingPost = blogDAO.getBlogById(postId);
            if (existingPost == null) {
                response.sendRedirect(request.getContextPath() + "/staff/blogs?error=" + 
                    URLEncoder.encode("Bài viết không tồn tại", StandardCharsets.UTF_8));
                return;
            }
            
            // Validate
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề không được để trống");
                request.setAttribute("post", existingPost);
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật slug nếu title thay đổi
            String slug = existingPost.getSlug();
            if (!title.trim().equals(existingPost.getTitle())) {
                slug = blogDAO.generateSlug(title);
            }
            
            existingPost.setTitle(title.trim());
            existingPost.setSlug(slug);
            existingPost.setContent(content != null ? content.trim() : "");
            existingPost.setThumbnailUrl(thumbnailUrl != null ? thumbnailUrl.trim() : null);
            existingPost.setActive(isActive);
            
            if (blogDAO.updateBlog(existingPost)) {
                response.sendRedirect(request.getContextPath() + "/staff/blogs?success=" + 
                    URLEncoder.encode("Cập nhật bài viết thành công", StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error", "Không thể cập nhật bài viết");
                request.setAttribute("post", existingPost);
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/web-page/staff/blog-form.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
        }
    }
    
    /**
     * Xử lý xóa bài viết
     */
    private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            int postId = Integer.parseInt(request.getParameter("id"));
            
            if (blogDAO.deleteBlog(postId)) {
                response.sendRedirect(request.getContextPath() + "/staff/blogs?success=" + 
                    URLEncoder.encode("Xóa bài viết thành công", StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/blogs?error=" + 
                    URLEncoder.encode("Không thể xóa bài viết", StandardCharsets.UTF_8));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/blogs");
        }
    }
}


