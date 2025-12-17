package com.phonecard.controller;

import com.phonecard.dao.UserDAO;
import com.phonecard.model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        user = userDAO.getUserById(user.getUserId());
        request.setAttribute("user", user); 
        session.setAttribute("user", user); 

        request.getRequestDispatcher("/web-page/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);

            if (userDAO.updateProfile(user)) {
                session.setAttribute("user", user);
                request.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Cập nhật thất bại! Vui lòng thử lại.");
            }

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User dbUser = userDAO.getUserById(user.getUserId());
            if (dbUser == null || !BCrypt.checkpw(oldPassword, dbUser.getPassword())) {
                request.setAttribute("error", "Mật khẩu cũ không đúng!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới không khớp!");
            } else {
                user.setPassword(newPassword);
                if (userDAO.changePassword(user)) {
                    request.setAttribute("success", "Đổi mật khẩu thành công!");
                } else {
                    request.setAttribute("error", "Đổi mật khẩu thất bại!");
                }
            }
        }

        doGet(request, response);
    }
}