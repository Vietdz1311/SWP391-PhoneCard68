<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="w-64 bg-white text-gray-700 flex flex-col shadow-lg shrink-0 h-screen fixed left-0 top-0 z-20 border-r border-gray-200">
    <div class="h-16 flex items-center justify-center text-2xl font-extrabold border-b border-gray-200">
        <i class='bx bxs-credit-card-alt mr-2 text-blue-600'></i> 
        <span class="bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">PhoneCard68</span>
    </div>

    <nav class="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        <a href="${pageContext.request.contextPath}/web-page/admin/dashboard.jsp" class="flex items-center px-4 py-3 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
            <i class='bx bxs-dashboard text-xl mr-3'></i> Dashboard
        </a>

        <c:if test="${sessionScope.user.role == 'Admin'}">
            <div class="mt-6 mb-2 px-4 text-xs font-bold text-gray-400 uppercase">Quản lý người dùng</div>
            <a href="${pageContext.request.contextPath}/admin/staff" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bx-id-card text-xl mr-3'></i> Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/customers" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bx-user-circle text-xl mr-3'></i> Khách hàng
            </a>
        </c:if>

        <div class="mt-6 mb-2 px-4 text-xs font-bold text-gray-400 uppercase">Sản phẩm & Kho</div>
        <a href="${pageContext.request.contextPath}/admin/providers" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
            <i class='bx bx-store-alt text-xl mr-3'></i> Nhà cung cấp
        </a>
        
        <c:if test="${sessionScope.user.role == 'Admin'}">
            <a href="${pageContext.request.contextPath}/admin/products" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bxs-layer text-xl mr-3'></i> Loại thẻ
            </a>
            
             <div class="mt-6 mb-2 px-4 text-xs font-bold text-gray-400 uppercase">Kinh doanh</div>
             
             <a href="${pageContext.request.contextPath}/admin/promotions" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bxs-discount text-xl mr-3'></i> Khuyến mãi
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/orders" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bx-receipt text-xl mr-3'></i> Đơn hàng
            </a>
        </c:if>
        
        <!-- Staff Blog Management -->
        <c:if test="${sessionScope.user.role == 'Staff' || sessionScope.user.role == 'Admin'}">
            <div class="mt-6 mb-2 px-4 text-xs font-bold text-gray-400 uppercase">Nội dung</div>
            <a href="${pageContext.request.contextPath}/staff/blogs" class="flex items-center px-4 py-2 text-gray-600 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition font-medium">
                <i class='bx bx-news text-xl mr-3'></i> Quản lý Blog
            </a>
        </c:if>
    </nav>

    <div class="p-4 border-t border-gray-200 bg-gray-50">
        <div class="flex items-center mb-3">
            <div class="h-10 w-10 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-lg border border-blue-200 uppercase">
                ${sessionScope.user.username.charAt(0)}
            </div>
            <div class="ml-3 overflow-hidden">
                <p class="font-bold truncate text-gray-800">${sessionScope.user.username}</p>
                <p class="text-xs text-gray-500 font-semibold bg-gray-200 px-2 py-0.5 rounded-full w-fit">${sessionScope.user.role}</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="block text-center py-2 bg-blue-50 border border-blue-200 text-blue-600 hover:bg-blue-100 rounded-lg text-sm font-bold transition shadow-sm mb-2">
            <i class='bx bx-home mr-1'></i> Về trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/auth?action=logout" class="block text-center py-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 rounded-lg text-sm font-bold transition shadow-sm">
            Đăng xuất
        </a>
    </div>
</aside>

