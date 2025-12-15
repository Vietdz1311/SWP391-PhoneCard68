/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.phonecard.controller;

import com.phonecard.dao.UserDAO;
import com.phonecard.model.User;
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
                    String msg = "Đăng kí tài khoản thành công";
                    String encodedMsg = URLEncoder.encode(msg, StandardCharsets.UTF_8.toString());
                    response.sendRedirect(request.getContextPath() + "/auth?success=" + encodedMsg);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại");
                    request.getRequestDispatcher("/web-page/register.jsp").forward(request, response);
                }
            }
    }
}