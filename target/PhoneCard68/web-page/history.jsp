<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gray-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-5xl mx-auto">
      
      <!-- Page Title -->
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">Lịch sử giao dịch</h1>
        <p class="text-gray-600">Theo dõi các đơn hàng và giao dịch của bạn</p>
      </div>

      <!-- Tabs -->
      <div class="bg-white rounded-t-2xl shadow-sm border-b border-gray-200">
        <div class="flex">
          <a href="?tab=orders" 
             class="flex-1 px-6 py-4 text-center font-bold transition ${currentTab == 'orders' ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50' : 'text-gray-600 hover:text-blue-600 hover:bg-gray-50'}">
            <i class='bx bx-shopping-bag mr-2'></i> Đơn hàng
          </a>
          <a href="?tab=transactions" 
             class="flex-1 px-6 py-4 text-center font-bold transition ${currentTab == 'transactions' ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50' : 'text-gray-600 hover:text-blue-600 hover:bg-gray-50'}">
            <i class='bx bx-transfer mr-2'></i> Giao dịch
          </a>
        </div>
      </div>

      <!-- Content -->
      <div class="bg-white rounded-b-2xl shadow-xl overflow-hidden">
        
        <c:choose>
          <c:when test="${currentTab == 'transactions'}">
            <!-- Transactions Tab -->
            <c:choose>
              <c:when test="${not empty transactions}">
                <div class="divide-y divide-gray-100">
                  <c:forEach var="trans" items="${transactions}">
                    <div class="p-6 hover:bg-gray-50 transition">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center gap-4">
                          <div class="w-12 h-12 rounded-xl flex items-center justify-center ${trans.type == 'DEPOSIT' ? 'bg-green-100' : 'bg-blue-100'}">
                            <i class='bx ${trans.type == "DEPOSIT" ? "bx-plus text-green-600" : "bx-cart text-blue-600"} text-2xl'></i>
                          </div>
                          <div>
                            <p class="font-bold text-gray-900">${trans.description}</p>
                            <p class="text-sm text-gray-500">${trans.createdAt}</p>
                          </div>
                        </div>
                        <div class="text-right">
                          <p class="text-xl font-bold ${trans.type == 'DEPOSIT' ? 'text-green-600' : 'text-red-600'}">
                            ${trans.type == 'DEPOSIT' ? '+' : '-'}<fmt:formatNumber value="${trans.amount}" type="number"/>₫
                          </p>
                          <span class="inline-block px-3 py-1 rounded-full text-xs font-bold
                            ${trans.status == 'Success' ? 'bg-green-100 text-green-700' : 
                              trans.status == 'Pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700'}">
                            ${trans.status == 'Success' ? 'Thành công' : trans.status == 'Pending' ? 'Đang xử lý' : 'Thất bại'}
                          </span>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="p-16 text-center">
                  <div class="w-20 h-20 bg-gray-100 rounded-full mx-auto flex items-center justify-center mb-4">
                    <i class='bx bx-transfer text-gray-400 text-4xl'></i>
                  </div>
                  <p class="text-gray-500 text-lg">Chưa có giao dịch nào</p>
                  <a href="${pageContext.request.contextPath}/deposit" 
                     class="inline-block mt-4 text-blue-600 font-bold hover:underline">
                    Nạp tiền ngay →
                  </a>
                </div>
              </c:otherwise>
            </c:choose>
          </c:when>
          
          <c:otherwise>
            <!-- Orders Tab -->
            <c:choose>
              <c:when test="${not empty orders}">
                <div class="divide-y divide-gray-100">
                  <c:forEach var="order" items="${orders}">
                    <div class="p-6 hover:bg-gray-50 transition">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center gap-4">
                          <img src="${order.cardProduct.provider.logoUrl != null ? order.cardProduct.provider.logoUrl : 'https://via.placeholder.com/60?text=' += order.cardProduct.provider.providerName}"
                               alt="${order.cardProduct.provider.providerName}"
                               class="w-14 h-14 object-contain rounded-xl bg-gray-50 p-1">
                          <div>
                            <p class="font-bold text-gray-900">${order.cardProduct.productName}</p>
                            <p class="text-sm text-blue-600">${order.cardProduct.provider.providerName}</p>
                            <p class="text-xs text-gray-400">Đơn #${order.orderId} - ${order.orderDate}</p>
                          </div>
                        </div>
                        <div class="text-right">
                          <p class="text-xl font-bold text-gray-900">
                            <fmt:formatNumber value="${order.finalAmount}" type="number"/>₫
                          </p>
                          <span class="inline-block px-3 py-1 rounded-full text-xs font-bold
                            ${order.status == 'Completed' ? 'bg-green-100 text-green-700' : 
                              order.status == 'Pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700'}">
                            ${order.status == 'Completed' ? 'Hoàn thành' : order.status == 'Pending' ? 'Đang xử lý' : 'Đã hủy'}
                          </span>
                        </div>
                      </div>
                      
                      <!-- Show card details for completed orders -->
                      <c:if test="${order.status == 'Completed'}">
                        <div class="mt-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-4 border border-blue-100">
                          <div class="flex flex-wrap items-center gap-6 text-sm">
                            <div>
                              <span class="text-gray-500">Seri:</span>
                              <span class="font-mono font-bold text-gray-900 ml-1">${order.cardInventory.serialNumber}</span>
                            </div>
                            <div>
                              <span class="text-gray-500">Mã thẻ:</span>
                              <span class="font-mono font-bold text-blue-600 ml-1">${order.cardInventory.cardCode}</span>
                              <button onclick="copyToClipboard('${order.cardInventory.cardCode}')" 
                                      class="ml-2 text-blue-500 hover:text-blue-700" title="Sao chép">
                                <i class='bx bx-copy'></i>
                              </button>
                            </div>
                            <div>
                              <span class="text-gray-500">HSD:</span>
                              <span class="font-bold text-gray-900 ml-1">${order.cardInventory.expiryDate}</span>
                            </div>
                          </div>
                        </div>
                      </c:if>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div class="p-16 text-center">
                  <div class="w-20 h-20 bg-gray-100 rounded-full mx-auto flex items-center justify-center mb-4">
                    <i class='bx bx-shopping-bag text-gray-400 text-4xl'></i>
                  </div>
                  <p class="text-gray-500 text-lg">Chưa có đơn hàng nào</p>
                  <a href="${pageContext.request.contextPath}/products" 
                     class="inline-block mt-4 text-blue-600 font-bold hover:underline">
                    Mua thẻ ngay →
                  </a>
                </div>
              </c:otherwise>
            </c:choose>
          </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <div class="px-6 py-4 border-t border-gray-100 flex justify-center">
            <nav class="flex space-x-2">
              <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?tab=${currentTab}&page=${i}"
                   class="px-4 py-2 rounded-lg font-medium transition ${currentPage == i ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'}">
                  ${i}
                </a>
              </c:forEach>
            </nav>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</section>

<script>
function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(() => {
    const toast = document.createElement('div');
    toast.className = 'fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg z-50';
    toast.innerHTML = '<i class="bx bx-check-circle mr-2"></i> Đã sao chép!';
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2000);
  });
}
</script>

<jsp:include page="./components/footer.jsp" />

