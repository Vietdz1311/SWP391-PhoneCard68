<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-20 bg-gray-50">
  <div class="container mx-auto px-4">
    <div class="max-w-5xl mx-auto">
      <div class="grid md:grid-cols-2 gap-12 bg-white rounded-2xl shadow-2xl overflow-hidden">
        <div class="relative bg-gradient-to-br from-blue-50 to-indigo-100 p-12 flex items-center justify-center">
          <img src="${product.provider.logoUrl != null ? product.provider.logoUrl : 'https://via.placeholder.com/400x300?text=' + product.provider.providerName}"
               alt="${product.provider.providerName}"
               class="max-h-80 object-contain drop-shadow-2xl">
          <div class="absolute top-6 left-6 bg-white px-4 py-2 rounded-full shadow-md">
            <span class="font-bold text-blue-600">${product.provider.providerName}</span>
          </div>
        </div>

        <div class="p-10 md:p-16 flex flex-col justify-center">
          <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">${product.productName}</h1>

          <div class="space-y-4 mb-8 text-lg">
            <div class="flex items-center">
              <span class="text-gray-600 font-medium">Mệnh giá:</span>
              <span class="ml-4 text-3xl font-bold text-green-600"><fmt:formatNumber value="${product.faceValue}" type="currency" currencySymbol="₫"/></span>
            </div>
            <div class="flex items-center">
              <span class="text-gray-600 font-medium">Giá bán:</span>
              <span class="ml-4 text-4xl font-bold text-red-600"><fmt:formatNumber value="${product.sellingPrice}" type="currency" currencySymbol="₫"/></span>
            </div>
            <div class="flex items-center">
              <span class="text-gray-600 font-medium">Tồn kho:</span>
              <span class="ml-4 text-2xl font-bold ${product.availableCount > 0 ? 'text-green-600' : 'text-red-600'}">
                ${product.availableCount > 0 ? product.availableCount : 'Hết hàng'}
              </span>
            </div>
          </div>

          <c:if test="${product.description != null && !product.description.isEmpty()}">
            <div class="mb-8">
              <h3 class="text-2xl font-bold mb-4 text-gray-800">Mô tả</h3>
              <p class="text-gray-700 leading-relaxed">${product.description}</p>
            </div>
          </c:if>

          <div class="mt-10">
            <c:choose>
              <c:when test="${sessionScope.user != null}">
                <c:choose>
                  <c:when test="${product.availableCount > 0}">
                    <a href="purchase?productId=${product.productId}" 
                       class="block text-center w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold text-xl py-5 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-xl transform hover:scale-105">
                      <i class='bx bx-cart-add mr-3'></i> Mua ngay
                    </a>
                    <p class="text-center text-sm text-gray-500 mt-4">Giao thẻ tức thì qua email/số điện thoại</p>
                  </c:when>
                  <c:otherwise>
                    <button disabled class="block w-full text-center bg-gray-300 text-gray-600 font-bold text-xl py-5 rounded-xl cursor-not-allowed">
                      Hết hàng
                    </button>
                  </c:otherwise>
                </c:choose>
              </c:when>
              <c:otherwise>
                <a href="${pageContext.request.contextPath}/auth" 
                   class="block text-center w-full bg-gradient-to-r from-orange-500 to-red-600 text-white font-bold text-xl py-5 rounded-xl hover:from-orange-600 hover:to-red-700 transition shadow-xl transform hover:scale-105">
                  <i class='bx bx-log-in mr-3'></i> Đăng nhập để mua
                </a>
              </c:otherwise>
            </c:choose>
          </div>

          <div class="mt-8 text-center">
            <a href="products" class="inline-flex items-center text-blue-600 font-bold hover:text-blue-800 transition">
              <i class='bx bx-chevron-left mr-2'></i> Quay lại danh sách thẻ
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />