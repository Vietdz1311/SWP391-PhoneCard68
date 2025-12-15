<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo nhân viên mới</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-2xl bg-white p-8 rounded-xl shadow-lg border border-gray-200">
        <div class="text-gray-500 text-sm mb-6 font-bold uppercase">
            Admin > User Management > <span class="text-blue-600">Create New Staff</span>
        </div>

        <h2 class="text-3xl font-bold mb-8 text-gray-800 border-b pb-4">Tạo tài khoản Nhân viên</h2>

        <c:if test="${not empty error}">
            <div class="bg-red-50 text-red-600 p-3 rounded-lg mb-6 border border-red-200 flex items-center">
                <i class='bx bx-error-circle mr-2 text-xl'></i> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/user-create" method="post" class="space-y-6">
            <input type="hidden" name="action" value="create">

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Tên đăng nhập <span class="text-red-500">*</span></label>
                <input type="text" name="username" required value="${tempUser.username}"
                       pattern="[a-zA-Z0-9_]+" title="Chỉ chứa chữ cái, số và dấu gạch dưới, không khoảng trắng"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Email <span class="text-red-500">*</span></label>
                <input type="email" name="email" required value="${tempUser.email}"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Mật khẩu <span class="text-red-500">*</span></label>
                <input type="password" name="password" required minlength="6"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
                <p class="text-xs text-gray-500 mt-1">Tối thiểu 6 ký tự.</p>
            </div>

            <div>
                <label class="block mb-2 font-semibold text-gray-700">Số điện thoại <span class="text-red-500">*</span></label>
                <input type="tel" name="phone" required value="${tempUser.phone}"
                       pattern="[0-9]{10,11}" title="Số điện thoại phải có 10-11 chữ số"
                       class="w-full bg-white border border-gray-300 rounded-lg px-4 py-3 text-gray-800 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
            </div>

            <div class="flex gap-4 mt-8 pt-4 border-t border-gray-100">
                <a href="${pageContext.request.contextPath}/admin/staff" 
                   class="w-1/3 bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-3 rounded-lg text-center transition">
                    Hủy bỏ
                </a>
                <button type="submit" 
                        class="w-2/3 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition shadow-md">
                    Tạo tài khoản
                </button>
            </div>
        </form>
    </div>
</body>
</html>