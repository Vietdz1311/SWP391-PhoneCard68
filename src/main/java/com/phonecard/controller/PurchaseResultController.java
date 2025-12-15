package com.phonecard.controller;

import com.phonecard.dao.OrderDAO;
import com.phonecard.model.Order;
import com.phonecard.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller hiển thị kết quả mua hàng thành công
 */
@WebServlet(name = "PurchaseResultController", urlPatterns = {"/purchase-result"})
public class PurchaseResultController extends HttpServlet {
    
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            long orderId = Long.parseLong(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);
            
            // Kiểm tra order thuộc về user đang đăng nhập
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            
            request.setAttribute("order", order);
            request.setAttribute("success", "Completed".equals(order.getStatus()));
            request.getRequestDispatcher("/web-page/purchase-result.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}

