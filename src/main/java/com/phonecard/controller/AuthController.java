package com.phonecard.controller;

import com.phonecard.dao.UserDAO;
import com.phonecard.model.User;
import com.phonecard.util.EmailUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

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

        if ("reset-password".equals(action)) {
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
            return;
        }

        if ("change-password".equals(action)) {
            request.getRequestDispatcher("/web-page/change-password.jsp").forward(request, response);
            return;
        }

        if ("verify".equals(action)) {
            String token = request.getParameter("token");
            if (token == null || token.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/auth?error=" + 
                        URLEncoder.encode("Link xác thực không hợp lệ", StandardCharsets.UTF_8));
                return;
            }

            Integer userId = userDAO.getUserIdByVerificationToken(token);
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/auth?error=" +
                        URLEncoder.encode("Link xác thực đã hết hạn hoặc không hợp lệ", StandardCharsets.UTF_8));
                return;
            }

            boolean activated = userDAO.activateUser(userId);
            if (activated) {
                userDAO.deleteVerificationToken(token);
                response.sendRedirect(request.getContextPath() + "/auth?success=" +
                        URLEncoder.encode("Xác thực email thành công, bạn có thể đăng nhập", StandardCharsets.UTF_8));
            } else {
                response.sendRedirect(request.getContextPath() + "/auth?error=" +
                        URLEncoder.encode("Không thể kích hoạt tài khoản, vui lòng thử lại", StandardCharsets.UTF_8));
            }
            return;
        }

        request.getRequestDispatcher("/web-page/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            User user = userDAO.login(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                request.getRequestDispatcher("/web-page/login.jsp").forward(request, response);
            }
        } else if ("register".equals(action)) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");

                User user = new User();
                user.setUsername(username);
                user.setEmail(email);
                user.setPhone(phone);
                user.setPassword(password);

                if (userDAO.register(user)) {
                    User created = userDAO.getUserByEmail(email);
                    boolean emailSent = false;
                    if (created != null) {
                        String token = java.util.UUID.randomUUID().toString();
                        boolean saved = userDAO.saveVerificationToken(created.getUserId(), token);
                        if (saved) {
                            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" +
                                    request.getServerPort() + request.getContextPath();
                            emailSent = com.phonecard.util.EmailUtil.sendVerificationEmail(created.getEmail(), token, baseUrl);
                        }
                    }
                    if (emailSent) {
                        String msg = "Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt tài khoản.";
                        String encodedMsg = URLEncoder.encode(msg, StandardCharsets.UTF_8);
                        response.sendRedirect(request.getContextPath() + "/auth?success=" + encodedMsg);
                    } else {
                        request.setAttribute("error", "Đăng ký thành công nhưng không gửi được email xác thực. Vui lòng thử lại.");
                        request.getRequestDispatcher("/web-page/register.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Đăng ký thất bại");
                    request.getRequestDispatcher("/web-page/register.jsp").forward(request, response);
                }
        } else if ("forgot-password".equals(action)) {
            handleForgotPassword(request, response);
        } else if ("reset-password".equals(action)) {
            handleResetPassword(request, response);
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher("/web-page/forget-password.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.getUserByEmail(email.trim());
        
        if (user == null) {
            request.setAttribute("success", "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi hướng dẫn đặt lại mật khẩu.");
            request.getRequestDispatcher("/web-page/forget-password.jsp").forward(request, response);
            return;
        }
        
        if ("Locked".equals(user.getStatus())) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ admin.");
            request.getRequestDispatcher("/web-page/forget-password.jsp").forward(request, response);
            return;
        }
        
        String token = String.format("%06d", new java.security.SecureRandom().nextInt(1_000_000));
        
        if (userDAO.savePasswordResetToken(user.getUserId(), token)) {
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + 
                           request.getServerPort() + request.getContextPath();
            
            boolean emailSent = EmailUtil.sendPasswordResetEmail(user.getEmail(), token, baseUrl);
            
            if (emailSent) {
                request.setAttribute("success", "Đã gửi mã OTP tới email của bạn. Vui lòng kiểm tra hộp thư.");
                request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
            }
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
        }
        
        request.getRequestDispatcher("/web-page/forget-password.jsp").forward(request, response);
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP");
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
            return;
        }
        
        Integer userId = userDAO.getUserIdByResetToken(token);
        if (userId == null) {
            request.setAttribute("error", "Mã OTP hết hạn hoặc không hợp lệ.");
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (userDAO.resetPassword(userId, newPassword)) {
            userDAO.deleteResetToken(token);
            
            User user = userDAO.getUserById(userId);
            if (user != null) {
                EmailUtil.sendPasswordChangedNotification(user.getEmail(), user.getUsername());
            }
            
            String msg = "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.";
            response.sendRedirect(request.getContextPath() + "/auth?success=" + 
                URLEncoder.encode(msg, StandardCharsets.UTF_8));
        } else {
            request.setAttribute("error", "Không thể đặt lại mật khẩu. Vui lòng thử lại.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("/web-page/reset-password.jsp").forward(request, response);
        }
    }
}