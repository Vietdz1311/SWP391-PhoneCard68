<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách tài khoản - Staff</title>
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
        <!-- Header -->
        <div class="mb-8">
            <div class="text-gray-500 text-xs font-bold uppercase mb-1">STAFF > USER MANAGEMENT</div>
            <h1 class="text-3xl font-bold text-gray-900">Danh sách tài khoản</h1>
            <p class="text-gray-600 mt-1">Xem thông tin tài khoản người dùng</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-xl flex items-center">
                <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
                <span class="text-red-700 font-medium">Bạn không có quyền xem thông tin này</span>
            </div>
        </c:if>

        <!-- Search & Filter -->
        <form action="${pageContext.request.contextPath}/staff/users" method="get" 
              class="bg-white p-4 rounded-xl shadow-sm mb-6 flex flex-wrap gap-4 border border-gray-100 items-center">
            
            <div class="flex-1 relative min-w-[200px]">
                <i class='bx bx-search absolute left-3 top-3 text-gray-400 text-xl'></i>
                <input type="text" name="keyword" value="${paramKeyword}" placeholder="Tìm kiếm theo tên, email..." 
                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            
            <select name="role" class="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                <option value="All" ${paramRole == 'All' ? 'selected' : ''}>Vai trò: Tất cả</option>
                <option value="Staff" ${paramRole == 'Staff' ? 'selected' : ''}>Staff</option>
                <option value="Customer" ${paramRole == 'Customer' ? 'selected' : ''}>Customer</option>
            </select>

            <select name="status" class="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                <option value="All" ${paramStatus == 'All' ? 'selected' : ''}>Trạng thái: Tất cả</option>
                <option value="Active" ${paramStatus == 'Active' ? 'selected' : ''}>Active</option>
                <option value="Locked" ${paramStatus == 'Locked' ? 'selected' : ''}>Locked</option>
            </select>

            <button type="submit" class="bg-blue-600 text-white px-5 py-2 rounded-lg font-medium hover:bg-blue-700 transition">
                Tìm kiếm
            </button>
            
            <a href="${pageContext.request.contextPath}/staff/users" class="text-gray-500 hover:text-red-500 font-medium px-2">
                <i class='bx bx-refresh text-xl'></i>
            </a>
        </form>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-200">
            <table class="w-full text-left">
                <thead class="bg-gray-50 text-gray-600 text-xs uppercase font-bold border-b border-gray-200">
                    <tr>
                        <th class="px-6 py-4">Tên tài khoản</th>
                        <th class="px-6 py-4">Email</th>
                        <th class="px-6 py-4">Số điện thoại</th>
                        <th class="px-6 py-4">Vai trò</th>
                        <th class="px-6 py-4">Trạng thái</th>
                        <th class="px-6 py-4 text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:forEach var="u" items="${listUsers}">
                        <tr class="hover:bg-blue-50 transition">
                            <td class="px-6 py-4 font-medium text-gray-900 flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center text-white font-bold text-xs uppercase">
                                    ${u.username.charAt(0)}
                                </div>
                                ${u.username}
                            </td>
                            <td class="px-6 py-4 text-gray-600">${u.email}</td>
                            <td class="px-6 py-4 text-gray-600">${u.phone}</td>
                            <td class="px-6 py-4">
                                <span class="px-3 py-1 rounded-full text-xs font-bold border 
                                    ${u.role == 'Admin' ? 'bg-purple-100 text-purple-700 border-purple-200' : 
                                      u.role == 'Staff' ? 'bg-blue-100 text-blue-700 border-blue-200' : 'bg-gray-100 text-gray-700 border-gray-200'}">
                                    ${u.role}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 rounded text-xs font-bold flex items-center w-fit
                                    ${u.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                                    <span class="w-2 h-2 rounded-full mr-2 ${u.status == 'Active' ? 'bg-green-500' : 'bg-red-500'}"></span>
                                    ${u.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <a href="${pageContext.request.contextPath}/staff/user-detail?id=${u.userId}" 
                                   class="inline-flex items-center gap-1 bg-blue-50 text-blue-600 rounded-lg px-4 py-2 hover:bg-blue-100 transition text-sm font-medium">
                                    <i class='bx bx-show'></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty listUsers}">
                <div class="text-center py-12 text-gray-400">
                    <i class='bx bx-user-x text-6xl mb-3 text-gray-200'></i>
                    <p>Không tìm thấy tài khoản nào.</p>
                </div>
            </c:if>
            
            <!-- Footer -->
            <div class="px-6 py-4 border-t border-gray-100 bg-gray-50">
                <div class="text-sm text-gray-500">
                    Tổng cộng: <span class="font-bold text-gray-800">${totalCount}</span> tài khoản
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>

