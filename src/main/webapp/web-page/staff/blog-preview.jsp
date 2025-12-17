<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem trước: ${post.title} - Staff</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen font-inter">

<!-- Top Bar -->
<div class="bg-gradient-to-r from-slate-800 to-slate-900 text-white py-3 px-6 flex items-center justify-between sticky top-0 z-50 shadow-lg">
    <div class="flex items-center gap-4">
        <a href="${pageContext.request.contextPath}/staff/blogs" class="flex items-center gap-2 hover:text-blue-400 transition">
            <i class='bx bx-arrow-back text-xl'></i>
            <span>Quay lại danh sách</span>
        </a>
        <span class="text-slate-500">|</span>
        <span class="flex items-center gap-2 text-slate-300">
            <i class='bx bx-show'></i>
            Chế độ xem trước
        </span>
    </div>
    
    <div class="flex items-center gap-4">
        <!-- Status Badge -->
        <c:choose>
            <c:when test="${post.active}">
                <span class="px-4 py-1.5 bg-green-500/20 text-green-400 rounded-full text-sm font-medium flex items-center gap-2">
                    <i class='bx bx-check-circle'></i> Đã đăng
                </span>
            </c:when>
            <c:otherwise>
                <span class="px-4 py-1.5 bg-yellow-500/20 text-yellow-400 rounded-full text-sm font-medium flex items-center gap-2">
                    <i class='bx bx-hide'></i> Bản nháp - Chưa công khai
                </span>
            </c:otherwise>
        </c:choose>
        
        <a href="${pageContext.request.contextPath}/staff/blogs?action=edit&id=${post.postId}" 
           class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition flex items-center gap-2">
            <i class='bx bx-edit'></i> Chỉnh sửa
        </a>
    </div>
</div>

<!-- Draft Warning Banner -->
<c:if test="${!post.active}">
    <div class="bg-yellow-50 border-b border-yellow-200 py-4 px-6">
        <div class="max-w-5xl mx-auto flex items-center gap-3">
            <i class='bx bx-info-circle text-yellow-600 text-2xl'></i>
            <div>
                <p class="text-yellow-800 font-medium">Bài viết này đang ở chế độ nháp</p>
                <p class="text-yellow-600 text-sm">Chỉ Staff/Admin mới có thể xem. Bật trạng thái "Đăng bài" để công khai.</p>
            </div>
        </div>
    </div>
</c:if>

<!-- Blog Content Preview -->
<section class="py-12 bg-gray-50">
    <div class="container mx-auto px-4">
        <div class="max-w-5xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden">
            <!-- Thumbnail -->
            <img src="${post.thumbnailUrl != null && !post.thumbnailUrl.isEmpty() ? post.thumbnailUrl : 'https://via.placeholder.com/1200x600?text=Tin+Tuc'}"
                 alt="${post.title}" 
                 class="w-full h-96 object-cover">

            <div class="p-10 md:p-16">
                <!-- Title -->
                <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6 leading-tight">${post.title}</h1>

                <!-- Meta Info -->
                <div class="flex flex-wrap items-center text-gray-500 mb-10 gap-6 text-sm">
                    <c:if test="${post.author != null}">
                        <span class="flex items-center gap-2">
                            <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-bold text-xs">
                                ${post.author.username.charAt(0)}
                            </div>
                            ${post.author.username}
                        </span>
                    </c:if>
                    <c:if test="${post.publishedAt != null}">
                        <span class="flex items-center gap-2">
                            <i class='bx bx-calendar text-lg'></i>
                            ${post.formattedDateTime}
                        </span>
                    </c:if>
                    <span class="flex items-center gap-2">
                        <i class='bx bx-link text-lg'></i>
                        Slug: <code class="bg-gray-100 px-2 py-1 rounded text-xs">${post.slug}</code>
                    </span>
                </div>

                <!-- Content -->
                <div class="prose prose-lg max-w-none text-gray-700 leading-relaxed">
                    ${post.content}
                </div>

                <!-- Action Footer -->
                <div class="mt-12 pt-8 border-t border-gray-200 flex flex-wrap gap-4 items-center justify-between">
                    <a href="${pageContext.request.contextPath}/staff/blogs" 
                       class="inline-flex items-center text-blue-600 font-bold hover:text-blue-800 transition">
                        <i class='bx bx-chevron-left mr-2'></i> Quay lại danh sách
                    </a>
                    
                    <div class="flex gap-3">
                        <a href="${pageContext.request.contextPath}/staff/blogs?action=edit&id=${post.postId}" 
                           class="bg-orange-500 text-white px-5 py-2.5 rounded-xl hover:bg-orange-600 transition font-medium flex items-center gap-2">
                            <i class='bx bx-edit'></i> Chỉnh sửa
                        </a>
                        <c:if test="${post.active}">
                            <a href="${pageContext.request.contextPath}/blog?action=details&slug=${post.slug}" 
                               target="_blank"
                               class="bg-blue-600 text-white px-5 py-2.5 rounded-xl hover:bg-blue-700 transition font-medium flex items-center gap-2">
                                <i class='bx bx-link-external'></i> Xem trang công khai
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Post Info Card -->
        <div class="max-w-5xl mx-auto mt-8 bg-white rounded-xl shadow-md p-6">
            <h3 class="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                <i class='bx bx-info-circle text-blue-600'></i> Thông tin bài viết
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div class="bg-gray-50 rounded-lg p-4">
                    <p class="text-gray-500 mb-1">ID</p>
                    <p class="font-bold text-gray-800">#${post.postId}</p>
                </div>
                <div class="bg-gray-50 rounded-lg p-4">
                    <p class="text-gray-500 mb-1">Trạng thái</p>
                    <p class="font-bold ${post.active ? 'text-green-600' : 'text-yellow-600'}">
                        ${post.active ? 'Đã đăng' : 'Bản nháp'}
                    </p>
                </div>
                <div class="bg-gray-50 rounded-lg p-4">
                    <p class="text-gray-500 mb-1">Tác giả</p>
                    <p class="font-bold text-gray-800">${post.author != null ? post.author.username : 'N/A'}</p>
                </div>
                <div class="bg-gray-50 rounded-lg p-4">
                    <p class="text-gray-500 mb-1">Ngày đăng</p>
                    <p class="font-bold text-gray-800">${post.publishedAt != null ? post.formattedDateTime : 'Chưa đăng'}</p>
                </div>
            </div>
        </div>
    </div>
</section>

</body>
</html>

