<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết khuyến mãi</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-3xl bg-white p-8 rounded-xl shadow-lg border border-gray-200 my-10">
        <div class="text-gray-500 text-sm mb-6 font-bold uppercase">
            Admin > Promotion Management > <span class="text-blue-600">Edit Promotion</span>
        </div>

        <h2 class="text-3xl font-bold mb-8 text-gray-800 border-b pb-4">Cập nhật khuyến mãi</h2>
        
        <c:if test="${not empty param.success}">
            <div class="mb-6 p-3 bg-green-100 text-green-700 rounded-lg text-center font-medium">Cập nhật thành công!</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/promotions" method="post" class="space-y-6">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="promotionId" value="${promo.promotionId}">

            <div>
                <label class="block mb-2 font-semibold text-gray-500">Mã khuyến mãi (Không thể sửa)</label>
                <input type="text" value="${promo.code}" readonly
                       class="w-full bg-gray-100 border border-gray-300 rounded-lg px-4 py-3 text-gray-500 cursor-not-allowed">
            </div>

            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Loại giảm giá</label>
                    <select name="discountType" class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                        <option value="PERCENTAGE" ${promo.discountType == 'PERCENTAGE' ? 'selected' : ''}>Theo phần trăm (%)</option>
                        <option value="FIXED_AMOUNT" ${promo.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                    </select>
                </div>
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">Giá trị giảm</label>
                    <input type="number" name="discountValue" required min="1" value="${promo.discountValue}"
                           class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500">
                </div>
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Đơn hàng tối thiểu</label>
                <input type="number" name="minOrderValue" min="0" value="${promo.minOrderValue}"
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
</body>
</html>