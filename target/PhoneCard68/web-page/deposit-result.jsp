<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gradient-to-br from-slate-50 to-emerald-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-xl mx-auto">
      
      <c:choose>
        <c:when test="${success}">
          <!-- Success -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden text-center">
            <div class="bg-gradient-to-r from-green-400 to-emerald-600 px-8 py-12">
              <div class="w-24 h-24 bg-white rounded-full mx-auto flex items-center justify-center mb-6 shadow-lg">
                <i class='bx bx-check text-green-500 text-6xl'></i>
              </div>
              <h1 class="text-3xl font-bold text-white mb-2">${message != null ? message : 'Nạp tiền thành công!'}</h1>
              <c:if test="${amount != null}">
                <p class="text-green-100 text-2xl font-bold">+<fmt:formatNumber value="${amount}" type="number"/>₫</p>
              </c:if>
            </div>
            
            <div class="p-8">
              <!-- New Balance -->
              <div class="bg-gray-50 rounded-xl p-6 mb-8">
                <p class="text-gray-600 text-sm mb-2">Số dư ví hiện tại</p>
                <p class="text-4xl font-bold text-green-600">
                  <fmt:formatNumber value="${sessionScope.user.walletBalance}" type="number"/>₫
                </p>
              </div>
              
              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row gap-4">
                <a href="${pageContext.request.contextPath}/products" 
                   class="flex-1 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl text-center hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
                  <i class='bx bx-cart mr-2'></i> Mua thẻ ngay
                </a>
                <a href="${pageContext.request.contextPath}/profile" 
                   class="flex-1 bg-gray-100 text-gray-700 font-bold py-4 rounded-xl text-center hover:bg-gray-200 transition">
                  <i class='bx bx-user mr-2'></i> Trang cá nhân
                </a>
              </div>
            </div>
          </div>
        </c:when>
        
        <c:otherwise>
          <!-- Failed -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden text-center">
            <div class="bg-gradient-to-r from-red-400 to-pink-600 px-8 py-12">
              <div class="w-24 h-24 bg-white rounded-full mx-auto flex items-center justify-center mb-6 shadow-lg">
                <i class='bx bx-x text-red-500 text-6xl'></i>
              </div>
              <h1 class="text-3xl font-bold text-white mb-2">Nạp tiền thất bại</h1>
            </div>
            
            <div class="p-8">
              <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 text-left">
                  <p class="text-red-700"><i class='bx bx-error-circle mr-2'></i>${error}</p>
                </div>
              </c:if>
              
              <p class="text-gray-600 mb-8">Giao dịch của bạn không thể hoàn thành. Vui lòng thử lại.</p>
              
              <div class="flex flex-col sm:flex-row gap-4">
                <a href="${pageContext.request.contextPath}/deposit" 
                   class="flex-1 bg-gradient-to-r from-green-500 to-emerald-600 text-white font-bold py-4 rounded-xl text-center hover:from-green-600 hover:to-emerald-700 transition shadow-lg">
                  <i class='bx bx-refresh mr-2'></i> Thử lại
                </a>
                <a href="${pageContext.request.contextPath}/profile" 
                   class="flex-1 bg-gray-100 text-gray-700 font-bold py-4 rounded-xl text-center hover:bg-gray-200 transition">
                  <i class='bx bx-arrow-back mr-2'></i> Quay lại
                </a>
              </div>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />

