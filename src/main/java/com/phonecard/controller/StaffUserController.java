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
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "StaffUserController", urlPatterns = {"/staff/users", "/staff/user-detail"})
public class StaffUserController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || (!"Staff".equals(currentUser.getRole()) && !"Admin".equals(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String servletPath = request.getServletPath();

        if (servletPath.contains("user-detail")) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    User u = userDAO.getUserById(id);
                    
                    if (u != null && "Admin".equals(u.getRole()) && "Staff".equals(currentUser.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/staff/users?error=1");
                        return;
                    }
                    
                    request.setAttribute("userinfo", u);
                    request.getRequestDispatcher("/web-page/staff/user-detail.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/staff/users");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/users");
            }
            return;
        }

        List<User> allUsers = userDAO.getAllUsers();
        
        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");

        List<User> filteredList = allUsers.stream()
            .filter(u -> {
                if ("Staff".equals(currentUser.getRole()) && "Admin".equals(u.getRole())) {
                    return false;
                }
                return true;
            })
            .filter(u -> keyword == null || keyword.trim().isEmpty() || 
                         u.getUsername().toLowerCase().contains(keyword.trim().toLowerCase()) || 
                         u.getEmail().toLowerCase().contains(keyword.trim().toLowerCase()))
            .filter(u -> roleFilter == null || roleFilter.isEmpty() || "All".equals(roleFilter) || u.getRole().equalsIgnoreCase(roleFilter))
            .filter(u -> statusFilter == null || statusFilter.isEmpty() || "All".equals(statusFilter) || u.getStatus().equalsIgnoreCase(statusFilter))
            .collect(Collectors.toList());

        request.setAttribute("listUsers", filteredList);
        request.setAttribute("totalCount", filteredList.size());
        request.setAttribute("paramKeyword", keyword);
        request.setAttribute("paramRole", roleFilter);
        request.setAttribute("paramStatus", statusFilter);
        
        request.getRequestDispatcher("/web-page/staff/user-list.jsp").forward(request, response);
    }
}

