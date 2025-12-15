<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>PhoneCard68</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
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
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen flex items-center justify-center">
<div class="bg-white rounded-2xl shadow-2xl p-10 w-full max-w-md">
    <h2 class="text-3xl font-bold text-center text-gray-900 mb-8">Đăng nhập</h2>
    <c:if test="${not empty param.success}">
                    <div class="text-green-600 text-center mb-4">${param.success}</div>
                </c:if>
        <c:if test="${not empty param.error}">
            <div class="text-red-600 text-center mb-4">${param.error}</div>
        </c:if>
    <form action="auth" method="post">
    <input type="hidden" name="action" value="login">
    
    <div class="mb-6">
        <label class="block text-gray-700 font-medium mb-2">Tên đăng nhập hoặc Email</label>
        <input type="text" name="username" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
    </div>
    <div class="mb-6">
        <label class="block text-gray-700 font-medium mb-2">Mật khẩu</label>
        <input type="password" name="password" required class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
    </div>
    <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-3 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition duration-300 shadow-lg">
        Đăng nhập
    </button>
</form>
    <p class="text-center mt-6 text-gray-600">Chưa có tài khoản? <a href="auth?action=register" class="text-blue-600 font-medium hover:underline">Đăng ký</a></p>
</div>
</body>
</html>