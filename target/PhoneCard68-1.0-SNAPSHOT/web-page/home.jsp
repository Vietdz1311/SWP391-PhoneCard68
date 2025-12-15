<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<jsp:include page="./components/header.jsp" />

<section class="relative bg-cover bg-center bg-no-repeat py-40 overflow-hidden" 
         style="background-image: url('https://img.freepik.com/free-psd/modern-abstract-blue-gradient-background_84443-3747.jpg');">
  <div class="absolute inset-0 bg-gradient-to-r from-blue-900/80 to-indigo-900/80"></div>
  <div class="container mx-auto px-4 text-center text-white relative z-10">
    <h1 class="text-5xl md:text-7xl font-extrabold mb-6 animate-fade-in drop-shadow-2xl">
      Mua Thẻ Điện Thoại <span class="text-yellow-300">Giá Rẻ Nhất</span>
    </h1>
    <p class="text-xl md:text-3xl mb-12 font-medium text-gray-100">Chiết khấu cao • Giao thẻ tức thì • An toàn 100%</p>
    <div class="flex flex-col sm:flex-row gap-8 justify-center">
      <a href="products" class="inline-block bg-yellow-400 text-blue-900 px-12 py-5 rounded-2xl text-2xl font-bold hover:bg-yellow-300 transition transform hover:scale-110 shadow-2xl">
        Mua ngay hôm nay
      </a>
      <a href="products" class="inline-block border-4 border-white px-12 py-5 rounded-2xl text-2xl font-bold hover:bg-white hover:text-indigo-700 transition transform hover:scale-110">
        Xem tất cả nhà mạng
      </a>
    </div>
  </div>
  <div class="absolute bottom-0 left-0 w-full overflow-hidden">
    <svg viewBox="0 0 1440 120" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M0 120L1440 0V120H0Z" fill="#f9fafb"/>
    </svg>
  </div>
</section>

<c:if test="${not empty featuredProducts}">
<section class="py-24 bg-gray-50">
  <div class="container mx-auto px-4">
    <h2 class="text-5xl font-bold text-center mb-16 bg-gradient-to-r from-blue-600 to-indigo-700 bg-clip-text text-transparent">
      Thẻ Nổi Bật - Chiết Khấu Cao Nhất
    </h2>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
      <c:forEach var="prod" items="${featuredProducts}">
        <div class="group bg-white rounded-3xl shadow-xl overflow-hidden hover:shadow-3xl transition duration-500 transform hover:-translate-y-6">
          <div class="relative bg-gradient-to-b from-blue-50 to-gray-100 p-12">
            <img src="${prod.provider.logoUrl != null ? prod.provider.logoUrl : 'https://via.placeholder.com/300x200?text=' + prod.provider.providerName}"
                 alt="${prod.provider.providerName}" class="mx-auto h-40 object-contain group-hover:scale-125 transition duration-500">
            <span class="absolute top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-full text-sm font-bold">Hot</span>
          </div>
          <div class="p-8 text-center">
            <h3 class="text-2xl font-bold mb-3">${prod.productName}</h3>
            <p class="text-gray-600 text-lg mb-4">${prod.provider.providerName}</p>
            <div class="mb-6">
              <p class="text-3xl font-extrabold text-green-600"><fmt:formatNumber value="${prod.faceValue}" type="currency" currencySymbol="₫"/></p>
              <div class="flex justify-center items-center gap-2">
                  <p class="text-xl line-through text-gray-500"><fmt:formatNumber value="${prod.faceValue}" type="currency" currencySymbol="₫"/></p>
                  <span class="text-red-600 font-bold bg-red-100 px-2 rounded">
                    -<fmt:formatNumber value="${(prod.faceValue - prod.sellingPrice)/prod.faceValue * 100}" maxFractionDigits="0"/>%
                  </span>
              </div>
            </div>
            <p class="text-3xl font-bold text-indigo-600 mb-6"><fmt:formatNumber value="${prod.sellingPrice}" type="currency" currencySymbol="₫"/></p>
            <a href="products?action=details&id=${prod.productId}" 
               class="block w-full bg-gradient-to-r from-blue-600 to-indigo-700 text-white py-4 rounded-2xl font-bold hover:from-indigo-700 hover:to-blue-800 transition shadow-lg">
              Mua Ngay
            </a>
          </div>
        </div>
      </c:forEach>
    </div>
    <div class="text-center mt-16">
      <a href="products" class="text-indigo-600 font-bold text-2xl hover:underline">Xem tất cả thẻ cào →</a>
    </div>
  </div>
</section>
</c:if>

<c:if test="${not empty latestBlogs}">
<section class="py-24 bg-white">
  <div class="container mx-auto px-4">
    <h2 class="text-5xl font-bold text-center mb-16 bg-gradient-to-r from-blue-600 to-indigo-700 bg-clip-text text-transparent">
      Tin Tức & Khuyến Mãi Mới Nhất
    </h2>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-12">
      <c:forEach var="post" items="${latestBlogs}">
        <div class="bg-white rounded-3xl shadow-2xl overflow-hidden hover:shadow-3xl transition duration-500 transform hover:-translate-y-4">
          <img src="${post.thumbnailUrl != null ? post.thumbnailUrl : 'https://gigago.com/wp-content/uploads/2024/08/Vietnam-sim-cards.jpg'}"
               alt="${post.title}" class="w-full h-72 object-cover">
          <div class="p-8">
            <h3 class="text-2xl font-bold mb-4">
              <a href="blog?action=details&slug=${post.slug}" class="text-gray-900 hover:text-indigo-600 transition">${post.title}</a>
            </h3>
            <p class="text-gray-600 mb-6 line-clamp-3">${post.content}</p>
            <div class="flex justify-between text-sm text-gray-500">
              <span class="font-medium">${post.author.username}</span>
              <span>${post.publishedAt}</span>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
    <div class="text-center mt-16">
      <a href="blog" class="text-indigo-600 font-bold text-2xl hover:underline">Xem tất cả tin tức →</a>
    </div>
  </div>
</section>
</c:if>

<section class="py-20 bg-gray-50 border-t border-gray-200">
  <div class="container mx-auto px-4 text-center">
    <h2 class="text-3xl font-bold mb-12 text-gray-800">Đối tác chiến lược</h2>
    <div class="flex flex-wrap justify-center gap-8 items-center opacity-70 grayscale hover:grayscale-0 transition duration-500">
      <c:forEach var="prov" items="${providers}">
        <div class="px-8 py-4 bg-white rounded-xl border border-gray-200 font-bold text-2xl text-gray-600 hover:text-blue-600 hover:border-blue-300 hover:bg-blue-50 hover:shadow-lg transition transform hover:scale-105 cursor-default select-none">
            ${prov.providerName}
        </div>
      </c:forEach>
    </div>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />