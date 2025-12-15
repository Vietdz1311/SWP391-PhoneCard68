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
            int id = Integer.parseInt(request.getParameter("id"));
            Promotion p = promotionDAO.getPromotionById(id);
            request.setAttribute("promo", p);
            request.getRequestDispatcher("/web-page/admin/promotion-detail.jsp").forward(request, response);
            return;
        }

        List<Promotion> allPromotions = promotionDAO.getAllPromotions();
        
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Promotion> filteredList = allPromotions.stream()
                .filter(p -> keyword == null || keyword.isEmpty() || p.getCode().toLowerCase().contains(keyword.toLowerCase()))
                .filter(p -> status == null || status.isEmpty() || "All".equals(status) || p.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());

        
        request.setAttribute("promotions", filteredList);
        
        request.setAttribute("totalCount", filteredList.size());
        
        request.setAttribute("paramKeyword", keyword);
        request.setAttribute("paramStatus", status);
        
        request.getRequestDispatcher("/web-page/admin/promotion-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String code = request.getParameter("code").toUpperCase().trim();
            
            if (promotionDAO.checkCodeExists(code)) {
                request.setAttribute("error", "Mã khuyến mãi '" + code + "' đã tồn tại!");
                request.getRequestDispatcher("/web-page/admin/promotion-create.jsp").forward(request, response);
                return;
            }
            
            Promotion p = new Promotion();
            p.setCode(code);
            p.setDiscountType(request.getParameter("discountType"));
            p.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
            p.setMinOrderValue(new BigDecimal(request.getParameter("minOrderValue")));
            p.setUsageLimit(Integer.parseInt(request.getParameter("usageLimit")));
            p.setUsagePerUser(Integer.parseInt(request.getParameter("usagePerUser")));
            
            p.setStartDate(LocalDateTime.parse(request.getParameter("startDate")));
            p.setEndDate(LocalDateTime.parse(request.getParameter("endDate")));

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
            p.setDiscountType(request.getParameter("discountType"));
            p.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
            p.setMinOrderValue(new BigDecimal(request.getParameter("minOrderValue")));
            p.setUsageLimit(Integer.parseInt(request.getParameter("usageLimit")));
            p.setUsagePerUser(Integer.parseInt(request.getParameter("usagePerUser")));
            p.setStatus(request.getParameter("status"));
            
            p.setStartDate(LocalDateTime.parse(request.getParameter("startDate")));
            p.setEndDate(LocalDateTime.parse(request.getParameter("endDate")));

            if (promotionDAO.updatePromotion(p)) {
                response.sendRedirect(request.getContextPath() + "/admin/promotion-detail?id=" + p.getPromotionId() + "&success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/promotion-detail?id=" + p.getPromotionId() + "&error=1");
            }
        }
    }
}