package com.phonecard.controller;

import com.phonecard.config.DBContext;
import com.phonecard.dao.*;
import com.phonecard.model.*;
import com.phonecard.util.VNPayConfig;
import com.phonecard.util.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "DepositController", urlPatterns = {"/deposit", "/deposit-return"})
public class DepositController extends HttpServlet {
    
    private TransactionDAO transactionDAO = new TransactionDAO();
    private UserDAO userDAO = new UserDAO();
    private PaymentGatewayLogDAO logDAO = new PaymentGatewayLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/deposit-return".equals(path)) {
            handleDepositReturn(request, response);
            return;
        }
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        User freshUser = userDAO.refreshUser(user.getUserId());
        session.setAttribute("user", freshUser);
        
        String suggestedAmount = request.getParameter("amount");
        String returnTo = request.getParameter("returnTo");
        
        request.setAttribute("user", freshUser);
        request.setAttribute("suggestedAmount", suggestedAmount);
        request.setAttribute("returnTo", returnTo);
        request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String amountStr = request.getParameter("amount");
        String returnTo = request.getParameter("returnTo");
        
        if (amountStr == null || amountStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập số tiền cần nạp");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
            return;
        }
        
        try {
            long amount = Long.parseLong(amountStr.replaceAll("[^0-9]", ""));
            
            if (amount < 10000) {
                request.setAttribute("error", "Số tiền nạp tối thiểu là 10,000₫");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
                return;
            }
            
            if (amount > 100000000) {
                request.setAttribute("error", "Số tiền nạp tối đa là 100,000,000₫");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
                return;
            }
            
            Transaction trans = new Transaction();
            trans.setUserId(user.getUserId());
            trans.setOrderId(null);
            trans.setType("DEPOSIT");
            trans.setAmount(BigDecimal.valueOf(amount));
            trans.setDescription("Nạp tiền vào ví qua VNPay");
            trans.setStatus("Pending");
            
            long transId = transactionDAO.createTransaction(trans);
            if (transId == -1) {
                request.setAttribute("error", "Không thể tạo giao dịch, vui lòng thử lại");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
                return;
            }
            
            if (returnTo != null && !returnTo.isEmpty()) {
                session.setAttribute("depositReturnTo", returnTo);
            }
            
            String baseUrl = VNPayUtil.getBaseUrl(request);
            String returnUrl = baseUrl + request.getContextPath() + "/deposit-return";
            String ipAddress = VNPayUtil.getIpAddress(request);
            String orderInfo = "Nap tien vi PhoneCard - " + user.getUsername();
            
            String paymentUrl = VNPayUtil.createPaymentUrl(
                amount,
                orderInfo,
                String.valueOf(transId),
                ipAddress,
                returnUrl
            );
            
            response.sendRedirect(paymentUrl);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số tiền không hợp lệ");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/web-page/deposit.jsp").forward(request, response);
        }
    }
    
    private void handleDepositReturn(HttpServletRequest request, HttpServletResponse response)
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
            request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
            return;
        }
        
        String vnpResponseCode = params.get("vnp_ResponseCode");
        String vnpTxnRef = params.get("vnp_TxnRef");
        String vnpTransactionNo = params.get("vnp_TransactionNo");
        String vnpAmount = params.get("vnp_Amount");
        
        long transId;
        try {
            transId = Long.parseLong(vnpTxnRef);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã giao dịch không hợp lệ");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
            return;
        }
        
        Transaction trans = transactionDAO.getTransactionById(transId);
        if (trans == null) {
            request.setAttribute("error", "Không tìm thấy giao dịch");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
            return;
        }
        
        if (!"Pending".equals(trans.getStatus())) {
            request.setAttribute("success", "Success".equals(trans.getStatus()));
            request.setAttribute("message", "Success".equals(trans.getStatus()) ? 
                "Giao dịch đã được xử lý thành công" : "Giao dịch đã thất bại");
            request.setAttribute("amount", trans.getAmount());
            request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
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
                userDAO.updateWalletBalance(trans.getUserId(), trans.getAmount(), conn);
                
                conn.commit();
                
                HttpSession session = request.getSession(false);
                if (session != null) {
                    User user = (User) session.getAttribute("user");
                    if (user != null) {
                        User freshUser = userDAO.refreshUser(user.getUserId());
                        session.setAttribute("user", freshUser);
                    }
                    
                    String returnTo = (String) session.getAttribute("depositReturnTo");
                    if (returnTo != null && !returnTo.isEmpty()) {
                        session.removeAttribute("depositReturnTo");
                        response.sendRedirect(request.getContextPath() + returnTo);
                        return;
                    }
                }
                
                request.setAttribute("success", true);
                request.setAttribute("amount", trans.getAmount());
                request.setAttribute("message", "Nạp tiền thành công!");
                request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
                
            } else {
                transactionDAO.updateTransactionStatus(transId, "Failed", conn);
                conn.commit();
                
                request.setAttribute("success", false);
                request.setAttribute("error", VNPayUtil.getResponseMessage(vnpResponseCode));
                request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý kết quả");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/web-page/deposit-result.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
}

