package com.phonecard.controller;

import com.phonecard.dao.CardInventoryDAO;
import com.phonecard.dao.CardProductDAO;
import com.phonecard.dao.ProviderDAO;
import com.phonecard.model.CardInventory;
import com.phonecard.model.CardProduct;
import com.phonecard.model.Provider;
import com.phonecard.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "StaffCardProductController", urlPatterns = {"/staff/products"})
public class StaffCardProductController extends HttpServlet {

    private CardProductDAO productDAO = new CardProductDAO();
    private CardInventoryDAO inventoryDAO = new CardInventoryDAO();
    private ProviderDAO providerDAO = new ProviderDAO();
    
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkStaffPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        
        if (action == null) action = "list";
        
        switch (action) {
            case "create" -> showCreateForm(request, response);
            case "edit" -> showEditForm(request, response);
            case "delete" -> deleteProduct(request, response);
            case "inventory" -> showInventory(request, response);
            case "add-inventory" -> showAddInventoryForm(request, response);
            case "delete-card" -> deleteCard(request, response);
            default -> showList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        if (!checkStaffPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createProduct(request, response);
        } else if ("edit".equals(action)) {
            updateProduct(request, response);
        } else if ("add-inventory".equals(action)) {
            addInventory(request, response);
        }
    }

    /**
     * Kiểm tra quyền Staff/Admin
     */
    private boolean checkStaffPermission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return false;
        }
        
        if (!"Staff".equals(user.getRole()) && !"Admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        
        return true;
    }

    /**
     * Hiển thị danh sách sản phẩm
     */
    private void showList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String providerIdStr = request.getParameter("providerId");
        String pageStr = request.getParameter("page");
        
        Integer providerId = null;
        if (providerIdStr != null && !providerIdStr.isEmpty()) {
            try {
                providerId = Integer.parseInt(providerIdStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        List<CardProduct> products = productDAO.getAllCardProducts(search, providerId, "p.product_id DESC", page, PAGE_SIZE);
        int totalProducts = productDAO.getTotalCardProducts(search, providerId);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        
        List<Provider> providers = providerDAO.getAllActiveProviders();
        
        request.setAttribute("products", products);
        request.setAttribute("providers", providers);
        request.setAttribute("search", search);
        request.setAttribute("selectedProviderId", providerId);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/web-page/staff/product-list.jsp").forward(request, response);
    }

    /**
     * Form tạo sản phẩm mới
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Provider> providers = providerDAO.getAllActiveProviders();
        request.setAttribute("providers", providers);
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/web-page/staff/product-form.jsp").forward(request, response);
    }

    /**
     * Form chỉnh sửa sản phẩm
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(idStr);
            CardProduct product = productDAO.getCardProductById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/staff/products?error=" + 
                    URLEncoder.encode("Không tìm thấy sản phẩm", StandardCharsets.UTF_8));
                return;
            }
            
            List<Provider> providers = providerDAO.getAllActiveProviders();
            
            request.setAttribute("product", product);
            request.setAttribute("providers", providers);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/web-page/staff/product-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
        }
    }

    /**
     * Tạo sản phẩm mới
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productName = request.getParameter("productName");
        String providerIdStr = request.getParameter("providerId");
        String faceValueStr = request.getParameter("faceValue");
        String sellingPriceStr = request.getParameter("sellingPrice");
        String description = request.getParameter("description");
        
        // Validate
        if (productName == null || productName.trim().isEmpty() || 
            providerIdStr == null || faceValueStr == null || sellingPriceStr == null) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            showCreateForm(request, response);
            return;
        }
        
        try {
            int providerId = Integer.parseInt(providerIdStr);
            double faceValue = Double.parseDouble(faceValueStr);
            double sellingPrice = Double.parseDouble(sellingPriceStr);
            
            // Kiểm tra tên đã tồn tại
            if (productDAO.isProductNameExists(providerId, productName.trim(), null)) {
                request.setAttribute("error", "Tên sản phẩm đã tồn tại cho nhà mạng này");
                request.setAttribute("productName", productName);
                request.setAttribute("selectedProviderId", providerId);
                request.setAttribute("faceValue", faceValue);
                request.setAttribute("sellingPrice", sellingPrice);
                request.setAttribute("description", description);
                showCreateForm(request, response);
                return;
            }
            
            CardProduct product = new CardProduct();
            product.setProductName(productName.trim());
            product.setProviderId(providerId);
            product.setFaceValue(faceValue);
            product.setSellingPrice(sellingPrice);
            product.setDescription(description);
            
            int newId = productDAO.createCardProduct(product);
            
            if (newId > 0) {
                response.sendRedirect(request.getContextPath() + "/staff/products?success=" + 
                    URLEncoder.encode("Tạo sản phẩm thành công", StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error", "Không thể tạo sản phẩm");
                showCreateForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá trị không hợp lệ");
            showCreateForm(request, response);
        }
    }

    /**
     * Cập nhật sản phẩm
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String providerIdStr = request.getParameter("providerId");
        String faceValueStr = request.getParameter("faceValue");
        String sellingPriceStr = request.getParameter("sellingPrice");
        String description = request.getParameter("description");
        
        try {
            int productId = Integer.parseInt(productIdStr);
            int providerId = Integer.parseInt(providerIdStr);
            double faceValue = Double.parseDouble(faceValueStr);
            double sellingPrice = Double.parseDouble(sellingPriceStr);
            
            // Kiểm tra tên đã tồn tại (trừ sản phẩm hiện tại)
            if (productDAO.isProductNameExists(providerId, productName.trim(), productId)) {
                request.setAttribute("error", "Tên sản phẩm đã tồn tại cho nhà mạng này");
                CardProduct product = productDAO.getCardProductById(productId);
                request.setAttribute("product", product);
                List<Provider> providers = providerDAO.getAllActiveProviders();
                request.setAttribute("providers", providers);
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/web-page/staff/product-form.jsp").forward(request, response);
                return;
            }
            
            CardProduct product = new CardProduct();
            product.setProductId(productId);
            product.setProductName(productName.trim());
            product.setProviderId(providerId);
            product.setFaceValue(faceValue);
            product.setSellingPrice(sellingPrice);
            product.setDescription(description);
            
            if (productDAO.updateCardProduct(product)) {
                response.sendRedirect(request.getContextPath() + "/staff/products?success=" + 
                    URLEncoder.encode("Cập nhật sản phẩm thành công", StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error", "Không thể cập nhật sản phẩm");
                showEditForm(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá trị không hợp lệ");
            showEditForm(request, response);
        }
    }

    /**
     * Xóa sản phẩm
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null) {
            try {
                int productId = Integer.parseInt(idStr);
                
                if (productDAO.deleteCardProduct(productId)) {
                    response.sendRedirect(request.getContextPath() + "/staff/products?success=" + 
                        URLEncoder.encode("Xóa sản phẩm thành công", StandardCharsets.UTF_8));
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/products?error=" + 
                        URLEncoder.encode("Không thể xóa sản phẩm. Có thể còn thẻ trong kho.", StandardCharsets.UTF_8));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/staff/products");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/products");
        }
    }

    // ==================== INVENTORY MANAGEMENT ====================

    /**
     * Hiển thị kho thẻ của sản phẩm
     */
    private void showInventory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("productId");
        String statusFilter = request.getParameter("status");
        String pageStr = request.getParameter("page");
        
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
            if (page < 1) page = 1;
            
            CardProduct product = productDAO.getCardProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/staff/products?error=" + 
                    URLEncoder.encode("Không tìm thấy sản phẩm", StandardCharsets.UTF_8));
                return;
            }
            
            List<CardInventory> inventory = inventoryDAO.getInventoryByProductId(productId, statusFilter, page, PAGE_SIZE);
            int totalCards = inventoryDAO.countInventoryByProductId(productId, statusFilter);
            int totalPages = (int) Math.ceil((double) totalCards / PAGE_SIZE);
            
            int[] stats = inventoryDAO.getInventoryStats(productId);
            
            request.setAttribute("product", product);
            request.setAttribute("inventory", inventory);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCards", totalCards);
            request.setAttribute("availableCount", stats[0]);
            request.setAttribute("soldCount", stats[1]);
            request.setAttribute("errorCount", stats[2]);
            
            request.getRequestDispatcher("/web-page/staff/inventory-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
        }
    }

    /**
     * Form thêm thẻ vào kho
     */
    private void showAddInventoryForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("productId");
        
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            CardProduct product = productDAO.getCardProductById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/staff/products?error=" + 
                    URLEncoder.encode("Không tìm thấy sản phẩm", StandardCharsets.UTF_8));
                return;
            }
            
            request.setAttribute("product", product);
            request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
        }
    }

    /**
     * Thêm thẻ vào kho
     */
    private void addInventory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("productId");
        String addMode = request.getParameter("addMode"); // "manual" or "random"
        String expiryDateStr = request.getParameter("expiryDate");
        
        if (productIdStr == null || expiryDateStr == null || expiryDateStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            LocalDate expiryDate = LocalDate.parse(expiryDateStr);
            
            // Kiểm tra ngày hết hạn phải trong tương lai
            if (expiryDate.isBefore(LocalDate.now())) {
                CardProduct product = productDAO.getCardProductById(productId);
                request.setAttribute("product", product);
                request.setAttribute("error", "Ngày hết hạn phải trong tương lai");
                request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
                return;
            }
            
            if ("manual".equals(addMode)) {
                // Nhập thủ công
                String serialNumber = request.getParameter("serialNumber");
                String cardCode = request.getParameter("cardCode");
                
                if (serialNumber == null || serialNumber.trim().isEmpty() || 
                    cardCode == null || cardCode.trim().isEmpty()) {
                    CardProduct product = productDAO.getCardProductById(productId);
                    request.setAttribute("product", product);
                    request.setAttribute("error", "Vui lòng nhập đầy đủ Serial và Mã thẻ");
                    request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
                    return;
                }
                
                // Kiểm tra serial đã tồn tại
                if (inventoryDAO.isSerialExists(productId, serialNumber.trim())) {
                    CardProduct product = productDAO.getCardProductById(productId);
                    request.setAttribute("product", product);
                    request.setAttribute("error", "Serial number đã tồn tại");
                    request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
                    return;
                }
                
                if (inventoryDAO.addCard(productId, serialNumber.trim(), cardCode.trim(), expiryDate)) {
                    response.sendRedirect(request.getContextPath() + "/staff/products?action=inventory&productId=" + productId + 
                        "&success=" + URLEncoder.encode("Thêm thẻ thành công", StandardCharsets.UTF_8));
                } else {
                    CardProduct product = productDAO.getCardProductById(productId);
                    request.setAttribute("product", product);
                    request.setAttribute("error", "Không thể thêm thẻ");
                    request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
                }
                
            } else {
                // Sinh random
                String quantityStr = request.getParameter("quantity");
                int quantity = (quantityStr != null && !quantityStr.isEmpty()) ? Integer.parseInt(quantityStr) : 1;
                
                if (quantity < 1 || quantity > 1000) {
                    CardProduct product = productDAO.getCardProductById(productId);
                    request.setAttribute("product", product);
                    request.setAttribute("error", "Số lượng phải từ 1 đến 1000");
                    request.getRequestDispatcher("/web-page/staff/inventory-form.jsp").forward(request, response);
                    return;
                }
                
                int addedCount = inventoryDAO.addRandomCards(productId, quantity, expiryDate);
                
                response.sendRedirect(request.getContextPath() + "/staff/products?action=inventory&productId=" + productId + 
                    "&success=" + URLEncoder.encode("Đã thêm " + addedCount + " thẻ vào kho", StandardCharsets.UTF_8));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/products?error=" + 
                URLEncoder.encode("Có lỗi xảy ra", StandardCharsets.UTF_8));
        }
    }

    /**
     * Xóa thẻ khỏi kho
     */
    private void deleteCard(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String cardIdStr = request.getParameter("cardId");
        String productIdStr = request.getParameter("productId");
        
        if (cardIdStr != null && productIdStr != null) {
            try {
                long cardId = Long.parseLong(cardIdStr);
                int productId = Integer.parseInt(productIdStr);
                
                if (inventoryDAO.deleteCard(cardId)) {
                    response.sendRedirect(request.getContextPath() + "/staff/products?action=inventory&productId=" + productId + 
                        "&success=" + URLEncoder.encode("Xóa thẻ thành công", StandardCharsets.UTF_8));
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/products?action=inventory&productId=" + productId + 
                        "&error=" + URLEncoder.encode("Không thể xóa thẻ. Thẻ có thể đã được bán.", StandardCharsets.UTF_8));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/staff/products");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/products");
        }
    }
}

