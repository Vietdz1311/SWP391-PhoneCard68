
package com.phonecard.controller;

import com.phonecard.dao.BlogDAO;
import com.phonecard.model.BlogPost;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogController", urlPatterns = {"/blog"})
public class BlogController extends HttpServlet {
    private BlogDAO blogDAO = new BlogDAO();
    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("details".equals(action)) {
            String slug = request.getParameter("slug");
            BlogPost post = blogDAO.getBlogBySlug(slug);
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
            request.setAttribute("post", post);
            request.getRequestDispatcher("/web-page/blog-details.jsp").forward(request, response);
            return;
        }

        String search = request.getParameter("search");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (Exception ignored) {}

        List<BlogPost> posts = blogDAO.getAllBlogs(search, page, true);
        int total = blogDAO.getTotalBlogs(search, true);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("posts", posts);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/web-page/blog.jsp").forward(request, response);
    }
}