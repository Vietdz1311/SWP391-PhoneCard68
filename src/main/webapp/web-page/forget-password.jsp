<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - PhoneCard68</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center p-4">

<div class="bg-white rounded-2xl shadow-2xl p-10 w-full max-w-md">
    <!-- Header -->
    <div class="text-center mb-8">
        <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full mx-auto flex items-center justify-center mb-4">
            <i class='bx bx-lock-open text-white text-3xl'></i>
        </div>
        <h2 class="text-3xl font-bold text-gray-900">Quên mật khẩu?</h2>
        <p class="text-gray-500 mt-2">Nhập email để nhận mã OTP đặt lại mật khẩu</p>
    </div>
    
    <!-- Success Message -->
    <c:if test="${not empty success}">
        <div class="bg-green-50 border border-green-200 rounded-xl p-4 mb-6 flex items-start gap-3">
            <i class='bx bx-check-circle text-green-500 text-xl mt-0.5'></i>
            <div>
                <p class="text-green-700 font-medium">${success}</p>
                <p class="text-green-600 text-sm mt-1">Kiểm tra cả hộp thư spam nếu không thấy email.</p>
            </div>
        </div>
    </c:if>
    
    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 flex items-start gap-3">
            <i class='bx bx-error-circle text-red-500 text-xl mt-0.5'></i>
            <p class="text-red-700">${error}</p>
        </div>
    </c:if>
    
    <!-- Form -->
    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="forgot-password">
        
        <div class="mb-6">
            <label class="block text-gray-700 font-medium mb-2">
                <i class='bx bx-envelope mr-1'></i> Email đăng ký
            </label>
            <input type="email" name="email" required placeholder="example@email.com"
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
        </div>
        
        <button type="submit" 
                class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-3 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition duration-300 shadow-lg flex items-center justify-center gap-2">
            <i class='bx bx-send'></i>
            Gửi mã OTP
        </button>
    </form>
    
    <!-- Back to Login -->
    <div class="mt-8 text-center">
        <a href="${pageContext.request.contextPath}/auth" class="text-blue-600 font-medium hover:underline flex items-center justify-center gap-1">
            <i class='bx bx-arrow-back'></i>
            Quay lại đăng nhập
        </a>
    </div>
    
    <!-- Help Text -->
    <div class="mt-6 pt-6 border-t border-gray-100">
        <p class="text-gray-500 text-sm text-center">
            <i class='bx bx-info-circle mr-1'></i>
            Link đặt lại mật khẩu sẽ hết hạn sau 15 phút
        </p>
    </div>
</div>

</body>
</html>

