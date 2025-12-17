package com.phonecard.controller;

import com.phonecard.dao.OrderDAO;
import com.phonecard.dao.TransactionDAO;
import com.phonecard.model.Order;
import com.phonecard.model.Transaction;
import com.phonecard.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HistoryController", urlPatterns = {"/history"})
public class HistoryController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    private OrderDAO orderDAO = new OrderDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        
        String tab = request.getParameter("tab");
        if (tab == null) tab = "orders";
        
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {}
        
        if ("transactions".equals(tab)) {
            List<Transaction> transactions = transactionDAO.getTransactionsByUserId(user.getUserId(), page, PAGE_SIZE);
            int total = transactionDAO.countTransactionsByUserId(user.getUserId());
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            
            request.setAttribute("transactions", transactions);
            request.setAttribute("totalPages", totalPages);
        } else {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId(), page, PAGE_SIZE);
            int total = orderDAO.countOrdersByUserId(user.getUserId());
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            
            request.setAttribute("orders", orders);
            request.setAttribute("totalPages", totalPages);
        }
        
        request.setAttribute("currentTab", tab);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/web-page/history.jsp").forward(request, response);
    }
}

