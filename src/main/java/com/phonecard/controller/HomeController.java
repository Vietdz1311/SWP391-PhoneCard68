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

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""}) 
public class HomeController extends HttpServlet {

    private CardProductDAO productDAO = new CardProductDAO();
    private BlogDAO blogDAO = new BlogDAO();
    private ProviderDAO providerDAO = new ProviderDAO();

    private static final int FEATURED_PRODUCT_LIMIT = 8;
    private static final int LATEST_BLOG_LIMIT = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<CardProduct> featuredProducts = productDAO.getFeaturedProducts(FEATURED_PRODUCT_LIMIT);

        List<BlogPost> latestBlogs = blogDAO.getLatestBlogs(LATEST_BLOG_LIMIT);

        request.setAttribute("providers", providerDAO.getAllActiveProviders());

        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("latestBlogs", latestBlogs);

        request.getRequestDispatcher("/web-page/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}