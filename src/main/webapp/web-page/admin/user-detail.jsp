<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tài khoản</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans text-gray-800 flex items-center justify-center min-h-screen">

    <div class="w-full max-w-2xl bg-white p-10 rounded-xl shadow-lg border border-gray-200">
        <div class="text-gray-500 text-sm mb-6 font-bold uppercase">
            Admin > User Management > <span class="text-blue-600">Details: ${userinfo.username}</span>
        </div>

        <h2 class="text-3xl font-bold mb-8 text-center text-gray-800">
            Thông tin ${userinfo.role == 'Staff' ? 'Nhân viên' : 'Khách hàng'}
        </h2>
        
        <c:if test="${not empty param.success}">
            <div class="mb-6 p-3 bg-green-100 text-green-700 rounded-lg text-center font-medium">Cập nhật thành công!</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="mb-6 p-3 bg-red-100 text-red-700 rounded-lg text-center font-medium">Có lỗi xảy ra!</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/user-detail" method="post" class="space-y-6 text-lg">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userId" value="${userinfo.userId}">

            <div class="grid grid-cols-3 items-center gap-4 border-b border-gray-100 pb-4">
                <label class="text-gray-500 font-medium">Tên đăng nhập:</label>
                <div class="col-span-2 text-gray-900 font-bold">${userinfo.username}</div>
            </div>

            <div class="grid grid-cols-3 items-center gap-4 border-b border-gray-100 pb-4">
                <label class="text-gray-500 font-medium">Email:</label>
                <div class="col-span-2 text-gray-900 font-bold">${userinfo.email}</div>
            </div>

            <div class="grid grid-cols-3 items-center gap-4 border-b border-gray-100 pb-4">
                <label class="text-gray-500 font-medium">Số điện thoại:</label>
                <div class="col-span-2">
                    <c:choose>
                        <c:when test="${userinfo.role == 'Staff'}">
                             <%-- Staff: Hiện ô input để sửa --%>
                            <input type="text" name="phone" value="${userinfo.phone}" 
                                   class="w-full bg-gray-50 border border-gray-300 rounded px-4 py-2 text-gray-800 focus:outline-none focus:border-blue-500 transition">
                        </c:when>
                        <c:otherwise>
                             <%-- Customer: Chỉ hiện text --%>
                             <span class="text-gray-900 font-bold">${userinfo.phone}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${userinfo.role == 'Customer'}">
                <div class="grid grid-cols-3 items-center gap-4 border-b border-gray-100 pb-4">
                    <label class="text-gray-500 font-medium">Số dư ví:</label>
                    <div class="col-span-2 text-green-600 font-bold text-xl">
                        <fmt:formatNumber value="${userinfo.walletBalance}" type="number"/> đ
                    </div>
                </div>
            </c:if>

            <c:if test="${userinfo.role == 'Staff'}">
                <div class="grid grid-cols-3 items-center gap-4 border-b border-gray-100 pb-4">
                    <label class="text-gray-500 font-medium">Đặt lại mật khẩu:</label>
                    <input type="text" name="newPassword" placeholder="Nhập mật khẩu mới (nếu cần)..." 
                           class="col-span-2 bg-gray-50 border border-gray-300 rounded px-4 py-2 text-gray-800 focus:outline-none focus:border-blue-500 transition">
                </div>
            </c:if>

            <div class="grid grid-cols-3 items-center gap-4 pb-4">
                <label class="text-gray-500 font-medium">Trạng thái:</label>
                <div class="col-span-2">
                    <span class="px-3 py-1 rounded-full text-sm font-bold ${userinfo.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                        ${userinfo.status}
                    </span>
                </div>
            </div>

            <div class="flex flex-col gap-4 mt-8 pt-6 border-t border-gray-200">
                <div class="flex gap-4">
                    <a href="${pageContext.request.contextPath}/admin/staff?action=${userinfo.status == 'Active' ? 'lock' : 'unlock'}&id=${userinfo.userId}" 
                       class="flex-1 ${userinfo.status == 'Active' ? 'bg-red-600 hover:bg-red-700 text-white' : 'bg-green-600 hover:bg-green-700 text-white'} font-bold py-3 rounded-lg text-center transition uppercase shadow-md flex items-center justify-center">
                        <i class='bx ${userinfo.status == 'Active' ? 'bx-lock-alt' : 'bx-lock-open-alt'} mr-2 text-xl'></i>
                        ${userinfo.status == 'Active' ? 'Khóa tài khoản' : 'Mở khóa'}
                    </a>

                    <c:if test="${userinfo.role == 'Staff'}">
                        <button type="submit" class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition shadow-md uppercase flex items-center justify-center">
                            <i class='bx bx-save mr-2 text-xl'></i> Lưu thay đổi
                        </button>
                    </c:if>
                </div>

                <a href="${pageContext.request.contextPath}/admin/${userinfo.role == 'Customer' ? 'customers' : 'staff'}" 
                   class="w-full bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-3 rounded-lg text-center transition uppercase">
                    Quay lại danh sách
                </a>
            </div>
        </form>
    </div>
</body>
</html>