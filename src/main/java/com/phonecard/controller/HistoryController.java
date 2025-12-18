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

/**
 * HistoryController
 * -----------------
 * Controller dùng để hiển thị:
 * 1. Lịch sử mua hàng (Orders)
 * 2. Lịch sử giao dịch (Transactions)
 *
 * URL: /history
 * - tab=orders        → Lịch sử đơn hàng
 * - tab=transactions  → Lịch sử giao dịch ví
 */
@WebServlet(name = "HistoryController", urlPatterns = {"/history"})
public class HistoryController extends HttpServlet {
    
    // Số bản ghi hiển thị trên mỗi trang
    private static final int PAGE_SIZE = 10;

    // DAO xử lý đơn hàng
    private OrderDAO orderDAO = new OrderDAO();

    // DAO xử lý giao dịch
    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

         // 1. KIỂM TRA ĐĂNG NHẬP
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        // Nếu chưa đăng nhập → chuyển về trang auth
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }
        

         // 2. XÁC ĐỊNH TAB ĐANG XEM

        // tab có thể là: orders | transactions
        String tab = request.getParameter("tab");
        
        // Mặc định hiển thị lịch sử đơn hàng
        if (tab == null) tab = "orders";
        
        // 3. XỬ LÝ PHÂN TRANG

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {}
        

         // 4. LOAD DỮ LIỆU THEO TAB
        if ("transactions".equals(tab)) {
            // ===== TAB: LỊCH SỬ GIAO DỊCH =====
            
            // Lấy danh sách giao dịch của user theo trang
            List<Transaction> transactions = transactionDAO.getTransactionsByUserId(
                    user.getUserId(), page, PAGE_SIZE);
            
            // Đếm tổng số giao dịch
            int total = transactionDAO.countTransactionsByUserId(user.getUserId());
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            
            // Gửi dữ liệu sang JSP
            request.setAttribute("transactions", transactions);
            request.setAttribute("totalPages", totalPages);
        } else {
            // ===== TAB: LỊCH SỬ ĐƠN HÀNG =====
            
            // Lấy danh sách đơn hàng của user theo trang
            List<Order> orders = orderDAO.getOrdersByUserId(
                    user.getUserId(), page, PAGE_SIZE);
            
            // Đếm tổng số đơn hàng
            int total = orderDAO.countOrdersByUserId(user.getUserId());
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            
            // Gửi dữ liệu sang JSP
            request.setAttribute("orders", orders);
            request.setAttribute("totalPages", totalPages);
        }

         // 5. GỬI THÔNG TIN CHUNG CHO VIEW
        request.setAttribute("currentTab", tab);   // tab hiện tại
        request.setAttribute("currentPage", page); // trang hiện tại
        
        // Forward sang trang history.jsp để hiển thị
        request.getRequestDispatcher("/web-page/history.jsp").forward(request, response);
    }
}
