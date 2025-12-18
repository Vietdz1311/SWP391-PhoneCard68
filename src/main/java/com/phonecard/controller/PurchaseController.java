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
    
// DAO dùng để thao tác dữ liệu sản phẩm thẻ cào (Card_Products)
private CardProductDAO productDAO = new CardProductDAO();

// DAO dùng để thao tác kho thẻ (Card_Inventory)
private CardInventoryDAO inventoryDAO = new CardInventoryDAO();

// DAO dùng để thao tác đơn hàng (Orders)
private OrderDAO orderDAO = new OrderDAO();

// DAO dùng để thao tác giao dịch (Transactions)
private TransactionDAO transactionDAO = new TransactionDAO();

// DAO dùng để thao tác thông tin người dùng (Users)
private UserDAO userDAO = new UserDAO();

// DAO dùng để thao tác mã giảm giá (Promotions)
private PromotionDAO promotionDAO = new PromotionDAO();

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

            // Xử lý áp dụng mã giảm giá (chỉ để hiển thị trước)
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
        
        // Kiểm tra đăng nhập
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

            // Xử lý mã giảm giá (nếu có)
            Promotion appliedPromotion = null;
            BigDecimal discountAmount = BigDecimal.ZERO;
            BigDecimal finalAmount = sellingPrice;

            if (promoCode != null && !promoCode.trim().isEmpty()) {
                promoCode = promoCode.trim();
                appliedPromotion = promotionDAO.getActivePromotionByCode(promoCode);

                // Kiểm tra hợp lệ
                if (appliedPromotion == null) {
                    setCheckoutError(request, response, product, user, "Mã giảm giá không hợp lệ hoặc đã hết hạn", promoCode);
                    return;
                }
                if (appliedPromotion.getMinOrderValue() != null
                        && sellingPrice.compareTo(appliedPromotion.getMinOrderValue()) < 0) {
                    setCheckoutError(request, response, product, user, "Đơn hàng chưa đạt giá trị tối thiểu của mã giảm giá", promoCode);
                    return;
                }
                // Giới hạn tổng số lượt sử dụng
                if (appliedPromotion.getUsageLimit() > 0 &&
                        promotionDAO.countUsage(appliedPromotion.getPromotionId()) >= appliedPromotion.getUsageLimit()) {
                    setCheckoutError(request, response, product, user, "Mã giảm giá đã đạt giới hạn sử dụng", promoCode);
                    return;
                }
                // Giới hạn mỗi user
                if (appliedPromotion.getUsagePerUser() > 0 &&
                        promotionDAO.countUsageByUser(appliedPromotion.getPromotionId(), user.getUserId()) >= appliedPromotion.getUsagePerUser()) {
                    setCheckoutError(request, response, product, user, "Bạn đã dùng hết số lần cho mã này", promoCode);
                    return;
                }

                // Tính chiết khấu
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

            // Lấy số dư ví để chọn mặc định nếu người dùng chưa chọn radio
            BigDecimal walletBalance = userDAO.getWalletBalance(user.getUserId());
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                paymentMethod = walletBalance.compareTo(finalAmount) >= 0 ? "wallet" : "vnpay";
            }

            if ("wallet".equals(paymentMethod)) {
                // Thanh toán bằng ví
                processWalletPayment(request, response, user, product, appliedPromotion, discountAmount, finalAmount, promoCode, walletBalance);
            } else if ("vnpay".equals(paymentMethod)) {
                // Thanh toán qua VNPay
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

    /**
     * Xử lý thanh toán bằng ví
     */
    private void processWalletPayment(HttpServletRequest request, HttpServletResponse response,
                                       User user, CardProduct product, Promotion promotion,
                                       BigDecimal discountAmount, BigDecimal finalAmount,
                                       String promoCode, BigDecimal walletBalance) 
            throws IOException, ServletException {

        // Kiểm tra số dư
        if (walletBalance.compareTo(finalAmount) < 0) {
            // Không đủ tiền - chuyển đến trang nạp tiền
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
            
            // 1. Lấy thẻ khả dụng từ kho (lock cùng transaction)
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId(), conn);
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
            
            // 3. Trừ tiền ví
            if (!userDAO.updateWalletBalance(user.getUserId(), finalAmount.negate(), conn)) {
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
            trans.setAmount(finalAmount);
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
                                      User user, CardProduct product, Promotion promotion,
                                      BigDecimal discountAmount, BigDecimal finalAmount) 
            throws IOException, ServletException {
        
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Lấy và lock thẻ khả dụng (cùng transaction)
            CardInventory card = inventoryDAO.getAvailableCard(product.getProductId(), conn);
            if (card == null) {
                conn.rollback();
                String msg = URLEncoder.encode("Đã hết thẻ trong kho, vui lòng thử lại sau", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/products?error=" + msg);
                return;
            }

            // 1.1 Đánh dấu thẻ là đã được giữ chỗ để tránh order trùng card_id
            boolean reserved = inventoryDAO.updateCardStatus(card.getCardId(), "Sold", conn);
            if (!reserved) {
                conn.rollback();
                throw new Exception("Không thể giữ chỗ thẻ, vui lòng thử lại");
            }
            
            // 2. Tạo đơn hàng pending
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
            
            // 3. Tạo transaction pending
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
            
            // 4. Tạo URL VNPay
            String baseUrl = VNPayUtil.getBaseUrl(request);
            String returnUrl = VNPayConfig.getReturnUrl(request.getContextPath(), baseUrl);
            String ipAddress = VNPayUtil.getIpAddress(request);
            String orderInfo = "Thanh toan don hang " + orderId;
            
            String paymentUrl = VNPayUtil.createPaymentUrl(
                finalAmount.longValue(),
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
            // Giữ nguyên trang checkout và hiển thị lỗi để người dùng thấy rõ
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

