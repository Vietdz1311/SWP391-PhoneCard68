<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm thẻ vào kho - Staff</title>
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
            <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}" class="text-blue-600 hover:underline">Kho ${product.productName}</a>
            <i class='bx bx-chevron-right text-gray-400'></i>
            <span class="text-gray-600">Thêm thẻ</span>
        </div>

        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">
                <i class='bx bx-plus-circle mr-2 text-green-600'></i>
                Thêm thẻ vào kho
            </h1>
            <p class="text-gray-600 mt-1">
                Sản phẩm: <span class="font-semibold text-blue-600">${product.productName}</span> - 
                ${product.provider.providerName}
            </p>
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
            <form action="${pageContext.request.contextPath}/staff/products" method="post" id="inventoryForm">
                <input type="hidden" name="action" value="add-inventory">
                <input type="hidden" name="productId" value="${product.productId}">
                
                <!-- Mode Selection -->
                <div class="mb-8">
                    <label class="block text-gray-700 font-medium mb-4">
                        <i class='bx bx-cog mr-1'></i> Chế độ thêm thẻ
                    </label>
                    <div class="grid grid-cols-2 gap-4">
                        <label class="relative">
                            <input type="radio" name="addMode" value="manual" checked class="peer sr-only" onchange="toggleMode(this.value)">
                            <div class="p-4 border-2 border-gray-200 rounded-xl cursor-pointer transition
                                        peer-checked:border-blue-500 peer-checked:bg-blue-50">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                        <i class='bx bx-edit text-blue-600 text-xl'></i>
                                    </div>
                                    <div>
                                        <p class="font-bold text-gray-900">Nhập thủ công</p>
                                        <p class="text-sm text-gray-500">Nhập Serial & Mã thẻ</p>
                                    </div>
                                </div>
                            </div>
                        </label>
                        <label class="relative">
                            <input type="radio" name="addMode" value="random" class="peer sr-only" onchange="toggleMode(this.value)">
                            <div class="p-4 border-2 border-gray-200 rounded-xl cursor-pointer transition
                                        peer-checked:border-green-500 peer-checked:bg-green-50">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                                        <i class='bx bx-dice-5 text-green-600 text-xl'></i>
                                    </div>
                                    <div>
                                        <p class="font-bold text-gray-900">Sinh ngẫu nhiên</p>
                                        <p class="text-sm text-gray-500">Tự động tạo mã thẻ</p>
                                    </div>
                                </div>
                            </div>
                        </label>
                    </div>
                </div>
                
                <!-- Manual Mode Fields -->
                <div id="manualFields">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-medium mb-2">
                            <i class='bx bx-barcode mr-1'></i> Serial Number <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="serialNumber" id="serialNumber"
                               placeholder="VD: 12345678901234"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    
                    <div class="mb-6">
                        <label class="block text-gray-700 font-medium mb-2">
                            <i class='bx bx-key mr-1'></i> Mã thẻ (Card Code) <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="cardCode" id="cardCode"
                               placeholder="VD: ABCD1234EFGH"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
                
                <!-- Random Mode Fields -->
                <div id="randomFields" class="hidden">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-medium mb-2">
                            <i class='bx bx-layer mr-1'></i> Số lượng thẻ <span class="text-red-500">*</span>
                        </label>
                        <input type="number" name="quantity" id="quantity" min="1" max="1000" value="10"
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <p class="text-sm text-gray-500 mt-1">Tối đa 1000 thẻ mỗi lần</p>
                    </div>
                    
                    <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 rounded-r-xl mb-6">
                        <p class="text-yellow-800 text-sm">
                            <i class='bx bx-info-circle mr-1'></i>
                            <strong>Lưu ý:</strong> Serial và mã thẻ sẽ được sinh ngẫu nhiên. 
                            Đây chỉ dùng cho mục đích test/demo.
                        </p>
                    </div>
                </div>
                
                <!-- Expiry Date (Both modes) -->
                <div class="mb-8">
                    <label class="block text-gray-700 font-medium mb-2">
                        <i class='bx bx-calendar mr-1'></i> Ngày hết hạn <span class="text-red-500">*</span>
                    </label>
                    <input type="date" name="expiryDate" required
                           min="${java.time.LocalDate.now().plusDays(1)}"
                           class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                
                <!-- Buttons -->
                <div class="flex gap-4">
                    <a href="${pageContext.request.contextPath}/staff/products?action=inventory&productId=${product.productId}" 
                       class="flex-1 bg-gray-100 text-gray-700 font-bold py-3 rounded-xl hover:bg-gray-200 transition text-center">
                        Hủy
                    </a>
                    <button type="submit" 
                            class="flex-1 bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold py-3 rounded-xl hover:from-green-700 hover:to-emerald-700 transition flex items-center justify-center gap-2">
                        <i class='bx bx-plus'></i>
                        Thêm vào kho
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
function toggleMode(mode) {
    const manualFields = document.getElementById('manualFields');
    const randomFields = document.getElementById('randomFields');
    const serialInput = document.getElementById('serialNumber');
    const cardCodeInput = document.getElementById('cardCode');
    const quantityInput = document.getElementById('quantity');
    
    if (mode === 'manual') {
        manualFields.classList.remove('hidden');
        randomFields.classList.add('hidden');
        serialInput.required = true;
        cardCodeInput.required = true;
        quantityInput.required = false;
    } else {
        manualFields.classList.add('hidden');
        randomFields.classList.remove('hidden');
        serialInput.required = false;
        cardCodeInput.required = false;
        quantityInput.required = true;
    }
}

// Set default expiry date to 1 year from now
document.addEventListener('DOMContentLoaded', function() {
    const expiryInput = document.querySelector('input[name="expiryDate"]');
    const nextYear = new Date();
    nextYear.setFullYear(nextYear.getFullYear() + 1);
    expiryInput.value = nextYear.toISOString().split('T')[0];
    
    // Set min date to tomorrow
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    expiryInput.min = tomorrow.toISOString().split('T')[0];
});
</script>

</body>
</html>

