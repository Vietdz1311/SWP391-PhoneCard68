<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa' : 'Tạo'} Bài viết - Staff</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen">

<!-- Sidebar -->
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
            <a href="${pageContext.request.contextPath}/staff/blogs" 
               class="flex items-center gap-3 px-6 py-3 text-white bg-blue-600/20 border-r-4 border-blue-500">
                <i class='bx bx-news text-xl'></i>
                Quản lý Bài viết
            </a>
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
        <div class="flex items-center gap-4 mb-8">
            <a href="${pageContext.request.contextPath}/staff/blogs" 
               class="p-2 hover:bg-gray-200 rounded-lg transition">
                <i class='bx bx-arrow-back text-2xl text-gray-600'></i>
            </a>
            <div>
                <h1 class="text-3xl font-bold text-gray-900">${isEdit ? 'Chỉnh sửa bài viết' : 'Tạo bài viết mới'}</h1>
                <p class="text-gray-600 mt-1">${isEdit ? 'Cập nhật nội dung bài viết' : 'Thêm bài viết mới vào blog'}</p>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-xl flex items-center">
                <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
                <span class="text-red-700 font-medium">${error}</span>
            </div>
        </c:if>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/staff/blogs" method="post" class="space-y-6">
            <input type="hidden" name="action" value="${isEdit ? 'edit' : 'create'}">
            <c:if test="${isEdit}">
                <input type="hidden" name="postId" value="${post.postId}">
            </c:if>

            <div class="grid lg:grid-cols-3 gap-8">
                <!-- Main Content -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Title -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <label class="block text-gray-700 font-bold mb-3">
                            Tiêu đề bài viết <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="title" 
                               value="${isEdit ? post.title : title}" 
                               placeholder="Nhập tiêu đề bài viết..."
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 text-lg"
                               required>
                    </div>

                    <!-- Content -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <label class="block text-gray-700 font-bold mb-3">
                            Nội dung <span class="text-red-500">*</span>
                        </label>
                        <textarea name="content" rows="15" 
                                  placeholder="Viết nội dung bài viết tại đây..."
                                  class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                                  required>${isEdit ? post.content : content}</textarea>
                        <p class="text-sm text-gray-500 mt-2">
                            <i class='bx bx-info-circle mr-1'></i>
                            Hỗ trợ HTML cơ bản: &lt;b&gt;, &lt;i&gt;, &lt;p&gt;, &lt;br&gt;, &lt;ul&gt;, &lt;li&gt;
                        </p>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="space-y-6">
                    <!-- Publish Settings -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <h3 class="font-bold text-gray-900 mb-4 flex items-center gap-2">
                            <i class='bx bx-cog'></i> Cài đặt
                        </h3>
                        
                        <!-- Status Toggle -->
                        <div class="flex items-center justify-between py-3 border-b border-gray-100">
                            <div>
                                <p class="font-medium text-gray-700">Trạng thái</p>
                                <p class="text-sm text-gray-500">Hiển thị bài viết</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" name="isActive" class="sr-only peer" 
                                       ${isEdit ? (post.active ? 'checked' : '') : 'checked'}>
                                <div class="w-14 h-7 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:left-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-blue-600"></div>
                            </label>
                        </div>

                        <c:if test="${isEdit}">
                            <div class="py-3">
                                <p class="text-sm text-gray-500">
                                    <i class='bx bx-user mr-1'></i> Tác giả: ${post.author.username}
                                </p>
                                <p class="text-sm text-gray-500 mt-1">
                                    <i class='bx bx-calendar mr-1'></i> Ngày tạo: ${post.publishedAt}
                                </p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Thumbnail -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <h3 class="font-bold text-gray-900 mb-4 flex items-center gap-2">
                            <i class='bx bx-image'></i> Ảnh đại diện
                        </h3>
                        <input type="text" name="thumbnailUrl" id="thumbnailUrl"
                               value="${isEdit ? post.thumbnailUrl : thumbnailUrl}" 
                               placeholder="Nhập URL hình ảnh..."
                               class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                               oninput="previewImage()">
                        
                        <!-- Preview -->
                        <div class="mt-4">
                            <img id="thumbnailPreview" 
                                 src="${isEdit && not empty post.thumbnailUrl ? post.thumbnailUrl : 'https://via.placeholder.com/400x250?text=Preview'}" 
                                 alt="Preview" 
                                 class="w-full h-40 object-cover rounded-lg bg-gray-100">
                        </div>
                        <p class="text-xs text-gray-500 mt-2">Kích thước khuyến nghị: 800x500px</p>
                    </div>

                    <!-- Actions -->
                    <div class="bg-white rounded-xl shadow-sm p-6">
                        <button type="submit" 
                                class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-lg flex items-center justify-center gap-2">
                            <i class='bx ${isEdit ? "bx-save" : "bx-plus"}'></i>
                            ${isEdit ? 'Lưu thay đổi' : 'Tạo bài viết'}
                        </button>
                        <a href="${pageContext.request.contextPath}/staff/blogs" 
                           class="block w-full text-center bg-gray-100 text-gray-700 font-bold py-4 rounded-xl hover:bg-gray-200 transition mt-3">
                            Hủy
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </main>
</div>

<script>
function previewImage() {
    const url = document.getElementById('thumbnailUrl').value;
    const preview = document.getElementById('thumbnailPreview');
    if (url) {
        preview.src = url;
        preview.onerror = function() {
            this.src = 'https://via.placeholder.com/400x250?text=Invalid+URL';
        };
    } else {
        preview.src = 'https://via.placeholder.com/400x250?text=Preview';
    }
}
</script>

</body>
</html>


