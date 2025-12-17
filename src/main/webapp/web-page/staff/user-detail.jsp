<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết tài khoản - Staff</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen font-inter">

<div class="flex">
    <!-- Sidebar -->
    <aside class="w-64 bg-gradient-to-b from-slate-800 to-slate-900 min-h-screen fixed left-0 top-0">
        <div class="p-6">
            <a href="${pageContext.request.contextPath}/home" class="text-2xl font-bold text-white flex items-center gap-2">
                <i class='bx bx-store-alt text-blue-400'></i>
                PhoneCard
            </a>
            <p class="text-slate-400 text-sm mt-1">Staff Panel</p>
        </div>
        
        <nav class="mt-6">
            <div class="px-6 mb-2 text-xs font-bold text-slate-500 uppercase">Quản lý người dùng</div>
            <a href="${pageContext.request.contextPath}/staff/users" 
               class="flex items-center gap-3 px-6 py-3 text-white bg-blue-600/20 border-r-4 border-blue-500">
                <i class='bx bx-user text-xl'></i>
                Danh sách tài khoản
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Sản phẩm</div>
            <a href="${pageContext.request.contextPath}/staff/products" 
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
                <i class='bx bx-package text-xl'></i>
                Quản lý Sản phẩm
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Nội dung</div>
            <a href="${pageContext.request.contextPath}/staff/blogs" 
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
                <i class='bx bx-news text-xl'></i>
                Quản lý Blog
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Khác</div>
            <a href="${pageContext.request.contextPath}/home" 
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
                <i class='bx bx-home text-xl'></i>
                Về trang chủ
            </a>
        </nav>
        
        <!-- User Info -->
        <div class="absolute bottom-0 left-0 right-0 p-4 border-t border-slate-700">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
                    <i class='bx bx-user text-white text-xl'></i>
                </div>
                <div>
                    <p class="text-white font-medium">${sessionScope.user.username}</p>
                    <p class="text-slate-400 text-xs">${sessionScope.user.role}</p>
                </div>
            </div>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="ml-64 flex-1 p-8">
        <!-- Back button -->
        <a href="${pageContext.request.contextPath}/staff/users" 
           class="inline-flex items-center gap-2 text-gray-600 hover:text-blue-600 font-medium mb-6 transition">
            <i class='bx bx-arrow-back text-xl'></i> Quay lại danh sách
        </a>

        <c:if test="${userinfo != null}">
            <!-- User Card -->
            <div class="max-w-2xl mx-auto">
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    <!-- Header -->
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-600 px-8 py-10 text-center">
                        <div class="w-24 h-24 bg-white rounded-full mx-auto flex items-center justify-center text-4xl font-bold text-blue-600 uppercase shadow-lg">
                            ${userinfo.username.charAt(0)}
                        </div>
                        <h2 class="text-2xl font-bold text-white mt-4">${userinfo.username}</h2>
                        <span class="inline-block mt-2 px-4 py-1 rounded-full text-sm font-bold 
                            ${userinfo.role == 'Admin' ? 'bg-purple-500 text-white' : 
                              userinfo.role == 'Staff' ? 'bg-blue-400 text-white' : 'bg-white/20 text-white'}">
                            ${userinfo.role}
                        </span>
                    </div>
                    
                    <!-- Info -->
                    <div class="p-8">
                        <h3 class="text-lg font-bold text-gray-800 mb-6 flex items-center gap-2">
                            <i class='bx bx-info-circle text-blue-600'></i> Thông tin tài khoản
                        </h3>
                        
                        <div class="space-y-4">
                            <div class="flex items-center py-3 border-b border-gray-100">
                                <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                    <i class='bx bx-id-card'></i> User ID
                                </div>
                                <div class="text-gray-900 font-bold">#${userinfo.userId}</div>
                            </div>
                            
                            <div class="flex items-center py-3 border-b border-gray-100">
                                <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                    <i class='bx bx-envelope'></i> Email
                                </div>
                                <div class="text-gray-900">${userinfo.email}</div>
                            </div>
                            
                            <div class="flex items-center py-3 border-b border-gray-100">
                                <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                    <i class='bx bx-phone'></i> Số điện thoại
                                </div>
                                <div class="text-gray-900">${userinfo.phone != null ? userinfo.phone : 'Chưa cập nhật'}</div>
                            </div>
                            
                            <c:if test="${userinfo.role == 'Customer'}">
                                <div class="flex items-center py-3 border-b border-gray-100">
                                    <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                        <i class='bx bx-wallet'></i> Số dư ví
                                    </div>
                                    <div class="text-green-600 font-bold text-lg">
                                        <fmt:formatNumber value="${userinfo.walletBalance}" type="number"/> ₫
                                    </div>
                                </div>
                            </c:if>
                            
                            <div class="flex items-center py-3 border-b border-gray-100">
                                <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                    <i class='bx bx-check-shield'></i> Trạng thái
                                </div>
                                <div>
                                    <span class="px-3 py-1 rounded-full text-sm font-bold 
                                        ${userinfo.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                                        <i class='bx ${userinfo.status == "Active" ? "bx-check-circle" : "bx-lock-alt"} mr-1'></i>
                                        ${userinfo.status}
                                    </span>
                                </div>
                            </div>
                            
                            <c:if test="${userinfo.createdAt != null}">
                                <div class="flex items-center py-3">
                                    <div class="w-40 text-gray-500 font-medium flex items-center gap-2">
                                        <i class='bx bx-calendar'></i> Ngày tạo
                                    </div>
                                    <div class="text-gray-900">${userinfo.createdAt}</div>
                                </div>
                            </c:if>
                        </div>
                        
                        <!-- Note -->
                        <div class="mt-8 bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                            <p class="text-yellow-700 text-sm flex items-start gap-2">
                                <i class='bx bx-info-circle text-lg'></i>
                                <span>Đây là trang xem thông tin. Staff không có quyền chỉnh sửa hoặc xóa tài khoản người dùng.</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <c:if test="${userinfo == null}">
            <div class="text-center py-16">
                <i class='bx bx-user-x text-gray-300 text-8xl mb-4'></i>
                <p class="text-gray-500 text-xl">Không tìm thấy thông tin tài khoản</p>
                <a href="${pageContext.request.contextPath}/staff/users" 
                   class="mt-4 inline-block text-blue-600 font-bold hover:underline">
                    ← Quay lại danh sách
                </a>
            </div>
        </c:if>
    </main>
</div>

</body>
</html>

