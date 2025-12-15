<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Nhà cung cấp</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">
    <div class="w-full max-w-lg bg-white p-8 rounded-xl shadow-lg border border-gray-200">
        <h2 class="text-2xl font-bold mb-6 border-b pb-2">Thêm Nhà cung cấp mới</h2>
        
        <form action="${pageContext.request.contextPath}/admin/providers" method="post" class="space-y-4">
            <input type="hidden" name="action" value="create">
            
            <div>
                <label class="block font-medium mb-1">Tên nhà cung cấp</label>
                <input type="text" name="providerName" required placeholder="VD: Viettel, Vinaphone"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:border-blue-500">
            </div>
            
            <div>
                <label class="block font-medium mb-1">Mã Code (Viết tắt)</label>
                <input type="text" name="providerCode" required placeholder="VD: VTT, VNP"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:border-blue-500 uppercase">
            </div>
            
            <div>
                <label class="block font-medium mb-1">Trạng thái</label>
                <select name="status" class="w-full border rounded px-3 py-2 focus:outline-none focus:border-blue-500">
                    <option value="Active">Active (Hoạt động)</option>
                    <option value="Inactive">Inactive (Tạm ngưng)</option>
                </select>
            </div>
            
            <div class="flex gap-3 mt-6">
                <a href="${pageContext.request.contextPath}/admin/providers" class="flex-1 bg-gray-200 text-center py-2 rounded hover:bg-gray-300 font-bold">Hủy</a>
                <button type="submit" class="flex-1 bg-blue-600 text-white py-2 rounded hover:bg-blue-700 font-bold">Lưu lại</button>
            </div>
        </form>
    </div>
</body>
</html>