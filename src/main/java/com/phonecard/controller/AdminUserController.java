package com.phonecard.controller;

import com.phonecard.dao.UserDAO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/staff", "/admin/customers", "/admin/user-create", "/admin/user-detail"})
public class AdminUserController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/web-page/admin/dashboard.jsp"); 
            return;
        }

        String servletPath = request.getServletPath();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if (servletPath.contains("user-create")) {
            request.getRequestDispatcher("/web-page/admin/user-create.jsp").forward(request, response);
            return;
        }

        if (servletPath.contains("user-detail")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                User u = userDAO.getUserById(id);
                if ("Admin".equals(u.getRole())) {
                     response.sendRedirect(request.getContextPath() + "/admin/staff");
                     return;
                }
                request.setAttribute("userinfo", u);
                request.getRequestDispatcher("/web-page/admin/user-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
            }
            return;
        }

            if ("lock".equals(action) || "unlock".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User targetUser = userDAO.getUserById(id);
            if (!"Admin".equals(targetUser.getRole())) {
                String newStatus = "lock".equals(action) ? "Locked" : "Active";
                userDAO.updateUserStatus(id, newStatus);
            }
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/admin/staff");
            return;
        }

        List<User> allUsers = userDAO.getAllUsers();
        
        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        String currentTab = servletPath.contains("staff") ? "staff" : "customers";

        List<User> filteredList = allUsers.stream()
            .filter(u -> {
                if (servletPath.contains("staff")) return "Admin".equals(u.getRole()) || "Staff".equals(u.getRole());
                return "Customer".equals(u.getRole());
            })
            .filter(u -> keyword == null || keyword.trim().isEmpty() || 
                         u.getUsername().toLowerCase().contains(keyword.trim().toLowerCase()) || 
                         u.getEmail().toLowerCase().contains(keyword.trim().toLowerCase()))
            .filter(u -> roleFilter == null || roleFilter.isEmpty() || "All".equals(roleFilter) || u.getRole().equalsIgnoreCase(roleFilter))
            .filter(u -> statusFilter == null || statusFilter.isEmpty() || "All".equals(statusFilter) || u.getStatus().equalsIgnoreCase(statusFilter))
            .collect(Collectors.toList());

        
        int page = 1;
        int pageSize = 5; 
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalItems = filteredList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);

        List<User> pagedList;
        if (start > end || totalItems == 0) {
            pagedList = new ArrayList<>();
        } else {
            pagedList = filteredList.subList(start, end); 
        }

        String pageTitle = servletPath.contains("staff") ? "Quản lý Nhân viên" : "Quản lý Khách hàng";

        request.setAttribute("listUsers", pagedList); 
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("currentTab", currentTab); 
        
        request.setAttribute("paramKeyword", keyword);
        request.setAttribute("paramRole", roleFilter);
        request.setAttribute("paramStatus", statusFilter);

        request.setAttribute("totalCount", totalItems);
        request.setAttribute("currentPage", page);      
        request.setAttribute("totalPages", totalPages); 
        
        request.getRequestDispatcher("/web-page/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) return;

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            User u = new User();
            u.setUsername(request.getParameter("username"));
            u.setEmail(request.getParameter("email"));
            u.setPassword(request.getParameter("password"));
            u.setPhone(request.getParameter("phone"));
            
            if (userDAO.createStaff(u)) {
                response.sendRedirect(request.getContextPath() + "/admin/staff?success=" + URLEncoder.encode("Tạo thành công", StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error", "Tạo thất bại. Tên đăng nhập hoặc Email đã tồn tại.");
                request.setAttribute("tempUser", u); 
                request.getRequestDispatcher("/web-page/admin/user-create.jsp").forward(request, response);
            }
        } 
        else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("userId"));
            String phone = request.getParameter("phone");
            String newPass = request.getParameter("newPassword");
            
            User u = new User();
            u.setUserId(id);
            u.setPhone(phone);
            
            if (userDAO.adminUpdateUser(u, newPass)) {
                response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + id + "&success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + id + "&error=1");
            }
        }
    }
}