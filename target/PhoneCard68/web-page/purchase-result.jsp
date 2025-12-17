<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gradient-to-br from-slate-50 to-blue-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-2xl mx-auto">
      
      <c:choose>
        <c:when test="${success}">
          <!-- Success State -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden">
            <!-- Success Header -->
            <div class="bg-gradient-to-r from-green-400 to-emerald-600 px-8 py-12 text-center">
              <div class="w-24 h-24 bg-white rounded-full mx-auto flex items-center justify-center mb-6 shadow-lg">
                <i class='bx bx-check text-green-500 text-6xl'></i>
              </div>
              <h1 class="text-3xl font-bold text-white mb-2">Thanh toán thành công!</h1>
              <p class="text-green-100 text-lg">Đơn hàng #${order.orderId} đã được xác nhận</p>
            </div>
            
            <!-- Card Information -->
            <div class="p-8">
              <div class="bg-gradient-to-br from-blue-600 to-indigo-700 rounded-2xl p-6 text-white mb-8 relative overflow-hidden">
                <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-1/2 translate-x-1/2"></div>
                <div class="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full translate-y-1/2 -translate-x-1/2"></div>
                
                <div class="relative z-10">
                  <div class="flex items-center justify-between mb-6">
                    <span class="text-blue-200 text-sm font-medium">THÔNG TIN THẺ CÀO</span>
                    <span class="bg-white/20 px-3 py-1 rounded-full text-xs font-bold">${order.cardProduct.provider.providerName}</span>
                  </div>
                  
                  <div class="space-y-4">
                    <div>
                      <p class="text-blue-200 text-xs mb-1">Seri</p>
                      <p class="font-mono text-xl tracking-wider">${order.cardInventory.serialNumber}</p>
                    </div>
                    <div>
                      <p class="text-blue-200 text-xs mb-1">Mã thẻ</p>
                      <div class="flex items-center gap-3">
                        <p id="cardCode" class="font-mono text-2xl tracking-wider font-bold">${order.cardInventory.cardCode}</p>
                        <button onclick="copyCardCode()" 
                                class="bg-white/20 hover:bg-white/30 p-2 rounded-lg transition"
                                title="Sao chép mã thẻ">
                          <i class='bx bx-copy text-xl'></i>
                        </button>
                      </div>
                    </div>
                    <div class="flex justify-between items-center pt-4 border-t border-white/20">
                      <div>
                        <p class="text-blue-200 text-xs">Mệnh giá</p>
                        <p class="font-bold text-xl"><fmt:formatNumber value="${order.cardProduct.faceValue}" type="number"/>₫</p>
                      </div>
                      <div class="text-right">
                        <p class="text-blue-200 text-xs">Hạn sử dụng</p>
                        <p class="font-bold">${order.cardInventory.expiryDate}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Order Details -->
              <div class="border border-gray-200 rounded-xl p-6 mb-8">
                <h3 class="font-bold text-gray-900 mb-4">Chi tiết đơn hàng</h3>
                <div class="space-y-3 text-sm">
                  <div class="flex justify-between">
                    <span class="text-gray-600">Mã đơn hàng</span>
                    <span class="font-semibold">#${order.orderId}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-gray-600">Sản phẩm</span>
                    <span class="font-semibold">${order.cardProduct.productName}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-gray-600">Nhà mạng</span>
                    <span class="font-semibold">${order.cardProduct.provider.providerName}</span>
                  </div>
                  <div class="flex justify-between">
                    <span class="text-gray-600">Thời gian</span>
                    <span class="font-semibold">${order.orderDate}</span>
                  </div>
                  <div class="flex justify-between pt-3 border-t border-gray-100">
                    <span class="text-gray-900 font-bold">Tổng thanh toán</span>
                    <span class="font-bold text-lg text-green-600">
                      <fmt:formatNumber value="${order.finalAmount}" type="number"/>₫
                    </span>
                  </div>
                </div>
              </div>
              
              <!-- Important Notice -->
              <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-8">
                <div class="flex items-start gap-3">
                  <i class='bx bx-info-circle text-amber-500 text-xl flex-shrink-0 mt-0.5'></i>
                  <div class="text-sm text-amber-800">
                    <p class="font-bold mb-1">Lưu ý quan trọng:</p>
                    <ul class="list-disc list-inside space-y-1 text-amber-700">
                      <li>Vui lòng lưu lại mã thẻ và seri để sử dụng</li>
                      <li>Mã thẻ chỉ hiển thị một lần, không hỗ trợ khôi phục</li>
                      <li>Thẻ có hạn sử dụng, vui lòng nạp trước khi hết hạn</li>
                    </ul>
                  </div>
                </div>
              </div>
              
              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row gap-4">
                <a href="${pageContext.request.contextPath}/products" 
                   class="flex-1 bg-gradient-to-r from-blue-600 to-indigo-600 text-white font-bold py-4 rounded-xl text-center hover:from-blue-700 hover:to-indigo-700 transition shadow-lg">
                  <i class='bx bx-cart mr-2'></i> Tiếp tục mua hàng
                </a>
                <a href="${pageContext.request.contextPath}/history" 
                   class="flex-1 bg-gray-100 text-gray-700 font-bold py-4 rounded-xl text-center hover:bg-gray-200 transition">
                  <i class='bx bx-history mr-2'></i> Xem lịch sử
                </a>
              </div>
            </div>
          </div>
        </c:when>
        
        <c:otherwise>
          <!-- Failed State -->
          <div class="bg-white rounded-3xl shadow-2xl overflow-hidden">
            <div class="bg-gradient-to-r from-red-400 to-pink-600 px-8 py-12 text-center">
              <div class="w-24 h-24 bg-white rounded-full mx-auto flex items-center justify-center mb-6 shadow-lg">
                <i class='bx bx-x text-red-500 text-6xl'></i>
              </div>
              <h1 class="text-3xl font-bold text-white mb-2">Đơn hàng không thành công</h1>
              <p class="text-red-100 text-lg">Vui lòng thử lại hoặc liên hệ hỗ trợ</p>
            </div>
            
            <div class="p-8 text-center">
              <p class="text-gray-600 mb-8">Đơn hàng của bạn đã bị hủy hoặc không thể hoàn thành. Số tiền (nếu đã thanh toán) sẽ được hoàn lại trong 24h.</p>
              
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

<script>
function copyCardCode() {
  const cardCode = document.getElementById('cardCode').textContent;
  navigator.clipboard.writeText(cardCode).then(() => {
    const toast = document.createElement('div');
    toast.className = 'fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-xl shadow-lg z-50 animate-bounce';
    toast.innerHTML = '<i class="bx bx-check-circle mr-2"></i> Đã sao chép mã thẻ!';
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2000);
  });
}
</script>

<jsp:include page="./components/footer.jsp" />

