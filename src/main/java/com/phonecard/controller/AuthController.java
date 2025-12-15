package com.phonecard.controller;

import com.phonecard.dao.UserDAO;
import com.phonecard.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "AuthController", urlPatterns = {"/auth"})
public class AuthController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if ("register".equals(action)) {
            request.getRequestDispatcher("/web-page/register.jsp").forward(request, response);
            return;
        }

        if ("forget".equals(action)) {
            request.getRequestDispatcher("/web-page/forget-password.jsp").forward(request, response);
            return;
        }
        
        if ("change-password".equals(action)) {
            request.getRequestDispatcher("/web-page/change-password.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/web-page/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        System.out.println("DEBUG: Action received form JSP = " + action);
        
        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            System.out.println("DEBUG: Dang nhap voi User: " + username + " - Pass: " + password);
            
            User user = userDAO.login(username, password);
            
            if (user != null) {
                System.out.println("DEBUG: Login THANH CONG! Role = " + user.getRole());
                
                HttpSession session = request.getSession();
                session.setAttribute("user", user); 
                
                if ("Admin".equals(user.getRole()) || "Staff".equals(user.getRole())) {
                    System.out.println("DEBUG: Chuyen huong ve DASHBOARD");
                    response.sendRedirect(request.getContextPath() + "/web-page/admin/dashboard.jsp");
                } else {
                    System.out.println("DEBUG: Chuyen huong ve HOME");
                    response.sendRedirect("home");
                }
                
            } else {
                System.out.println("DEBUG: Login THAT BAI (UserDAO tra ve null) -> Kiem tra lai password hash trong DB");
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("/web-page/login.jsp").forward(request, response);
            }
            
        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            
            System.out.println("DEBUG Register: " + username + " | " + email);
            
            User u = new User();
            u.setUsername(username);
            u.setEmail(email);
            u.setPhone(phone);
            u.setPassword(password);
            
            if (userDAO.register(u)) {
                String msg = "Đăng ký tài khoản thành công! Vui lòng đăng nhập.";
                String encodedMsg = URLEncoder.encode(msg, StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/auth?success=" + encodedMsg);
            } else {
                request.setAttribute("error", "Đăng ký thất bại (Username hoặc Email đã tồn tại)");
                request.getRequestDispatcher("/web-page/register.jsp").forward(request, response);
            }
        }
    }
}