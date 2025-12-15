<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gradient-to-br from-slate-50 to-blue-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-xl mx-auto">
      
      <c:choose>
        <c:when test="${success}">
          <!-- Success -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden text-center">
            <div class="bg-gradient-to-r from-green-400 to-emerald-600 px-8 py-12">
              <div class="w-20 h-20 bg-white rounded-full mx-auto flex items-center justify-center mb-4 shadow-lg">
                <i class='bx bx-check text-green-500 text-5xl'></i>
              </div>
              <h1 class="text-2xl font-bold text-white">${message != null ? message : 'Thanh toán thành công!'}</h1>
            </div>
            <div class="p-8">
              <c:if test="${order != null}">
                <p class="text-gray-600 mb-6">Đơn hàng #${order.orderId} đã được xác nhận.</p>
                <a href="${pageContext.request.contextPath}/purchase-result?orderId=${order.orderId}" 
                   class="inline-block bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold px-8 py-4 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
                  Xem thông tin thẻ
                </a>
              </c:if>
            </div>
          </div>
        </c:when>
        
        <c:otherwise>
          <!-- Failed -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden text-center">
            <div class="bg-gradient-to-r from-red-400 to-pink-600 px-8 py-12">
              <div class="w-20 h-20 bg-white rounded-full mx-auto flex items-center justify-center mb-4 shadow-lg">
                <i class='bx bx-x text-red-500 text-5xl'></i>
              </div>
              <h1 class="text-2xl font-bold text-white">Thanh toán thất bại</h1>
            </div>
            <div class="p-8">
              <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-6 text-left">
                  <p class="text-red-700"><i class='bx bx-error-circle mr-2'></i>${error}</p>
                </div>
              </c:if>
              <c:if test="${not empty responseCode}">
                <p class="text-gray-500 text-sm mb-6">Mã lỗi: ${responseCode}</p>
              </c:if>
              <a href="${pageContext.request.contextPath}/products" 
                 class="inline-block bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold px-8 py-4 rounded-xl hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
                <i class='bx bx-arrow-back mr-2'></i> Quay lại cửa hàng
              </a>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</section>

<jsp:include page="./components/footer.jsp" />

