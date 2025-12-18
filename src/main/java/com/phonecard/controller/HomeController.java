package com.phonecard.controller;

import com.phonecard.dao.BlogDAO;
import com.phonecard.dao.CardProductDAO;
import com.phonecard.dao.ProviderDAO;
import com.phonecard.model.BlogPost;
import com.phonecard.model.CardProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * HomeController
 * -----------------------------
 * Controller xử lý trang chủ của hệ thống.
 * Chức năng:
 *  - Hiển thị danh sách sản phẩm nổi bật
 *  - Hiển thị bài viết blog mới nhất
 *  - Hiển thị danh sách nhà mạng (provider)
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    // DAO dùng để thao tác dữ liệu sản phẩm thẻ
    private CardProductDAO productDAO = new CardProductDAO();

    // DAO dùng để lấy dữ liệu blog
    private BlogDAO blogDAO = new BlogDAO();

    // DAO dùng để lấy danh sách nhà mạng
    private ProviderDAO providerDAO = new ProviderDAO();

    // Số lượng sản phẩm nổi bật hiển thị trên trang chủ
    private static final int FEATURED_PRODUCT_LIMIT = 8;

    // Số lượng bài blog mới nhất hiển thị trên trang chủ
    private static final int LATEST_BLOG_LIMIT = 6;

    /**
     * Xử lý request GET
     * Khi người dùng truy cập:
     *  - /home
     *  - /
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách sản phẩm nổi bật (còn hàng)
        List<CardProduct> featuredProducts =
                productDAO.getFeaturedProducts(FEATURED_PRODUCT_LIMIT);

        // Lấy danh sách bài blog mới nhất
        List<BlogPost> latestBlogs =
                blogDAO.getLatestBlogs(LATEST_BLOG_LIMIT);

        // Lấy danh sách nhà mạng đang hoạt động
        request.setAttribute("providers",
                providerDAO.getAllActiveProviders());

        // Gửi dữ liệu sản phẩm nổi bật sang JSP
        request.setAttribute("featuredProducts", featuredProducts);

        // Gửi dữ liệu blog mới nhất sang JSP
        request.setAttribute("latestBlogs", latestBlogs);

        // Chuyển request sang trang home.jsp để render giao diện
        request.getRequestDispatcher("/web-page/home.jsp")
               .forward(request, response);
    }

    /**
     * Xử lý request POST
     * Trang chủ không xử lý logic POST riêng
     * => Gọi lại doGet để xử lý như GET
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chuyển xử lý POST về GET
        doGet(request, response);
    }
}
