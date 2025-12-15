<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-20 bg-gray-50">
  <div class="container mx-auto px-4">
    <h1 class="text-5xl font-bold text-center mb-12 bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
      Tin tức & Khuyến mãi
    </h1>

    <div class="max-w-2xl mx-auto mb-12">
      <form action="blog" method="get" class="flex gap-4">
        <input type="text" name="search" value="${search}" placeholder="Tìm kiếm tin tức..."
               class="flex-1 px-6 py-4 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500">
        <button type="submit"
                class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white px-8 py-4 rounded-xl font-bold hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
          <i class='bx bx-search mr-2'></i> Tìm kiếm
        </button>
      </form>
    </div>

    <c:if test="${empty posts}">
      <p class="text-center text-xl text-gray-600">Không tìm thấy bài viết nào.</p>
    </c:if>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
      <c:forEach var="post" items="${posts}">
        <!-- Toàn bộ card là link (dùng onclick để chuyển trang mượt, cursor pointer) -->
        <div onclick="window.location.href='blog?action=details&slug=${post.slug}'"
             class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-4 cursor-pointer group">
          <div class="relative overflow-hidden">
            <img src="${post.thumbnailUrl != null ? post.thumbnailUrl : 'https://via.placeholder.com/600x400?text=Tin+Tuc'}"
                 alt="${post.title}" class="w-full h-64 object-cover group-hover:scale-110 transition-transform duration-500">
            <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
          </div>
          <div class="p-6">
            <h3 class="text-2xl font-bold mb-3 text-gray-900 group-hover:text-blue-600 transition">
              ${post.title}
            </h3>
            <p class="text-gray-600 mb-4 line-clamp-3">${post.content.replaceAll('<[^>]*>', '')}</p>
            <div class="flex justify-between text-sm text-gray-500">
              <span><i class='bx bx-user mr-1'></i> ${post.author.username}</span>
              <span><i class='bx bx-calendar mr-1'></i> 
                <fmt:formatDate value="${post.publishedAt}" pattern="dd/MM/yyyy"/>
              </span>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
      <div class="flex justify-center mt-12">
        <nav class="flex space-x-2 bg-white rounded-xl p-2 shadow-lg">
          <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="blog?page=${i}&search=${search}"
               class="px-5 py-3 rounded-lg font-medium transition ${currentPage == i ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md' : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'}">
              ${i}
            </a>
          </c:forEach>
        </nav>
      </div>
    </c:if>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />