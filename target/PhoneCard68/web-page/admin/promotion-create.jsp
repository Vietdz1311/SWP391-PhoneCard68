<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo khuyến mãi mới</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-3xl bg-white p-8 rounded-xl shadow-lg border border-gray-200 my-10">
        <div class="text-gray-500 text-sm mb-6 font-bold uppercase">
            Admin > Promotion Management > <span class="text-blue-600">Create New Promotion</span>
        </div>

        <h2 class="text-3xl font-bold mb-8 text-gray-800 border-b pb-4">Tạo chương trình khuyến mãi</h2>

        <c:if test="${not empty error}">
            <div class="bg-red-50 text-red-600 p-3 rounded-lg mb-6 border border-red-200 font-medium">
                <i class='bx bx-error-circle mr-2'></i> ${error}
            </div>
        </c:if>

        <form id="createForm" action="${pageContext.request.contextPath}/admin/promotions" method="post" class="space-y-6">
            <input type="hidden" name="action" value="create">

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Mã khuyến mãi (Code) <span class="text-red-500">*</span></label>
                <input type="text" name="code" required placeholder="VD: SALE50, TET2025" value="${promo.code}"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 uppercase focus:outline-none focus:border-blue-500 transition">
                <p class="text-xs text-gray-500 mt-1">Viết hoa, không dấu cách, duy nhất.</p>
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Loại giảm giá <span class="text-red-500">*</span></label>
                    <select id="discountType" name="discountType" class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                        <option value="PERCENTAGE" ${promo.discountType == 'PERCENTAGE' ? 'selected' : ''}>Theo phần trăm (%)</option>
                        <option value="FIXED_AMOUNT" ${promo.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Giá trị giảm <span class="text-red-500">*</span></label>
                    <input type="number" id="discountValue" name="discountValue" required min="1" 
                           value="<fmt:formatNumber value='${promo.discountValue}' type='number' groupingUsed='false' maxFractionDigits='0'/>"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Đơn hàng tối thiểu (Min Order)</label>
                <input type="number" id="minOrderValue" name="minOrderValue" min="0" 
                       value="<c:out value="${promo.minOrderValue}" default="0"/>"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Ngày bắt đầu <span class="text-red-500">*</span></label>
                    <input type="datetime-local" name="startDate" required value="${promo.startDate}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Ngày kết thúc <span class="text-red-500">*</span></label>
                    <input type="datetime-local" name="endDate" required value="${promo.endDate}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Tổng giới hạn (Toàn hệ thống)</label>
                    <input type="number" name="usageLimit" required min="1" value="<c:out value="${promo.usageLimit}" default="100"/>"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Giới hạn mỗi người</label>
                    <input type="number" name="usagePerUser" required min="1" value="<c:out value="${promo.usagePerUser}" default="1"/>"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div class="flex gap-4 mt-8 pt-4 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/admin/promotions" 
                   class="w-1/3 bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-3 rounded-lg text-center transition">
                    Hủy bỏ
                </a>
                <button type="submit" 
                        class="w-2/3 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition shadow-md">
                    Tạo khuyến mãi
                </button>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('createForm').addEventListener('submit', function(e) {
            const type = document.getElementById('discountType').value;
            const value = parseFloat(document.getElementById('discountValue').value);
            const minOrder = parseFloat(document.getElementById('minOrderValue').value);

            // 1. Check Phần trăm > 100
            if (type === 'PERCENTAGE' && value > 100) {
                alert('Lỗi: Giảm giá phần trăm không được vượt quá 100%!');
                e.preventDefault(); 
                return;
            }

            // 2. Check Số tiền giảm > Min Order
            if (type === 'FIXED_AMOUNT' && value > minOrder) {
                alert('Lỗi: Số tiền giảm (' + value + ') không được lớn hơn Đơn hàng tối thiểu (' + minOrder + ')!');
                e.preventDefault();
                return;
            }
        });
    </script>
</body>
</html>