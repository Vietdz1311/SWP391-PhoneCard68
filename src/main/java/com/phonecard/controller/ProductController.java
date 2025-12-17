package com.phonecard.controller;

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
    private static final int PAGE_SIZE = 12;
    private CardProductDAO productDAO = new CardProductDAO();
    private ProviderDAO providerDAO = new ProviderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("details".equals(action)) {
            showDetails(request, response);
        } else {
            showList(request, response);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        Integer filterProvider = null;
        try {
            if (request.getParameter("filterProvider") != null && !request.getParameter("filterProvider").isEmpty()) {
                filterProvider = Integer.parseInt(request.getParameter("filterProvider"));
            }
        } catch (NumberFormatException ignored) {}

        String sortBy = request.getParameter("sortBy");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {}

        List<CardProduct> products = productDAO.getAllCardProducts(search, filterProvider, sortBy, page, PAGE_SIZE);
        int total = productDAO.getTotalCardProducts(search, filterProvider);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("products", products);
        request.setAttribute("providers", providerDAO.getAllActiveProviders());
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("search", search);
        request.setAttribute("filterProvider", filterProvider);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("/web-page/products.jsp").forward(request, response);
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        CardProduct product = productDAO.getCardProductById(id);

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        request.setAttribute("providers", providerDAO.getAllActiveProviders());

        request.setAttribute("product", product);
        request.getRequestDispatcher("/web-page/product-details.jsp").forward(request, response);
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
}