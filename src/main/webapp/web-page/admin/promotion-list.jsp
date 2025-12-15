<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khuyến mãi</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 font-sans text-gray-800">

<div class="flex h-screen overflow-hidden">
    <jsp:include page="sidebar.jsp" />

    <main class="flex-1 ml-64 flex flex-col h-screen overflow-hidden bg-gray-50 p-8">
        
        <div class="flex justify-between items-center mb-8">
            <div>
                <div class="text-gray-500 text-xs font-bold uppercase mb-1">ADMIN > PROMOTION MANAGEMENT</div>
                <h1 class="text-2xl font-bold text-gray-800 border-l-4 border-blue-600 pl-3">Danh sách khuyến mãi</h1>
            </div>
            <a href="${pageContext.request.contextPath}/admin/promotion-create" 
               class="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-2.5 rounded-lg shadow-md flex items-center transition">
                <i class='bx bx-plus mr-2'></i> Tạo khuyến mãi mới
            </a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="bg-green-100 text-green-700 p-3 rounded-lg mb-4 text-center border border-green-200 font-medium">
                ${param.success}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/promotions" method="get" 
              class="bg-white p-4 rounded-xl shadow-sm mb-6 flex flex-wrap gap-4 border border-gray-100 items-center">
            
            <div class="flex-1 relative min-w-[200px]">
                <i class='bx bx-search absolute left-3 top-3 text-gray-400 text-xl'></i>
                <input type="text" name="keyword" value="${paramKeyword}" placeholder="Tìm kiếm theo mã Code..." 
                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase">
            </div>

            <select name="status" class="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white text-gray-700">
                <option value="All" ${paramStatus == 'All' ? 'selected' : ''}>Trạng thái: Tất cả</option>
                <option value="Active" ${paramStatus == 'Active' ? 'selected' : ''}>Active</option>
                <option value="Ended" ${paramStatus == 'Ended' ? 'selected' : ''}>Ended</option>
            </select>

            <button type="submit" class="bg-gray-800 hover:bg-black text-white px-5 py-2 rounded-lg font-medium transition">
                Tìm kiếm
            </button>
            
            <a href="${pageContext.request.contextPath}/admin/promotions" class="text-gray-500 hover:text-red-500 font-medium px-2">
                <i class='bx bx-refresh text-xl translate-y-1'></i>
            </a>
        </form>

        <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-200 flex-1 overflow-y-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-gray-600 text-xs uppercase font-bold tracking-wider border-b border-gray-200 sticky top-0 z-10">
                    <tr>
                        <th class="px-6 py-4">Mã Code</th>
                        <th class="px-6 py-4">Loại giảm giá</th>
                        <th class="px-6 py-4">Giá trị</th>
                        <th class="px-6 py-4">Thời gian</th>
                        <th class="px-6 py-4">Giới hạn</th>
                        <th class="px-6 py-4">Trạng thái</th>
                        <th class="px-6 py-4 text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:forEach var="p" items="${promotions}">
                        <tr class="hover:bg-blue-50 transition duration-150">
                            <td class="px-6 py-4 font-bold text-blue-600">${p.code}</td>
                            <td class="px-6 py-4 text-sm">${p.discountType}</td>
                            <td class="px-6 py-4 font-bold text-green-600">
                                <c:if test="${p.discountType == 'PERCENTAGE'}"><fmt:formatNumber value="${p.discountValue}" type="number"/>%</c:if>
                                <c:if test="${p.discountType == 'FIXED_AMOUNT'}"><fmt:formatNumber value="${p.discountValue}" type="number"/>đ</c:if>
                            </td>
                            <td class="px-6 py-4 text-xs text-gray-500">
                                ${p.startDate} <br> -> ${p.endDate}
                            </td>
                            <td class="px-6 py-4 text-sm">${p.usageLimit} total</td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 rounded text-xs font-bold flex items-center w-fit
                                    ${p.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-gray-200 text-gray-600'}">
                                    <span class="w-2 h-2 rounded-full mr-2 ${p.status == 'Active' ? 'bg-green-500' : 'bg-gray-500'}"></span>
                                    ${p.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <c:choose>
                                    <c:when test="${p.status == 'Ended'}">
                                        <span class="text-gray-300 font-bold select-none cursor-not-allowed text-xl">[-]</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/promotion-detail?id=${p.promotionId}" 
                                           class="inline-block border border-gray-300 text-gray-600 rounded-lg px-4 py-1 hover:bg-blue-600 hover:text-white transition text-sm font-medium">
                                            Edit
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty promotions}">
                <div class="text-center py-12 text-gray-400">
                    <i class='bx bx-search-alt text-6xl mb-3 text-gray-200'></i>
                    <p>Không tìm thấy khuyến mãi nào.</p>
                </div>
            </c:if>
        </div>

        <div class="mt-6 flex justify-between items-center">
            <div class="text-sm text-gray-500">
                Total: <span class="font-bold text-gray-800">${totalCount}</span> promotions
            </div>
            
            <nav class="inline-flex rounded-md shadow-sm">
                <a href="#" class="px-3 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">Prev</a>
                <a href="#" class="px-3 py-2 border-t border-b border-gray-300 bg-blue-50 text-sm font-medium text-blue-600">1</a>
                <a href="#" class="px-3 py-2 border-t border-b border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">2</a>
                <a href="#" class="px-3 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">Next</a>
            </nav>
        </div>

    </main>
</div>
</body>
</html>