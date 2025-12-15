<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
    
    <header class="bg-white shadow-md sticky top-0 z-50">
        <div class="container mx-auto px-4 py-4 flex justify-between items-center">
            <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-2">
                <i class='bx bxs-credit-card-alt text-4xl text-blue-600'></i>
                <span class="text-3xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">PhoneCard</span>
            </a>

            <nav class="hidden md:flex space-x-8 items-center">
                <a href="${pageContext.request.contextPath}/home" class="text-gray-700 hover:text-blue-600 font-medium transition flex items-center">
                    <i class='bx bx-home-alt-2 mr-1'></i> Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/products" class="text-gray-700 hover:text-blue-600 font-medium transition flex items-center">
                    <i class='bx bx-store-alt mr-1'></i> Mua thẻ
                </a>
                <a href="${pageContext.request.contextPath}/blog" class="text-gray-700 hover:text-blue-600 font-medium transition flex items-center">
                    <i class='bx bx-news mr-1'></i> Tin tức
                </a>

                <c:choose>
                    <%-- TRƯỜNG HỢP: ĐÃ ĐĂNG NHẬP --%>
                    <c:when test="${sessionScope.user != null}">
                        <a href="${pageContext.request.contextPath}/history" class="text-gray-700 hover:text-blue-600 font-medium transition flex items-center">
                            <i class='bx bx-history mr-1'></i> Lịch sử
                        </a>

                        <%-- LOGIC HIỂN THỊ NÚT QUẢN TRỊ (ADMIN/STAFF) --%>
                        <c:if test="${sessionScope.user.role == 'Admin' || sessionScope.user.role == 'Staff'}">
                            <a href="${pageContext.request.contextPath}/web-page/admin/dashboard.jsp" 
                               class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded-full font-bold transition flex items-center shadow-sm text-sm">
                                <i class='bx bxs-dashboard mr-1'></i> Quản trị
                            </a>
                        </c:if>

                        <%-- THÔNG TIN TÀI KHOẢN --%>
                        <a href="${pageContext.request.contextPath}/profile" class="text-gray-700 hover:text-blue-600 font-medium transition text-right group">
                            <div class="font-bold group-hover:text-blue-600 transition">${sessionScope.user.username}</div>
                            <div class="text-xs text-green-600 font-bold">
                                Số dư: <fmt:formatNumber value="${sessionScope.user.walletBalance}" type="number"/>₫
                            </div>
                        </a>

                        <%-- NÚT ĐĂNG XUẤT --%>
                        <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-gray-400 hover:text-red-600 text-2xl transition" title="Đăng xuất">
                            <i class='bx bx-log-out'></i>
                        </a>
                    </c:when>

                    <%-- TRƯỜNG HỢP: CHƯA ĐĂNG NHẬP --%>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth" class="text-gray-600 hover:text-blue-600 font-medium">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/auth?action=register" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-6 py-2 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition font-medium shadow-md flex items-center">
                            <i class='bx bx-user-plus mr-1'></i> Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>