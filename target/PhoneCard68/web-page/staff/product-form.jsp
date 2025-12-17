<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Sửa' : 'Thêm'} Sản phẩm - Staff</title>
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
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
                <i class='bx bx-user text-xl'></i>
                Danh sách tài khoản
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Sản phẩm</div>
            <a href="${pageContext.request.contextPath}/staff/products" 
               class="flex items-center gap-3 px-6 py-3 text-white bg-blue-600/20 border-r-4 border-blue-500">
                <i class='bx bx-package text-xl'></i>
                Quản lý Sản phẩm
            </a>
            
            <div class="px-6 mb-2 mt-6 text-xs font-bold text-slate-500 uppercase">Nội dung</div>
            <a href="${pageContext.request.contextPath}/staff/blogs" 
               class="flex items-center gap-3 px-6 py-3 text-slate-300 hover:bg-slate-700/50 transition">
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
    </aside>

    <!-- Main Content -->
    <main class="ml-64 flex-1 p-8">
        <!-- Breadcrumb -->
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/staff/products" class="text-blue-600 hover:underline flex items-center gap-1 w-fit">
                <i class='bx bx-arrow-back'></i> Quay lại danh sách sản phẩm
            </a>
        </div>

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">
                <i class='bx ${isEdit ? "bx-edit" : "bx-plus-circle"} mr-2 text-blue-600'></i>
                ${isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'}
            </h1>
            <p class="text-gray-600 mt-1">${isEdit ? 'Cập nhật thông tin sản phẩm' : 'Tạo sản phẩm thẻ cào mới'}</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r-xl flex items-center">
                <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
                <span class="text-red-700 font-medium">${error}</span>
            </div>
        </c:if>

        <!-- Form -->
        <div class="bg-white rounded-xl shadow-sm p-8 max-w-2xl">
            <form action="${pageContext.request.contextPath}/staff/products" method="post">
                <input type="hidden" name="action" value="${isEdit ? 'edit' : 'create'}">
                <c:if test="${isEdit}">
                    <input type="hidden" name="productId" value="${product.productId}">
                </c:if>
                
                <!-- Provider -->
                <div class="mb-6">
                    <label class="block text-gray-700 font-medium mb-2">
                        <i class='bx bx-broadcast mr-1'></i> Nhà mạng <span class="text-red-500">*</span>
                    </label>
                    <select name="providerId" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="">-- Chọn nhà mạng --</option>
                        <c:forEach var="provider" items="${providers}">
                            <option value="${provider.providerId}" 
                                ${(isEdit && product.providerId == provider.providerId) || selectedProviderId == provider.providerId ? 'selected' : ''}>
                                ${provider.providerName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <!-- Product Name -->
                <div class="mb-6">
                    <label class="block text-gray-700 font-medium mb-2">
                        <i class='bx bx-tag mr-1'></i> Tên sản phẩm <span class="text-red-500">*</span>
                    </label>
                    <input type="text" name="productName" required
                           value="${isEdit ? product.productName : productName}"
                           placeholder="VD: Thẻ Viettel 100K"
                           class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                
                <!-- Face Value & Selling Price -->
                <div class="grid grid-cols-2 gap-6 mb-6">
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">
                            <i class='bx bx-money mr-1'></i> Mệnh giá (VNĐ) <span class="text-red-500">*</span>
                        </label>
                        <input type="number" name="faceValue" required min="1000" step="1000"
                               value="${isEdit ? product.faceValue : faceValue}"
                               placeholder="100000"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">
                            <i class='bx bx-purchase-tag mr-1'></i> Giá bán (VNĐ) <span class="text-red-500">*</span>
                        </label>
                        <input type="number" name="sellingPrice" required min="1000" step="1000"
                               value="${isEdit ? product.sellingPrice : sellingPrice}"
                               placeholder="98000"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
                
                <!-- Description -->
                <div class="mb-8">
                    <label class="block text-gray-700 font-medium mb-2">
                        <i class='bx bx-text mr-1'></i> Mô tả
                    </label>
                    <textarea name="description" rows="4"
                              placeholder="Mô tả ngắn về sản phẩm..."
                              class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none">${isEdit ? product.description : description}</textarea>
                </div>
                
                <!-- Buttons -->
                <div class="flex gap-4">
                    <a href="${pageContext.request.contextPath}/staff/products" 
                       class="flex-1 bg-gray-100 text-gray-700 font-bold py-3 rounded-xl hover:bg-gray-200 transition text-center">
                        Hủy
                    </a>
                    <button type="submit" 
                            class="flex-1 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-3 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition flex items-center justify-center gap-2">
                        <i class='bx ${isEdit ? "bx-save" : "bx-plus"}'></i>
                        ${isEdit ? 'Lưu thay đổi' : 'Tạo sản phẩm'}
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

</body>
</html>

