<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kho thẻ ${product.productName} - Staff</title>
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
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="ml-64 flex-1 p-8">
        <!-- Breadcrumb -->
        <div class="mb-6 flex items-center gap-2 text-sm">
            <a href="${pageContext.request.contextPath}/staff/products" class="text-blue-600 hover:underline">Sản phẩm</a>
            <i class='bx bx-chevron-right text-gray-400'></i>
            <span class="text-gray-600">Kho ${product.productName}</span>
        </div>

        <!-- Header -->
        <div class="flex justify-between items-start mb-8">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 flex items-center gap-2">
                    <i class='bx bx-box text-blue-600'></i>
                    Kho thẻ: ${product.productName}
                </h1>
                <p class="text-gray-600 mt-1">
                    ${product.provider.providerName} • Mệnh giá: <fmt:formatNumber value="${product.faceValue}" type="number" groupingUsed="true"/>₫
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/products?action=add-inventory&productId=${product.productId}" 
               class="bg-gradient-to-r from-green-600 to-emerald-600 text-white px-6 py-3 rounded-xl font-bold hover:from-green-700 hover:to-emerald-700 transition shadow-lg flex items-center gap-2">
                <i class='bx bx-plus'></i> Thêm thẻ vào kho
            </a>
        </div>

        <!-- Messages -->
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

        <!-- Stats -->
        <div class="grid grid-cols-3 gap-6 mb-6">
            <div class="bg-white rounded-xl shadow-sm p-6">
                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 bg-green-100 rounded-xl flex items-center justify-center">
                        <i class='bx bx-check-circle text-green-600 text-3xl'></i>
                    </div>
                    <div>
                        <p class="text-3xl font-bold text-gray-900">${availableCount}</p>
                        <p class="text-gray-500">Còn hàng</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-xl shadow-sm p-6">
                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center">
                        <i class='bx bx-cart text-blue-600 text-3xl'></i>
                    </div>
                    <div>
                        <p class="text-3xl font-bold text-gray-900">${soldCount}</p>
                        <p class="text-gray-500">Đã bán</p>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-xl shadow-sm p-6">
                <div class="flex items-center gap-4">
                    <div class="w-14 h-14 bg-red-100 rounded-xl flex items-center justify-center">
                        <i class='bx bx-error text-red-600 text-3xl'></i>
                    </div>
                    <div>
                        <p class="text-3xl font-bold text-gray-900">${errorCount}</p>
                        <p class="text-gray-500">Lỗi</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter -->
        <div class="bg-white rounded-xl shadow-sm p-4 mb-6">
            <div class="flex gap-2">
                <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}"
                   class="px-4 py-2 rounded-lg font-medium transition ${empty statusFilter ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                    Tất cả (${availableCount + soldCount + errorCount})
                </a>
                <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}&status=Available"
                   class="px-4 py-2 rounded-lg font-medium transition ${statusFilter == 'Available' ? 'bg-green-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                    Còn hàng (${availableCount})
                </a>
                <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}&status=Sold"
                   class="px-4 py-2 rounded-lg font-medium transition ${statusFilter == 'Sold' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                    Đã bán (${soldCount})
                </a>
                <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}&status=Error"
                   class="px-4 py-2 rounded-lg font-medium transition ${statusFilter == 'Error' ? 'bg-red-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                    Lỗi (${errorCount})
                </a>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow-sm overflow-hidden">
            <table class="w-full">
                <thead class="bg-gray-50 border-b border-gray-200">
                    <tr>
                        <th class="text-left px-6 py-4 text-sm font-bold text-gray-600 uppercase">ID</th>
                        <th class="text-left px-6 py-4 text-sm font-bold text-gray-600 uppercase">Serial Number</th>
                        <th class="text-left px-6 py-4 text-sm font-bold text-gray-600 uppercase">Mã thẻ</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Hạn dùng</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Trạng thái</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Nhập kho</th>
                        <th class="text-center px-6 py-4 text-sm font-bold text-gray-600 uppercase">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:choose>
                        <c:when test="${not empty inventory}">
                            <c:forEach var="card" items="${inventory}">
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-6 py-4 text-gray-600">#${card.cardId}</td>
                                    <td class="px-6 py-4">
                                        <code class="bg-gray-100 px-2 py-1 rounded text-sm font-mono">${card.serialNumber}</code>
                                    </td>
                                    <td class="px-6 py-4">
                                        <c:choose>
                                            <c:when test="${card.status == 'Available'}">
                                                <code class="bg-green-100 text-green-700 px-2 py-1 rounded text-sm font-mono">${card.cardCode}</code>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 text-sm">••••••••••••</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 text-center text-sm">
                                        <span class="${card.expired ? 'text-red-600' : 'text-gray-600'}">
                                            ${card.formattedExpiryDate}
                                            <c:if test="${card.expired}">
                                                <i class='bx bx-error-circle ml-1' title="Đã hết hạn"></i>
                                            </c:if>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <c:choose>
                                            <c:when test="${card.status == 'Available'}">
                                                <span class="inline-flex items-center gap-1 px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                                                    <i class='bx bx-check-circle'></i> Còn hàng
                                                </span>
                                            </c:when>
                                            <c:when test="${card.status == 'Sold'}">
                                                <span class="inline-flex items-center gap-1 px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm font-medium">
                                                    <i class='bx bx-cart'></i> Đã bán
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-1 px-3 py-1 bg-red-100 text-red-700 rounded-full text-sm font-medium">
                                                    <i class='bx bx-error'></i> Lỗi
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 text-center text-sm text-gray-500">
                                        ${card.formattedImportedAt}
                                    </td>
                                    <td class="px-6 py-4 text-center">
                                        <c:if test="${card.status == 'Available'}">
                                            <button onclick="confirmDelete(${card.cardId}, '${card.serialNumber}')" 
                                                    class="p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-lg transition" 
                                                    title="Xóa">
                                                <i class='bx bx-trash text-xl'></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${card.status != 'Available'}">
                                            <span class="text-gray-300">—</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="px-6 py-16 text-center">
                                    <div class="flex flex-col items-center">
                                        <i class='bx bx-box text-gray-300 text-6xl mb-4'></i>
                                        <p class="text-gray-500 text-lg">
                                            <c:choose>
                                                <c:when test="${not empty statusFilter}">
                                                    Không có thẻ nào với trạng thái "${statusFilter}"
                                                </c:when>
                                                <c:otherwise>
                                                    Kho trống - Chưa có thẻ nào
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <a href="${pageContext.request.contextPath}/staff/products?action=add-inventory&productId=${product.productId}" 
                                           class="mt-4 text-green-600 font-bold hover:underline">
                                            Thêm thẻ vào kho →
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="px-6 py-4 border-t border-gray-100 flex justify-center">
                    <nav class="flex space-x-2">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}&status=${statusFilter}&page=${i}"
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

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black/60 hidden items-center justify-center z-50">
    <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full mx-4 p-8">
        <div class="text-center">
            <div class="w-16 h-16 bg-red-100 rounded-full mx-auto flex items-center justify-center mb-4">
                <i class='bx bx-trash text-red-600 text-3xl'></i>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-2">Xác nhận xóa thẻ</h3>
            <p class="text-gray-600 mb-6">Bạn có chắc chắn muốn xóa thẻ với Serial "<span id="deleteSerial" class="font-semibold font-mono"></span>"?</p>
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
function confirmDelete(cardId, serial) {
    document.getElementById('deleteSerial').textContent = serial;
    document.getElementById('deleteLink').href = '${pageContext.request.contextPath}/staff/products?action=delete-card&cardId=' + cardId + '&productId=${product.productId}';
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

