<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhà cung cấp</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 font-sans text-gray-800">

<div class="flex h-screen overflow-hidden">
    <jsp:include page="sidebar.jsp" />

    <main class="flex-1 ml-64 flex flex-col h-screen overflow-hidden bg-gray-50 p-8">
        
        <div class="flex justify-between items-center mb-8">
            <div>
                <div class="text-gray-500 text-xs font-bold uppercase mb-1">ADMIN > PRODUCT & INVENTORY</div>
                <h1 class="text-2xl font-bold text-gray-800 border-l-4 border-blue-600 pl-3">Nhà cung cấp</h1>
            </div>
            <a href="${pageContext.request.contextPath}/admin/provider-create" 
               class="bg-blue-600 hover:bg-blue-700 text-white font-bold px-6 py-2.5 rounded-lg shadow-md flex items-center transition">
                <i class='bx bx-plus mr-2'></i> Thêm nhà cung cấp
            </a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="bg-green-100 text-green-700 p-3 rounded-lg mb-4 border border-green-200 text-center font-medium">
                ${param.success}
            </div>
        </c:if>

        <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-gray-200">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-gray-600 text-xs uppercase font-bold tracking-wider border-b border-gray-200">
                    <tr>
                        <th class="px-6 py-4">ID</th>
                        <th class="px-6 py-4">Logo / Tên</th>
                        <th class="px-6 py-4">Mã Code</th>
                        <th class="px-6 py-4">Trạng thái</th>
                        <th class="px-6 py-4 text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <c:forEach var="p" items="${providers}">
                        <tr class="hover:bg-blue-50 transition duration-150">
                            <td class="px-6 py-4 text-gray-500">#${p.providerId}</td>
                            <td class="px-6 py-4 font-bold text-gray-800 flex items-center gap-3">
                                <div class="w-10 h-10 rounded bg-gray-100 flex items-center justify-center text-xl text-blue-600">
                                    <i class='bx bxs-business'></i>
                                </div>
                                ${p.providerName}
                            </td>
                            <td class="px-6 py-4 font-mono text-blue-600 bg-blue-50 w-fit rounded px-2">${p.providerCode}</td>
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 rounded text-xs font-bold 
                                    ${p.status == 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                                    ${p.status}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/provider-detail?id=${p.providerId}" 
                                       class="p-2 border border-gray-300 rounded hover:bg-blue-600 hover:text-white transition" title="Sửa">
                                        <i class='bx bx-edit-alt'></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/provider-delete?id=${p.providerId}" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa nhà cung cấp này không?');"
                                       class="p-2 border border-gray-300 rounded hover:bg-red-600 hover:text-white transition" title="Xóa">
                                        <i class='bx bx-trash'></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty providers}">
                <div class="p-8 text-center text-gray-500">Chưa có nhà cung cấp nào.</div>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>