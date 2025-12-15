<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết khuyến mãi</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-3xl bg-white p-8 rounded-xl shadow-lg border border-gray-200 my-10">
        <div class="text-gray-500 text-sm mb-6 font-bold uppercase">
            Admin > Promotion Management > <span class="text-blue-600">Edit Promotion</span>
        </div>

        <h2 class="text-3xl font-bold mb-8 text-gray-800 border-b pb-4">Cập nhật khuyến mãi</h2>
        
        <c:if test="${not empty param.success}">
            <div class="mb-6 p-3 bg-green-100 text-green-700 rounded-lg text-center font-medium border border-green-200">
                <i class='bx bx-check-circle mr-1'></i> Cập nhật thành công!
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="mb-6 p-3 bg-red-100 text-red-700 rounded-lg text-center font-medium border border-red-200">
                <i class='bx bx-error-circle mr-1'></i> ${error}
            </div>
        </c:if>

        <form id="promoForm" action="${pageContext.request.contextPath}/admin/promotions" method="post" class="space-y-6">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="promotionId" value="${promo.promotionId}">
            <input type="hidden" name="code" value="${promo.code}"> 

            <div>
                <label class="block mb-2 font-semibold text-gray-500">Mã khuyến mãi (Không thể sửa)</label>
                <input type="text" value="${promo.code}" readonly
                       class="w-full bg-gray-100 border border-gray-300 rounded-lg px-4 py-3 text-gray-500 cursor-not-allowed font-bold">
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Loại giảm giá</label>
                    <select id="discountType" name="discountType" class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                        <option value="PERCENTAGE" ${promo.discountType == 'PERCENTAGE' ? 'selected' : ''}>Theo phần trăm (%)</option>
                        <option value="FIXED_AMOUNT" ${promo.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Giá trị giảm</label>
                    <input type="number" id="discountValue" name="discountValue" required min="1" 
                           value="<fmt:formatNumber value='${promo.discountValue}' type='number' groupingUsed='false' maxFractionDigits='0'/>"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Đơn hàng tối thiểu</label>
                <input type="number" id="minOrderValue" name="minOrderValue" min="0" 
                       value="<fmt:formatNumber value='${promo.minOrderValue}' type='number' groupingUsed='false' maxFractionDigits='0'/>"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Ngày bắt đầu</label>
                    <input type="datetime-local" name="startDate" required value="${promo.startDate}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Ngày kết thúc</label>
                    <input type="datetime-local" name="endDate" required value="${promo.endDate}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Tổng giới hạn</label>
                    <input type="number" name="usageLimit" required min="1" value="${promo.usageLimit}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Giới hạn mỗi người</label>
                    <input type="number" name="usagePerUser" required min="1" value="${promo.usagePerUser}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>
            
            <div>
                <label class="block mb-2 font-semibold text-gray-700">Trạng thái</label>
                <select name="status" class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                    <option value="Active" ${promo.status == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Ended" ${promo.status == 'Ended' ? 'selected' : ''}>Ended (Kết thúc)</option>
                </select>
            </div>

            <div class="flex gap-4 mt-8 pt-4 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/admin/promotions" 
                   class="w-1/3 bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-3 rounded-lg text-center transition">
                    Quay lại
                </a>
                <button type="submit" 
                        class="w-2/3 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition shadow-md">
                    Lưu thay đổi
                </button>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('promoForm').addEventListener('submit', function(e) {
            const type = document.getElementById('discountType').value;
            const value = parseFloat(document.getElementById('discountValue').value);
            const minOrder = parseFloat(document.getElementById('minOrderValue').value);

            // 1. Check Phần trăm > 100
            if (type === 'PERCENTAGE' && value > 100) {
                alert('Lỗi: Giảm giá phần trăm không được vượt quá 100%!');
                e.preventDefault(); // Chặn submit form
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