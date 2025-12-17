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

@WebServlet(name = "PurchaseController", urlPatterns = {"/purchase"})
public class PurchaseController extends HttpServlet {
    
    private CardProductDAO productDAO = new CardProductDAO();
    private CardInventoryDAO inventoryDAO = new CardInventoryDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();
    private UserDAO userDAO = new UserDAO();
    private PromotionDAO promotionDAO = new PromotionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
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
            
            if (product.getAvailableCount() <= 0) {
                request.setAttribute("error", "Sản phẩm đã hết hàng");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/web-page/product-details.jsp").forward(request, response);
                return;
            }
            
            User freshUser = userDAO.refreshUser(user.getUserId());
            session.setAttribute("user", freshUser);

            BigDecimal sellingPrice = BigDecimal.valueOf(product.getSellingPrice());
            BigDecimal discountAmount = BigDecimal.ZERO;
            BigDecimal finalAmount = sellingPrice;
            Promotion appliedPromotion = null;

            String promoCode = request.getParameter("promoCode");
            if (promoCode != null && !promoCode.trim().isEmpty()) {
                promoCode = promoCode.trim();
                appliedPromotion = promotionDAO.getActivePromotionByCode(promoCode);
                if (appliedPromotion == null) {
                    request.setAttribute("error", "Mã giảm giá không hợp lệ hoặc đã hết hạn");
                } else if (appliedPromotion.getMinOrderValue() != null
                        && sellingPrice.compareTo(appliedPromotion.getMinOrderValue()) < 0) {
                    request.setAttribute("error", "Đơn hàng chưa đạt giá trị tối thiểu của mã giảm giá");
                    appliedPromotion = null;
                } else if (appliedPromotion.getUsageLimit() > 0 &&
                        promotionDAO.countUsage(appliedPromotion.getPromotionId()) >= appliedPromotion.getUsageLimit()) {
                    request.setAttribute("error", "Mã giảm giá đã đạt giới hạn sử dụng");
                    appliedPromotion = null;
                } else if (appliedPromotion.getUsagePerUser() > 0 &&
                        promotionDAO.countUsageByUser(appliedPromotion.getPromotionId(), user.getUserId()) >= appliedPromotion.getUsagePerUser()) {
                    request.setAttribute("error", "Bạn đã dùng hết số lần cho mã này");
                    appliedPromotion = null;
                }

                if (appliedPromotion != null) {
                    if ("PERCENTAGE".equalsIgnoreCase(appliedPromotion.getDiscountType())) {
                        discountAmount = sellingPrice
                                .multiply(appliedPromotion.getDiscountValue())
                                .divide(BigDecimal.valueOf(100));
                    } else {
                        discountAmount = appliedPromotion.getDiscountValue();
                    }
                    if (discountAmount.compareTo(sellingPrice) > 0) {
                        discountAmount = sellingPrice;
                    }
                    finalAmount = sellingPrice.subtract(discountAmount);
                }

                request.setAttribute("promoCode", promoCode);
            }

            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("finalAmount", finalAmount);
            request.setAttribute("appliedPromotion", appliedPromotion);
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
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String productIdStr = request.getParameter("productId");
        String paymentMethod = request.getParameter("paymentMethod"); // wallet hoặc vnpay
        String promoCode = request.getParameter("promoCode");
        
        if (productIdStr == null) {
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

            Promotion appliedPromotion = null;
            BigDecimal discountAmount = BigDecimal.ZERO;
            BigDecimal finalAmount = sellingPrice;

            if (promoCode != null && !promoCode.trim().isEmpty()) {
                promoCode = promoCode.trim();
                appliedPromotion = promotionDAO.getActivePromotionByCode(promoCode);

                if (appliedPromotion == null) {
                    setCheckoutError(request, response, product, user, "Mã giảm giá không hợp lệ hoặc đã hết hạn", promoCode);
                    return;
                }
                if (appliedPromotion.getMinOrderValue() != null
                        && sellingPrice.compareTo(appliedPromotion.getMinOrderValue()) < 0) {
                    setCheckoutError(request, response, product, user, "Đơn hàng chưa đạt giá trị tối thiểu của mã giảm giá", promoCode);
                    return;
                }
                if (appliedPromotion.getUsageLimit() > 0 &&
                        promotionDAO.countUsage(appliedPromotion.getPromotionId()) >= appliedPromotion.getUsageLimit()) {
                    setCheckoutError(request, response, product, user, "Mã giảm giá đã đạt giới hạn sử dụng", promoCode);
                    return;
                }
                if (appliedPromotion.getUsagePerUser() > 0 &&
                        promotionDAO.countUsageByUser(appliedPromotion.getPromotionId(), user.getUserId()) >= appliedPromotion.getUsagePerUser()) {
                    setCheckoutError(request, response, product, user, "Bạn đã dùng hết số lần cho mã này", promoCode);
                    return;
                }

                if ("PERCENTAGE".equalsIgnoreCase(appliedPromotion.getDiscountType())) {
                    discountAmount = sellingPrice
                            .multiply(appliedPromotion.getDiscountValue())
                            .divide(BigDecimal.valueOf(100));
                } else {
                    discountAmount = appliedPromotion.getDiscountValue();
                }
                if (discountAmount.compareTo(sellingPrice) > 0) {
                    discountAmount = sellingPrice;
                }
                finalAmount = sellingPrice.subtract(discountAmount);
            }

            BigDecimal walletBalance = userDAO.getWalletBalance(user.getUserId());
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                paymentMethod = walletBalance.compareTo(finalAmount) >= 0 ? "wallet" : "vnpay";
            }

            if ("wallet".equals(paymentMethod)) {
                processWalletPayment(request, response, user, product, appliedPromotion, discountAmount, finalAmount, promoCode, walletBalance);
            } else if ("vnpay".equals(paymentMethod)) {
                processVNPayPayment(request, response, user, product, appliedPromotion, discountAmount, finalAmount);
            } else {
                response.sendRedirect(request.getContextPath() + "/purchase?productId=" + productId);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void setCheckoutError(HttpServletRequest request, HttpServletResponse response,
                                  CardProduct product, User user, String message, String promoCode)
            throws ServletException, IOException {
        request.setAttribute("product", product);
        request.setAttribute("user", user);
        request.setAttribute("error", message);
        request.setAttribute("discountAmount", BigDecimal.ZERO);
        request.setAttribute("finalAmount", BigDecimal.valueOf(product.getSellingPrice()));
        if (promoCode != null) {
            request.setAttribute("promoCode", promoCode);
        }
        request.getRequestDispatcher("/web-page/checkout.jsp").forward(request, response);
    }

    private void processWalletPayment(HttpServletRequest request, HttpServletResponse response,
                                       User user, CardProduct product, Promotion promotion,
                                       BigDecimal discountAmount, BigDecimal finalAmount,
                                       String promoCode, BigDecimal walletBalance) 
            throws IOException, ServletException {

        if (walletBalance.compareTo(finalAmount) < 0) {
            BigDecimal needMore = finalAmount.subtract(walletBalance);
            request.setAttribute("product", product);
            request.setAttribute("user", user);
            request.setAttribute("needMore", needMore);
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("finalAmount", finalAmount);
            request.setAttribute("promoCode", promoCode);
            request.setAttribute("error", "Số dư ví không đủ. Bạn cần nạp thêm " + 
                String.format("%,.0f", needMore.doubleValue()) + "₫");
            request.getRequestDispatcher("/web-page/checkout.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId(), conn);
            if (card == null) {
                conn.rollback();
                String msg = URLEncoder.encode("Đã hết thẻ trong kho, vui lòng thử lại sau", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }
            
            
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setCardId(card.getCardId());
            order.setPrice(BigDecimal.valueOf(product.getSellingPrice()));
            order.setDiscountAmount(discountAmount);
            order.setFinalAmount(finalAmount);
            if (promotion != null) {
                order.setPromotionId(promotion.getPromotionId());
            }
            order.setStatus("Completed");
            
            long orderId = orderDAO.createOrder(order, conn);
            if (orderId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo đơn hàng");
            }
            
            if (!userDAO.updateWalletBalance(user.getUserId(), finalAmount.negate(), conn)) {
                conn.rollback();
                throw new Exception("Không thể trừ tiền ví");
            }
            
            if (!inventoryDAO.updateCardStatus(card.getCardId(), "Sold", conn)) {
                conn.rollback();
                throw new Exception("Không thể cập nhật trạng thái thẻ");
            }
            
            Transaction trans = new Transaction();
            trans.setUserId(user.getUserId());
            trans.setOrderId(orderId);
            trans.setType("PAYMENT");
            trans.setAmount(finalAmount);
            trans.setDescription("Mua thẻ " + product.getProductName());
            trans.setStatus("Success");
            transactionDAO.createTransaction(trans, conn);
            
            conn.commit();
            
            User freshUser = userDAO.refreshUser(user.getUserId());
            request.getSession().setAttribute("user", freshUser);
            
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

    private void processVNPayPayment(HttpServletRequest request, HttpServletResponse response,
                                      User user, CardProduct product, Promotion promotion,
                                      BigDecimal discountAmount, BigDecimal finalAmount) 
            throws IOException, ServletException {
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId(), conn);
            if (card == null) {
                conn.rollback();
                String msg = URLEncoder.encode("Đã hết thẻ trong kho, vui lòng thử lại sau", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }

            boolean reserved = inventoryDAO.updateCardStatus(card.getCardId(), "Sold", conn);
            if (!reserved) {
                conn.rollback();
                throw new Exception("Không thể giữ chỗ thẻ, vui lòng thử lại");
            }
            
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setCardId(card.getCardId());
            order.setPrice(BigDecimal.valueOf(product.getSellingPrice()));
            order.setDiscountAmount(discountAmount);
            order.setFinalAmount(finalAmount);
            if (promotion != null) {
                order.setPromotionId(promotion.getPromotionId());
            }
            order.setStatus("Pending");
            
            long orderId = orderDAO.createOrder(order, conn);
            if (orderId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo đơn hàng");
            }
            
            Transaction trans = new Transaction();
            trans.setUserId(user.getUserId());
            trans.setOrderId(orderId);
            trans.setType("PAYMENT");
            trans.setAmount(finalAmount);
            trans.setDescription("Thanh toán VNPay - Mua thẻ " + product.getProductName());
            trans.setStatus("Pending");
            
            long transId = transactionDAO.createTransaction(trans, conn);
            if (transId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo giao dịch");
            }
            
            conn.commit();
            
            String baseUrl = VNPayUtil.getBaseUrl(request);
            String returnUrl = VNPayConfig.getReturnUrl(request.getContextPath(), baseUrl);
            String ipAddress = VNPayUtil.getIpAddress(request);
            String orderInfo = "Thanh toan don hang " + orderId;
            
            String paymentUrl = VNPayUtil.createPaymentUrl(
                finalAmount.longValue(),
                orderInfo,
                String.valueOf(transId),
                ipAddress,
                returnUrl
            );
            
            request.getSession().setAttribute("pendingOrderId", orderId);
            request.getSession().setAttribute("pendingTransId", transId);
            
            response.sendRedirect(paymentUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            String friendly = "Có lỗi xảy ra khi tạo thanh toán VNPay";
            if (e.getMessage() != null && !e.getMessage().isEmpty()) {
                friendly += ": " + e.getMessage();
            }
            forwardVNPayError(request, response, product, user, discountAmount, finalAmount, promotion, friendly);
            return;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }

    private void forwardVNPayError(HttpServletRequest request, HttpServletResponse response,
                                   CardProduct product, User user,
                                   BigDecimal discountAmount, BigDecimal finalAmount,
                                   Promotion promotion, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("product", product);
        request.setAttribute("user", user);
        request.setAttribute("discountAmount", discountAmount != null ? discountAmount : BigDecimal.ZERO);
        request.setAttribute("finalAmount", finalAmount != null ? finalAmount : BigDecimal.ZERO);
        if (promotion != null) {
            request.setAttribute("appliedPromotion", promotion);
        }
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/web-page/checkout.jsp").forward(request, response);
    }
}

