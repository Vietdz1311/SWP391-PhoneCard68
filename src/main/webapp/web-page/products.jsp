<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="relative bg-gradient-to-r from-blue-50 to-indigo-100 py-20 overflow-hidden">
  <div class="absolute inset-0 bg-[url('data:image/svg+xml,%3Csvg width=\"60\" height=\"60\" viewBox=\"0 0 60 60\" xmlns=\"http://www.w3.org/2000/svg\"%3E%3Cg fill=\"none\" fill-rule=\"evenodd\"%3E%3Cg fill=\"%239C92AC\" fill-opacity=\"0.05\"%3E%3Ccircle cx=\"30\" cy=\"30\" r=\"2\"/%3E%3C/g%3E%3C/g%3E%3C/svg%3E')] opacity-50"></div>
  <div class="container mx-auto px-4 text-center relative z-10">
    <h1 class="text-5xl md:text-6xl font-bold text-gray-900 mb-4 bg-gradient-to-r from-blue-600 to-indigo-700 bg-clip-text text-transparent">Mua Thẻ Điện Thoại</h1>
    <p class="text-xl text-gray-600 max-w-2xl mx-auto">Chọn thẻ cào từ các nhà mạng uy tín với giá siêu rẻ, chiết khấu cao, giao thẻ tức thì.</p>
  </div>
</section>

<section class="py-20 bg-white">
  <div class="container mx-auto px-4">
    <div class="mb-12">
      <form action="products" method="get" class="bg-white rounded-2xl shadow-lg p-6 flex flex-col lg:flex-row gap-4 items-end">
        <div class="flex-1 flex flex-col sm:flex-row gap-4">
          <div class="flex-1 relative">
            <input type="text" name="search" placeholder="Tìm kiếm mệnh giá..." value="${search}" class="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
            <i class='bx bx-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400'></i>
          </div>
          <select name="filterProvider" class="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option value="">Tất cả nhà mạng</option>
            <c:forEach var="prov" items="${providers}">
              <option value="${prov.providerId}" ${filterProvider == prov.providerId ? 'selected' : ''}>${prov.providerName}</option>
            </c:forEach>
          </select>
          <select name="sortBy" class="px-4 py-3 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option value="">Sắp xếp</option>
            <option value="selling_price ASC" ${sortBy == 'selling_price ASC' ? 'selected' : ''}>Giá tăng dần</option>
            <option value="selling_price DESC" ${sortBy == 'selling_price DESC' ? 'selected' : ''}>Giá giảm dần</option>
            <option value="face_value DESC" ${sortBy == 'face_value DESC' ? 'selected' : ''}>Mệnh giá cao → thấp</option>
          </select>
        </div>
        <button type="submit" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-8 py-3 rounded-xl hover:from-blue-700 hover:to-indigo-700 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
          <i class='bx bx-filter-alt mr-2'></i>Lọc & Tìm
        </button>
      </form>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
      <c:forEach var="prod" items="${products}">
        <div class="group bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-3">
          <div class="relative overflow-hidden bg-gray-50 p-8">
            <img src="${prod.provider.logoUrl != null ? prod.provider.logoUrl : 'https://via.placeholder.com/300x200?text=' + prod.provider.providerName}" 
                 alt="${prod.provider.providerName}" class="mx-auto h-32 object-contain group-hover:scale-110 transition-transform duration-300">
          </div>
          <div class="p-6 text-center">
            <h3 class="text-2xl font-bold text-gray-900 mb-2">${prod.productName}</h3>
            <p class="text-gray-600 mb-2">Nhà mạng: <span class="font-semibold text-blue-600">${prod.provider.providerName}</span></p>
            <p class="text-gray-600 mb-2">Mệnh giá: <span class="font-bold text-green-600"><fmt:formatNumber value="${prod.faceValue}" type="currency" currencySymbol="₫"/></span></p>
            <p class="text-xl font-bold text-red-600 mb-4"><fmt:formatNumber value="${prod.sellingPrice}" type="currency" currencySymbol="₫"/></p>
            <p class="text-sm text-gray-500 mb-4">Tồn kho: <span class="${prod.availableCount > 0 ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold'}">${prod.availableCount > 0 ? prod.availableCount : 'Hết hàng'}</span></p>
            
            <c:choose>
              <c:when test="${prod.availableCount > 0}">
                <a href="products?action=details&id=${prod.productId}" class="block w-full px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-semibold rounded-xl shadow-md hover:shadow-lg hover:from-blue-700 hover:to-indigo-700 transition-all duration-300">
                  Mua ngay <i class='bx bx-cart-add ml-2'></i>
                </a>
              </c:when>
              <c:otherwise>
                <button disabled class="block w-full px-6 py-3 bg-gray-300 text-gray-500 font-semibold rounded-xl cursor-not-allowed">
                  Hết hàng
                </button>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
      <div class="flex justify-center mt-12">
        <nav class="flex space-x-2 bg-white rounded-xl p-2 shadow-sm">
          <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="products?page=${i}&search=${search}&filterProvider=${filterProvider}&sortBy=${sortBy}"
               class="px-5 py-3 rounded-lg font-medium transition duration-200 ${currentPage == i ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md' : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'}">
              ${i}
            </a>
          </c:forEach>
        </nav>
      </div>
    </c:if>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />