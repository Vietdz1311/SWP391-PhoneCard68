<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-20 bg-gray-50">
  <div class="container mx-auto px-4">
    <div class="max-w-5xl mx-auto bg-white rounded-2xl shadow-2xl overflow-hidden">
      <img src="${post.thumbnailUrl != null ? post.thumbnailUrl : 'https://via.placeholder.com/1200x600?text=Tin+Tuc'}"
           alt="${post.title}" class="w-full h-96 object-cover">

      <div class="p-10 md:p-16">
        <h1 class="text-5xl font-bold text-gray-900 mb-6">${post.title}</h1>

        <div class="flex flex-wrap items-center text-gray-600 mb-10 gap-6">
          <span class="flex items-center"><i class='bx bx-user text-xl mr-2'></i> ${post.author.username}</span>
          <span class="flex items-center"><i class='bx bx-calendar text-xl mr-2'></i>${post.publishedAt}</span>
          <span class="flex items-center"><i class='bx bx-time text-xl mr-2'></i> ${post.publishedAt}</span>
        </div>

        <div class="prose prose-lg max-w-none text-gray-700 leading-relaxed">
          ${post.content} <!-- Content có thể chứa HTML (từ editor) -->
        </div>

        <div class="mt-12 pt-8 border-t border-gray-200">
          <a href="blog" class="inline-flex items-center text-blue-600 font-bold hover:text-blue-800 transition">
            <i class='bx bx-chevron-left mr-2'></i> Quay lại danh sách tin tức
          </a>
        </div>
      </div>
    </div>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />