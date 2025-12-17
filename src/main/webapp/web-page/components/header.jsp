<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PhoneCard68</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: { inter: ['Inter', 'ui-sans-serif', 'system-ui'] },
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
  <body class="font-inter bg-gray-50 min-h-screen flex flex-col">
    <header class="bg-white shadow-md sticky top-0 z-50">
      <div class="max-w-6xl mx-auto px-4 py-4 flex justify-between items-center">
        <a href="${pageContext.request.contextPath}/home" class="text-3xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">PhoneCard</a>
        <nav class="flex space-x-6 items-center text-sm md:text-base">
          <a href="${pageContext.request.contextPath}/home" class="text-gray-700 hover:text-blue-600 font-medium transition">Trang chủ</a>
          <a href="${pageContext.request.contextPath}/products" class="text-gray-700 hover:text-blue-600 font-medium transition">Mua thẻ</a>
          <a href="${pageContext.request.contextPath}/blog" class="text-gray-700 hover:text-blue-600 font-medium transition">Tin tức</a>
          <c:choose>
            <c:when test="${sessionScope.user != null}">
              <a href="${pageContext.request.contextPath}/history" class="text-gray-700 hover:text-blue-600 font-medium transition">Lịch sử</a>
              <a href="${pageContext.request.contextPath}/deposit" class="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-4 py-2 rounded-xl hover:from-green-600 hover:to-emerald-700 transition font-medium shadow-sm flex items-center gap-2">
                <i class='bx bx-wallet'></i>
                <fmt:formatNumber value="${sessionScope.user.walletBalance}" groupingUsed="true"/>₫
              </a>
              <a href="${pageContext.request.contextPath}/profile" class="text-gray-700 hover:text-blue-600 font-medium transition flex items-center gap-2">
                <i class='bx bx-user-circle text-xl'></i>
                ${sessionScope.user.username}
              </a>
              <c:if test="${sessionScope.user.role == 'Admin'}">
                <a href="${pageContext.request.contextPath}/web-page/admin/dashboard.jsp" class="bg-gradient-to-r from-red-500 to-rose-600 text-white px-4 py-2 rounded-xl hover:from-red-600 hover:to-rose-700 transition font-medium shadow-sm flex items-center gap-2">
                  <i class='bx bx-shield-quarter'></i> Admin
                </a>
              </c:if>
              <c:if test="${sessionScope.user.role == 'Staff'}">
                <a href="${pageContext.request.contextPath}/staff/blogs" class="bg-gradient-to-r from-purple-500 to-indigo-600 text-white px-4 py-2 rounded-xl hover:from-purple-600 hover:to-indigo-700 transition font-medium shadow-sm flex items-center gap-2">
                  <i class='bx bx-cog'></i> Staff Panel
                </a>
              </c:if>
              <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-red-600 hover:text-red-700 font-medium transition">Đăng xuất</a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/auth" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-2 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition font-medium shadow-md">Đăng nhập</a>
            </c:otherwise>
          </c:choose>
        </nav>
      </div>
    </header>
    <main class="flex-1 flex flex-col">