package com.phonecard.controller;

import com.phonecard.dao.CardProductDAO;
import com.phonecard.dao.ProviderDAO;
import com.phonecard.model.CardProduct;
import com.phonecard.model.Provider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private final CardProductDAO productDAO = new CardProductDAO();
    private final ProviderDAO providerDAO = new ProviderDAO();

    private static final int FEATURED_PRODUCT_LIMIT = 8; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<CardProduct> featuredProducts = productDAO.getFeaturedProducts(FEATURED_PRODUCT_LIMIT);
        request.setAttribute("featuredProducts", featuredProducts);

        List<Provider> providers = providerDAO.getAllActiveProviders();
        request.setAttribute("providers", providers);

        request.getRequestDispatcher("/web-page/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}