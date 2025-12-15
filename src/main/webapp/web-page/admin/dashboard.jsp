<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PhoneCard68</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 text-gray-800">

<div class="flex h-screen overflow-hidden">

    <jsp:include page="sidebar.jsp" />

    <main class="flex-1 flex flex-col overflow-hidden bg-gray-50 ml-64">
        
        <header class="h-16 bg-white shadow-sm flex items-center justify-between px-8 z-0 border-b border-gray-200">
            <h2 class="text-2xl font-bold text-gray-800 flex items-center">
                <i class='bx bxs-dashboard mr-3 text-blue-600'></i>
                Tổng quan hệ thống
            </h2>
            <div class="flex items-center space-x-4 text-gray-500">
                <button class="p-2 hover:bg-gray-100 rounded-full transition"><i class='bx bx-bell text-xl'></i></button>
                <button class="p-2 hover:bg-gray-100 rounded-full transition"><i class='bx bx-cog text-xl'></i></button>
            </div>
        </header>

        <div class="flex-1 overflow-x-hidden overflow-y-auto p-8">
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-2xl shadow-sm p-6 flex items-center border-b-4 border-blue-500 hover:shadow-md transition-shadow">
                    <div class="p-4 bg-blue-50 rounded-full text-blue-600 mr-5">
                        <i class='bx bx-money text-3xl'></i>
                    </div>
                    <div>
                        <div class="text-sm font-medium text-gray-500 uppercase tracking-wider">Doanh thu hôm nay</div>
                        <div class="text-2xl font-extrabold text-gray-800 mt-1">
                            <fmt:formatNumber value="15000000" type="currency" currencySymbol="₫"/>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl shadow-sm p-6 flex items-center border-b-4 border-green-500 hover:shadow-md transition-shadow">
                     <div class="p-4 bg-green-50 rounded-full text-green-600 mr-5">
                        <i class='bx bx-shopping-bag text-3xl'></i>
                    </div>
                    <div>
                        <div class="text-sm font-medium text-gray-500 uppercase tracking-wider">Đơn hàng mới</div>
                        <div class="text-2xl font-extrabold text-gray-800 mt-1">145</div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl shadow-sm p-6 flex items-center border-b-4 border-purple-500 hover:shadow-md transition-shadow">
                    <div class="p-4 bg-purple-50 rounded-full text-purple-600 mr-5">
                        <i class='bx bx-user-plus text-3xl'></i>
                    </div>
                    <div>
                        <div class="text-sm font-medium text-gray-500 uppercase tracking-wider">Khách hàng mới</div>
                        <div class="text-2xl font-extrabold text-gray-800 mt-1">32</div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl shadow-sm p-6 flex items-center border-b-4 border-red-500 hover:shadow-md transition-shadow">
                    <div class="p-4 bg-red-50 rounded-full text-red-600 mr-5">
                        <i class='bx bx-error-alt text-3xl'></i>
                    </div>
                    <div>
                        <div class="text-sm font-medium text-gray-500 uppercase tracking-wider">Sắp hết hàng</div>
                        <div class="text-2xl font-extrabold text-red-600 mt-1">5 loại thẻ</div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-gray-200">
                <div class="px-8 py-5 border-b border-gray-100 flex justify-between items-center bg-gray-50/30">
                    <h3 class="font-bold text-lg text-gray-800 flex items-center">
                        <i class='bx bx-time-five mr-2 text-blue-600'></i> Đơn hàng vừa đặt
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/orders?action=list" class="text-sm font-medium text-blue-600 hover:text-blue-800 hover:underline transition">
                        Xem tất cả đơn hàng <i class='bx bx-right-arrow-alt'></i>
                    </a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-gray-50 text-gray-500 text-xs uppercase font-semibold tracking-wider border-b border-gray-100">
                                <th class="px-6 py-4">Mã đơn</th>
                                <th class="px-6 py-4">Khách hàng</th>
                                <th class="px-6 py-4">Sản phẩm</th>
                                <th class="px-6 py-4 text-right">Tổng tiền</th>
                                <th class="px-6 py-4 text-center">Trạng thái</th>
                                <th class="px-6 py-4 text-right">Thời gian</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100">
                            <tr class="hover:bg-blue-50/30 transition-colors">
                                <td class="px-6 py-4 font-medium text-blue-600">#ORD10234</td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center">
                                        <div class="h-8 w-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xs font-bold mr-3 uppercase">NV</div>
                                        <div>
                                            <div class="font-medium text-gray-900">Nguyen Van A</div>
                                            <div class="text-gray-500 text-sm">nguyenvana@gmail.com</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">Viettel 50k</td>
                                <td class="px-6 py-4 font-bold text-gray-900 text-right">49.000đ</td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 border border-green-200">
                                        <span class="w-1.5 h-1.5 mr-1.5 bg-green-500 rounded-full"></span> Thành công
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-gray-500 text-sm text-right">vừa xong</td>
                            </tr>
                            <tr class="hover:bg-blue-50/30 transition-colors">
                                <td class="px-6 py-4 font-medium text-blue-600">#ORD10233</td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center">
                                        <div class="h-8 w-8 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center text-xs font-bold mr-3 uppercase">TT</div>
                                        <div>
                                            <div class="font-medium text-gray-900">Tran Thi B</div>
                                            <div class="text-gray-500 text-sm">tranthib@outlook.com</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">Vina 100k</td>
                                <td class="px-6 py-4 font-bold text-gray-900 text-right">98.000đ</td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                                         <span class="w-1.5 h-1.5 mr-1.5 bg-yellow-500 rounded-full"></span> Chờ xử lý
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-gray-500 text-sm text-right">5 phút trước</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div> 
    </main>
</div>

</body>
</html>