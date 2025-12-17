<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="w-64 bg-gradient-to-b from-slate-900 to-slate-800 text-slate-100 flex flex-col shadow-2xl shrink-0 h-screen fixed left-0 top-0 z-20 border-r border-slate-800">
    <div class="h-16 flex items-center justify-center text-2xl font-extrabold border-b border-slate-700">
        <i class='bx bxs-credit-card-alt mr-2 text-blue-400'></i> 
        <span class="bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">PhoneCard68</span>
    </div>

    <nav class="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        <a href="${pageContext.request.contextPath}/web-page/admin/dashboard.jsp" class="flex items-center px-4 py-3 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
            <i class='bx bxs-dashboard text-xl mr-3 text-blue-300'></i> Dashboard
        </a>

        <c:if test="${sessionScope.user.role == 'Admin'}">
            <div class="mt-6 mb-2 px-4 text-xs font-bold text-slate-400 uppercase tracking-wide">Quản lý người dùng</div>
            <a href="${pageContext.request.contextPath}/admin/staff" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bx-id-card text-xl mr-3 text-purple-300'></i> Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/customers" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bx-user-circle text-xl mr-3 text-emerald-300'></i> Khách hàng
            </a>
        </c:if>

        <div class="mt-6 mb-2 px-4 text-xs font-bold text-slate-400 uppercase tracking-wide">Sản phẩm & Kho</div>
        <a href="${pageContext.request.contextPath}/admin/providers" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
            <i class='bx bx-store-alt text-xl mr-3 text-amber-300'></i> Nhà cung cấp
        </a>
        
        <c:if test="${sessionScope.user.role == 'Admin'}">
            <a href="${pageContext.request.contextPath}/admin/products" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bxs-layer text-xl mr-3 text-sky-300'></i> Loại thẻ
            </a>
            
             <div class="mt-6 mb-2 px-4 text-xs font-bold text-slate-400 uppercase tracking-wide">Kinh doanh</div>
             
             <a href="${pageContext.request.contextPath}/admin/promotions" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bxs-discount text-xl mr-3 text-pink-300'></i> Khuyến mãi
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/orders" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bx-receipt text-xl mr-3 text-lime-300'></i> Đơn hàng
            </a>
        </c:if>
        
        <!-- Staff Blog Management -->
        <c:if test="${sessionScope.user.role == 'Staff' || sessionScope.user.role == 'Admin'}">
            <div class="mt-6 mb-2 px-4 text-xs font-bold text-slate-400 uppercase tracking-wide">Nội dung</div>
            <a href="${pageContext.request.contextPath}/staff/blogs" class="flex items-center px-4 py-2 text-slate-200 hover:bg-slate-700/60 hover:text-white rounded-lg transition font-medium">
                <i class='bx bx-news text-xl mr-3 text-cyan-300'></i> Quản lý Blog
            </a>
        </c:if>
    </nav>

    <div class="p-4 border-t border-slate-700 bg-slate-900/60 backdrop-blur">
        <div class="flex items-center mb-3">
            <div class="h-10 w-10 rounded-full bg-blue-500/20 text-blue-100 flex items-center justify-center font-bold text-lg border border-blue-400/40 uppercase">
                ${sessionScope.user.username.charAt(0)}
            </div>
            <div class="ml-3 overflow-hidden">
                <p class="font-bold truncate text-white">${sessionScope.user.username}</p>
                <p class="text-xs text-slate-300 font-semibold bg-slate-700 px-2 py-0.5 rounded-full w-fit">${sessionScope.user.role}</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="block text-center py-2 bg-blue-500/10 border border-blue-400/40 text-blue-100 hover:bg-blue-500/20 rounded-lg text-sm font-bold transition shadow-sm mb-2">
            <i class='bx bx-home mr-1'></i> Về trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/auth?action=logout" class="block text-center py-2 bg-slate-800 border border-red-400/40 text-red-100 hover:bg-slate-700 rounded-lg text-sm font-bold transition shadow-sm">
            Đăng xuất
        </a>
    </div>
</aside>

