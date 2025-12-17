<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bài viết - Staff</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen font-inter">

<div class="flex">
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
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
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
               class="flex items-center gap-3 px-6 py-3 text-white bg-blue-600/20 border-r-4 border-blue-500">
                <i class='bx bx-news text-xl'></i>
                Quản lý Bài viết
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Khác</div>
            <a href="${pageContext.request.contextPath}/home" 
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
                <i class='bx bx-home text-xl'></i>
                Về trang chủ
            </a>
        </nav>
        
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

    <main class="ml-64 flex-1 p-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Quản lý Bài viết</h1>
                <p class="text-gray-600 mt-1">Tạo, chỉnh sửa và quản lý các bài viết blog</p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/blogs?action=create" 
               class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-3 rounded-xl font-bold hover:from-blue-700 hover:to-indigo-700 transition shadow-lg flex items-center gap-2">
                <i class='bx bx-plus'></i> Tạo bài viết mới
            </a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6 rounded-r-xl flex items-center">
                <i class='bx bx-check-circle text-green-500 text-2xl mr-3'></i>
                <span class="text-green-700 font-medium">${param.success}</span>
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-xl flex items-center">
                <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
                <span class="text-red-700 font-medium">${param.error}</span>
            </div>
        </c:if>

        <div class="bg-white rounded-xl shadow-sm p-4 mb-6">
            <form action="${pageContext.request.contextPath}/staff/blogs" method="get" class="flex gap-4">
                <div class="flex-1 relative">
                    <input type="text" name="search" value="${search}" placeholder="Tìm kiếm bài viết..." 
                           class="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <i class='bx bx-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 text-xl'></i>
                </div>
                <button type="submit" class="bg-blue-600 text-white px-6 py-3 rounded-xl font-medium hover:bg-blue-700 transition">
                    Tìm kiếm
                </button>
            </form>
        </div>

        <div class="bg-white rounded-xl shadow-sm overflow-hidden">
            <table class="w-full">
                <thead class="bg-gray-50 border-b border-gray-200">
                    <tr>
                        <th class="text-left px-6 py-4 text-sm font-bold text-gray-600 uppercase">Bài viết</th>
                        <th class="text-left px-6 py-4 text-sm font-bold text-gray-600 uppercase">Tác giả</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Trạng thái</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Ngày đăng</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:choose>
                        <c:when test="${not empty posts}">
                            <c:forEach var="post" items="${posts}">
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-4">
                                            <img src="${not empty post.thumbnailUrl ? post.thumbnailUrl : 'https://via.placeholder.com/80x60?text=No+Image'}" 
                                                 alt="${post.title}" class="w-20 h-14 object-cover rounded-lg">
                                            <div>
                                                <h3 class="font-bold text-gray-900 line-clamp-1">${post.title}</h3>
                                                <p class="text-sm text-gray-500 line-clamp-1">${fn:substring(post.content, 0, 60)}...</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="text-gray-700">${post.author.username}</span>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <c:choose>
                                            <c:when test="${post.active}">
                                                <span class="inline-flex items-center gap-1 px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                                                    <i class='bx bx-check-circle'></i> Đã đăng
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-1 px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm font-medium">
                                                    <i class='bx bx-hide'></i> Nháp
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 text-center text-gray-600 text-sm">
                                        ${post.formattedDateTime}
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="flex items-center justify-center gap-2">
                                            <a href="${pageContext.request.contextPath}/staff/blogs?action=preview&id=${post.postId}" 
                                               target="_blank"
                                               class="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition" 
                                               title="Xem trước">
                                                <i class='bx bx-show text-xl'></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/staff/blogs?action=edit&id=${post.postId}" 
                                               class="p-2 text-gray-500 hover:text-orange-600 hover:bg-orange-50 rounded-lg transition" 
                                               title="Sửa">
                                                <i class='bx bx-edit text-xl'></i>
                                            </a>
                                            <button onclick="confirmDelete(${post.postId}, '${post.title}')" 
                                                    class="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition" 
                                                    title="Xóa">
                                                <i class='bx bx-trash text-xl'></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="px-6 py-16 text-center">
                                    <div class="flex flex-col items-center">
                                        <i class='bx bx-news text-gray-300 text-6xl mb-4'></i>
                                        <p class="text-gray-500 text-lg">Chưa có bài viết nào</p>
                                        <a href="${pageContext.request.contextPath}/staff/blogs?action=create" 
                                           class="mt-4 text-blue-600 font-bold hover:underline">
                                            Tạo bài viết đầu tiên →
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="px-6 py-4 border-t border-gray-100 flex justify-center">
                    <nav class="flex space-x-2">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/staff/blogs?page=${i}&search=${search}"
                               class="px-4 py-2 rounded-lg font-medium transition ${currentPage == i ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                                ${i}
                            </a>
                        </c:forEach>
                    </nav>
                </div>
            </c:if>
        </div>
    </main>
</div>

<div id="deleteModal" class="fixed inset-0 bg-black/60 hidden items-center justify-center z-50">
    <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-4 p-8">
        <div class="text-center">
            <div class="w-16 h-16 bg-red-100 rounded-full mx-auto flex items-center justify-center mb-4">
                <i class='bx bx-trash text-red-600 text-3xl'></i>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">Xác nhận xóa</h3>
            <p class="text-gray-600 mb-6">Bạn có chắc chắn muốn xóa bài viết "<span id="deletePostTitle" class="font-semibold"></span>"?</p>
            <div class="flex gap-4">
                <button onclick="closeDeleteModal()" 
                        class="flex-1 bg-gray-100 text-gray-700 font-bold py-3 rounded-xl hover:bg-gray-200 transition">
                    Hủy
                </button>
                <a id="deleteLink" href="#" 
                   class="flex-1 bg-red-600 text-white font-bold py-3 rounded-xl hover:bg-red-700 transition text-center">
                    Xóa
                </a>
            </div>
        </div>
    </div>
</div>

<script>
function confirmDelete(postId, title) {
    document.getElementById('deletePostTitle').textContent = title;
    document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/staff/blogs?action=delete&id=' + postId;
    document.getElementById('deleteModal').classList.remove('hidden');
    document.getElementById('deleteModal').classList.add('flex');
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.add('hidden');
    document.getElementById('deleteModal').classList.remove('flex');
}

document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeDeleteModal();
});
</script>

</body>
</html>


