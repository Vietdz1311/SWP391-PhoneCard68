package com.phonecard.controller;

/**
 * ProductController
 * -----------------------------
 * Controller xử lý các chức năng liên quan đến sản phẩm thẻ cào:
 *  - Hiển thị danh sách sản phẩm (có tìm kiếm, lọc, sắp xếp, phân trang)
 *  - Hiển thị chi tiết một sản phẩm
 */
import com.phonecard.dao.CardProductDAO;
import com.phonecard.dao.ProviderDAO;
import com.phonecard.model.CardProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    // Số sản phẩm hiển thị trên mỗi trang
    private static final int PAGE_SIZE = 12;

    // DAO thao tác dữ liệu sản phẩm
    private CardProductDAO productDAO = new CardProductDAO();

    // DAO thao tác dữ liệu nhà mạng
    private ProviderDAO providerDAO = new ProviderDAO();

    /**
     * Xử lý request GET
     * - Nếu action = details → hiển thị chi tiết sản phẩm
     * - Ngược lại → hiển thị danh sách sản phẩm
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("details".equals(action)) {
            // Xem chi tiết sản phẩm
            showDetails(request, response);
        } else {
            // Xem danh sách sản phẩm
            showList(request, response);
        }
    }

    /**
     * Hiển thị danh sách sản phẩm
     * Có hỗ trợ:
     *  - Tìm kiếm theo tên
     *  - Lọc theo nhà mạng
     *  - Sắp xếp
     *  - Phân trang
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy từ khóa tìm kiếm
        String search = request.getParameter("search");

        // Lấy nhà mạng để lọc (nếu có)
        Integer filterProvider = null;
        try {
            if (request.getParameter("filterProvider") != null
                    && !request.getParameter("filterProvider").isEmpty()) {
                filterProvider = Integer.parseInt(
                        request.getParameter("filterProvider"));
            }
        } catch (NumberFormatException ignored) {
        }

        // Lấy tiêu chí sắp xếp
        String sortBy = request.getParameter("sortBy");

        // Xác định trang hiện tại
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {
        }

        // Lấy danh sách sản phẩm theo điều kiện
        List<CardProduct> products =
                productDAO.getAllCardProducts(
                        search, filterProvider, sortBy, page, PAGE_SIZE);

        // Tổng số sản phẩm (phục vụ phân trang)
        int total = productDAO.getTotalCardProducts(search, filterProvider);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        // Gửi dữ liệu sang JSP
        request.setAttribute("products", products);
        request.setAttribute("providers",
                providerDAO.getAllActiveProviders());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("search", search);
        request.setAttribute("filterProvider", filterProvider);
        request.setAttribute("sortBy", sortBy);

        // Chuyển sang trang products.jsp
        request.getRequestDispatcher("/web-page/products.jsp")
               .forward(request, response);
    }

    /**
     * Hiển thị chi tiết một sản phẩm
     */
    private void showDetails(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy ID sản phẩm từ request
            int id = Integer.parseInt(request.getParameter("id"));

            // Lấy thông tin sản phẩm theo ID
            CardProduct product = productDAO.getCardProductById(id);

            // Nếu không tìm thấy sản phẩm → quay về danh sách
            if (product == null) {
                response.sendRedirect(
                        request.getContextPath() + "/products");
                return;
            }

            // Lấy danh sách nhà mạng (phục vụ hiển thị)
            request.setAttribute("providers",
                    providerDAO.getAllActiveProviders());

            // Gửi dữ liệu sản phẩm sang JSP
            request.setAttribute("product", product);

            // Chuyển sang trang chi tiết sản phẩm
            request.getRequestDispatcher("/web-page/product-details.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            // ID không hợp lệ → quay về trang danh sách
            response.sendRedirect(
                    request.getContextPath() + "/products");
        }
    }
}
