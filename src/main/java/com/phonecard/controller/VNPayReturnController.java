package com.phonecard.controller;

import com.phonecard.config.DBContext;
import com.phonecard.dao.*;
import com.phonecard.model.*;
import com.phonecard.util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VNPayReturnController", urlPatterns = {"/vnpay-return"})
public class VNPayReturnController extends HttpServlet {
    
    private TransactionDAO transactionDAO = new TransactionDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private CardInventoryDAO inventoryDAO = new CardInventoryDAO();
    private PaymentGatewayLogDAO logDAO = new PaymentGatewayLogDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Map<String, String> params = new HashMap<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (paramValue != null && !paramValue.isEmpty()) {
                params.put(paramName, paramValue);
            }
        }
        
        if (!VNPayUtil.validateSignature(params)) {
            request.setAttribute("error", "Chữ ký không hợp lệ");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
            return;
        }
        
        String vnpResponseCode = params.get("vnp_ResponseCode");
        String vnpTxnRef = params.get("vnp_TxnRef"); // transId
        String vnpTransactionNo = params.get("vnp_TransactionNo");
        String vnpAmount = params.get("vnp_Amount");
        
        long transId;
        try {
            transId = Long.parseLong(vnpTxnRef);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã giao dịch không hợp lệ");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
            return;
        }
        
        Transaction trans = transactionDAO.getTransactionById(transId);
        if (trans == null) {
            request.setAttribute("error", "Không tìm thấy giao dịch");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
            return;
        }
        
        if (!"Pending".equals(trans.getStatus())) {
            // Giao dịch đã được xử lý, hiển thị kết quả
            Order order = orderDAO.getOrderById(trans.getOrderId());
            request.setAttribute("order", order);
            request.setAttribute("success", "Completed".equals(order.getStatus()));
            request.setAttribute("message", "Success".equals(trans.getStatus()) ? 
                "Giao dịch đã được xử lý thành công trước đó" : "Giao dịch đã thất bại");
            request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            PaymentGatewayLog log = new PaymentGatewayLog();
            log.setTransId(transId);
            log.setGatewayName("VNPAY");
            log.setGatewayTransId(vnpTransactionNo);
            log.setResponseCode(vnpResponseCode);
            logDAO.createLog(log, conn);
            
            if ("00".equals(vnpResponseCode)) {
                transactionDAO.updateTransactionStatus(transId, "Success", conn);
                orderDAO.updateOrderStatus(trans.getOrderId(), "Completed", conn);
                
                Order order = orderDAO.getOrderById(trans.getOrderId());
                if (order != null) {
                    inventoryDAO.updateCardStatus(order.getCardId(), "Sold", conn);
                }
                
                conn.commit();
                
                HttpSession session = request.getSession(false);
                if (session != null) {
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        User freshUser = userDAO.refreshUser(user.getUserId());
                        session.setAttribute("user", freshUser);
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/purchase-result?orderId=" + trans.getOrderId());
                
            } else {
                transactionDAO.updateTransactionStatus(transId, "Failed", conn);
                orderDAO.updateOrderStatus(trans.getOrderId(), "Cancelled", conn);
                
                Order order = orderDAO.getOrderById(trans.getOrderId());
                if (order != null) {
                    inventoryDAO.updateCardStatus(order.getCardId(), "Available", conn);
                }
                
                conn.commit();
                
                request.setAttribute("success", false);
                request.setAttribute("error", VNPayUtil.getResponseMessage(vnpResponseCode));
                request.setAttribute("responseCode", vnpResponseCode);
                request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý kết quả thanh toán");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/payment-result.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
}

