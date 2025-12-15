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

/**
 * Controller xử lý luồng mua thẻ cào
 * - /purchase?productId=xxx: Hiển thị trang checkout
 * - POST /purchase: Xử lý thanh toán (wallet hoặc vnpay)
 */
@WebServlet(name = "PurchaseController", urlPatterns = {"/purchase"})
public class PurchaseController extends HttpServlet {
    
    private CardProductDAO productDAO = new CardProductDAO();
    private CardInventoryDAO inventoryDAO = new CardInventoryDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();
    private UserDAO userDAO = new UserDAO();

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
        
        // Lấy thông tin sản phẩm
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            CardProduct product = productDAO.getCardProductById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            
            // Kiểm tra còn hàng không
            if (product.getAvailableCount() <= 0) {
                request.setAttribute("error", "Sản phẩm đã hết hàng");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/web-page/product-details.jsp").forward(request, response);
                return;
            }
            
            // Refresh thông tin user để lấy số dư mới nhất
            User freshUser = userDAO.refreshUser(user.getUserId());
            session.setAttribute("user", freshUser);
            
            request.setAttribute("product", product);
            request.setAttribute("user", freshUser);
            request.getRequestDispatcher("/web-page/checkout.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String productIdStr = request.getParameter("productId");
        String paymentMethod = request.getParameter("paymentMethod"); // wallet hoặc vnpay
        
        if (productIdStr == null || paymentMethod == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            CardProduct product = productDAO.getCardProductById(productId);
            
            if (product == null || product.getAvailableCount() <= 0) {
                String msg = URLEncoder.encode("Sản phẩm không tồn tại hoặc đã hết hàng", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }
            
            BigDecimal sellingPrice = BigDecimal.valueOf(product.getSellingPrice());
            
            if ("wallet".equals(paymentMethod)) {
                // Thanh toán bằng ví
                processWalletPayment(request, response, user, product, sellingPrice);
            } else if ("vnpay".equals(paymentMethod)) {
                // Thanh toán qua VNPay
                processVNPayPayment(request, response, user, product, sellingPrice);
            } else {
                response.sendRedirect(request.getContextPath() + "/purchase?productId=" + productId);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    /**
     * Xử lý thanh toán bằng ví
     */
    private void processWalletPayment(HttpServletRequest request, HttpServletResponse response,
                                       User user, CardProduct product, BigDecimal amount) 
            throws IOException, ServletException {
        
        // Refresh số dư ví
        BigDecimal walletBalance = userDAO.getWalletBalance(user.getUserId());
        
        // Kiểm tra số dư
        if (walletBalance.compareTo(amount) < 0) {
            // Không đủ tiền - chuyển đến trang nạp tiền
            BigDecimal needMore = amount.subtract(walletBalance);
            request.setAttribute("product", product);
            request.setAttribute("user", user);
            request.setAttribute("needMore", needMore);
            request.setAttribute("error", "Số dư ví không đủ. Bạn cần nạp thêm " + 
                String.format("%,.0f", needMore.doubleValue()) + "₫");
            request.getRequestDispatcher("/web-page/checkout.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Lấy thẻ khả dụng từ kho
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId());
            if (card == null) {
                conn.rollback();
                String msg = URLEncoder.encode("Đã hết thẻ trong kho, vui lòng thử lại sau", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }
            
            // 2. Tạo đơn hàng
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setCardId(card.getCardId());
            order.setPrice(amount);
            order.setDiscountAmount(BigDecimal.ZERO);
            order.setFinalAmount(amount);
            order.setStatus("Completed");
            
            long orderId = orderDAO.createOrder(order, conn);
            if (orderId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo đơn hàng");
            }
            
            // 3. Trừ tiền ví
            if (!userDAO.updateWalletBalance(user.getUserId(), amount.negate(), conn)) {
                conn.rollback();
                throw new Exception("Không thể trừ tiền ví");
            }
            
            // 4. Cập nhật trạng thái thẻ
            if (!inventoryDAO.updateCardStatus(card.getCardId(), "Sold", conn)) {
                conn.rollback();
                throw new Exception("Không thể cập nhật trạng thái thẻ");
            }
            
            // 5. Tạo transaction record
            Transaction trans = new Transaction();
            trans.setUserId(user.getUserId());
            trans.setOrderId(orderId);
            trans.setType("PAYMENT");
            trans.setAmount(amount);
            trans.setDescription("Mua thẻ " + product.getProductName());
            trans.setStatus("Success");
            transactionDAO.createTransaction(trans, conn);
            
            conn.commit();
            
            // Refresh session user
            User freshUser = userDAO.refreshUser(user.getUserId());
            request.getSession().setAttribute("user", freshUser);
            
            // Chuyển đến trang kết quả
            response.sendRedirect(request.getContextPath() + "/purchase-result?orderId=" + orderId);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            String msg = URLEncoder.encode("Có lỗi xảy ra, vui lòng thử lại", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }

    /**
     * Xử lý thanh toán qua VNPay - Tạo URL và redirect
     */
    private void processVNPayPayment(HttpServletRequest request, HttpServletResponse response,
                                      User user, CardProduct product, BigDecimal amount) 
            throws IOException {
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Lấy và lock thẻ khả dụng
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId());
            if (card == null) {
                conn.rollback();
                String msg = URLEncoder.encode("Đã hết thẻ trong kho, vui lòng thử lại sau", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }
            
            // 2. Tạo đơn hàng pending
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setCardId(card.getCardId());
            order.setPrice(amount);
            order.setDiscountAmount(BigDecimal.ZERO);
            order.setFinalAmount(amount);
            order.setStatus("Pending");
            
            long orderId = orderDAO.createOrder(order, conn);
            if (orderId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo đơn hàng");
            }
            
            // 3. Tạo transaction pending
            Transaction trans = new Transaction();
            trans.setUserId(user.getUserId());
            trans.setOrderId(orderId);
            trans.setType("PAYMENT");
            trans.setAmount(amount);
            trans.setDescription("Thanh toán VNPay - Mua thẻ " + product.getProductName());
            trans.setStatus("Pending");
            
            long transId = transactionDAO.createTransaction(trans, conn);
            if (transId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo giao dịch");
            }
            
            conn.commit();
            
            // 4. Tạo URL VNPay
            String baseUrl = VNPayUtil.getBaseUrl(request);
            String returnUrl = VNPayConfig.getReturnUrl(request.getContextPath(), baseUrl);
            String ipAddress = VNPayUtil.getIpAddress(request);
            String orderInfo = "Thanh toan don hang " + orderId;
            
            String paymentUrl = VNPayUtil.createPaymentUrl(
                amount.longValue(),
                orderInfo,
                String.valueOf(transId), // Dùng transId làm vnp_TxnRef
                ipAddress,
                returnUrl
            );
            
            // Lưu orderId vào session để verify sau
            request.getSession().setAttribute("pendingOrderId", orderId);
            request.getSession().setAttribute("pendingTransId", transId);
            
            response.sendRedirect(paymentUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            String msg = URLEncoder.encode("Có lỗi xảy ra khi tạo thanh toán VNPay", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
}

