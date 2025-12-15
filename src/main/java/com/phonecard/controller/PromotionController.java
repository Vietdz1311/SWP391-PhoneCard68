package com.phonecard.controller;

import com.phonecard.dao.PromotionDAO;
import com.phonecard.model.Promotion;
import com.phonecard.model.User;
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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "PromotionController", urlPatterns = {"/admin/promotions", "/admin/promotion-create", "/admin/promotion-detail"})
public class PromotionController extends HttpServlet {

    private PromotionDAO promotionDAO = new PromotionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/web-page/admin/dashboard.jsp");
            return;
        }

        String servletPath = request.getServletPath();

        if (servletPath.contains("promotion-create")) {
            request.getRequestDispatcher("/web-page/admin/promotion-create.jsp").forward(request, response);
            return;
        }

        if (servletPath.contains("promotion-detail")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Promotion p = promotionDAO.getPromotionById(id);
                if (p == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/promotions");
                    return;
                }
                request.setAttribute("promo", p);
                request.getRequestDispatcher("/web-page/admin/promotion-detail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions");
            }
            return;
        }

        // --- LIST & PAGINATION LOGIC ---
        List<Promotion> allPromotions = promotionDAO.getAllPromotions();
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        // 1. Lọc dữ liệu (Filter)
        List<Promotion> filteredList = allPromotions.stream()
                .filter(p -> keyword == null || keyword.isEmpty() || p.getCode().toLowerCase().contains(keyword.toLowerCase()))
                .filter(p -> status == null || status.isEmpty() || "All".equals(status) || p.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());

        // 2. Xử lý Phân trang (Cắt List) - QUAN TRỌNG
        int page = 1;
        int pageSize = 5; // Giới hạn 5 dòng mỗi trang
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalItems = filteredList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Đảm bảo trang hợp lệ
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        // Tính vị trí cắt list
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalItems);

        List<Promotion> pagedList;
        if (start > end || totalItems == 0) {
            pagedList = new ArrayList<>();
        } else {
            pagedList = filteredList.subList(start, end); // Cắt lấy 5 phần tử
        }

        // 3. Gửi dữ liệu sang JSP
        request.setAttribute("promotions", pagedList); // Gửi list đã cắt (chỉ 5 dòng)
        request.setAttribute("totalCount", totalItems); // Tổng số lượng
        request.setAttribute("currentPage", page);      // Trang hiện tại
        request.setAttribute("totalPages", totalPages); // Tổng số trang
        
        // Gửi lại tham số tìm kiếm để giữ trạng thái
        request.setAttribute("paramKeyword", keyword);
        request.setAttribute("paramStatus", status);
        
        request.getRequestDispatcher("/web-page/admin/promotion-list.jsp").forward(request, response);
    }
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Lấy dữ liệu form
        String discountType = request.getParameter("discountType");
        BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
        BigDecimal minOrderValue = new BigDecimal(request.getParameter("minOrderValue"));
        LocalDateTime startDate = LocalDateTime.parse(request.getParameter("startDate"));
        LocalDateTime endDate = LocalDateTime.parse(request.getParameter("endDate"));
        int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
        int usagePerUser = Integer.parseInt(request.getParameter("usagePerUser"));

        // --- VALIDATE DỮ LIỆU (Server Side) ---
        String errorMsg = null;
        
        // 1. Validate Phần trăm > 100
        if ("PERCENTAGE".equals(discountType) && discountValue.compareTo(new BigDecimal("100")) > 0) {
            errorMsg = "Giảm giá theo phần trăm không được vượt quá 100%.";
        }
        // 2. Validate Tiền giảm > Đơn tối thiểu
        else if ("FIXED_AMOUNT".equals(discountType) && discountValue.compareTo(minOrderValue) > 0) {
            errorMsg = "Số tiền giảm (" + discountValue + ") không được lớn hơn Đơn hàng tối thiểu (" + minOrderValue + ").";
        }
        // 3. Validate Ngày tháng
        else if (startDate.isAfter(endDate)) {
            errorMsg = "Ngày bắt đầu phải trước ngày kết thúc.";
        }

        // Nếu có lỗi, trả về trang cũ
        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            
            // Tạo object tạm để giữ lại dữ liệu form
            Promotion tempP = new Promotion();
            tempP.setDiscountType(discountType);
            tempP.setDiscountValue(discountValue);
            tempP.setMinOrderValue(minOrderValue);
            tempP.setStartDate(startDate);
            tempP.setEndDate(endDate);
            tempP.setUsageLimit(usageLimit);
            tempP.setUsagePerUser(usagePerUser);
            
            if ("create".equals(action)) {
                tempP.setCode(request.getParameter("code"));
                request.setAttribute("promo", tempP);
                request.getRequestDispatcher("/web-page/admin/promotion-create.jsp").forward(request, response);
            } else {
                tempP.setPromotionId(Integer.parseInt(request.getParameter("promotionId")));
                tempP.setCode(request.getParameter("code"));
                tempP.setStatus(request.getParameter("status"));
                request.setAttribute("promo", tempP);
                request.getRequestDispatcher("/web-page/admin/promotion-detail.jsp").forward(request, response);
            }
            return;
        }

        // --- XỬ LÝ DATABASE ---
        if ("create".equals(action)) {
            String code = request.getParameter("code").toUpperCase().trim();
            if (promotionDAO.checkCodeExists(code)) {
                request.setAttribute("error", "Mã khuyến mãi '" + code + "' đã tồn tại!");
                request.getRequestDispatcher("/web-page/admin/promotion-create.jsp").forward(request, response);
                return;
            }
            Promotion p = new Promotion();
            p.setCode(code);
            p.setDiscountType(discountType);
            p.setDiscountValue(discountValue);
            p.setMinOrderValue(minOrderValue);
            p.setUsageLimit(usageLimit);
            p.setUsagePerUser(usagePerUser);
            p.setStartDate(startDate);
            p.setEndDate(endDate);

            if (promotionDAO.createPromotion(p)) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions?success=" + URLEncoder.encode("Tạo thành công", StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error", "Lỗi hệ thống.");
                request.getRequestDispatcher("/web-page/admin/promotion-create.jsp").forward(request, response);
            }
        } 
        else if ("update".equals(action)) {
            Promotion p = new Promotion();
            p.setPromotionId(Integer.parseInt(request.getParameter("promotionId")));
            p.setDiscountType(discountType);
            p.setDiscountValue(discountValue);
            p.setMinOrderValue(minOrderValue);
            p.setUsageLimit(usageLimit);
            p.setUsagePerUser(usagePerUser);
            p.setStatus(request.getParameter("status"));
            p.setStartDate(startDate);
            p.setEndDate(endDate);

            if (promotionDAO.updatePromotion(p)) {
                response.sendRedirect(request.getContextPath() + "/admin/promotion-detail?id=" + p.getPromotionId() + "&success=1");
            } else {
                request.setAttribute("error", "Cập nhật thất bại.");
                request.setAttribute("promo", p);
                request.getRequestDispatcher("/web-page/admin/promotion-detail.jsp").forward(request, response);
            }
        }
    }
}