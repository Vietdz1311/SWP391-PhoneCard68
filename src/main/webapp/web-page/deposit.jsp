<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="./components/header.jsp" />

<section class="py-16 bg-gradient-to-br from-slate-50 to-emerald-50 min-h-screen">
  <div class="container mx-auto px-4">
    <div class="max-w-xl mx-auto">
      
      <div class="text-center mb-10">
        <div class="w-20 h-20 bg-gradient-to-br from-green-400 to-emerald-600 rounded-2xl mx-auto flex items-center justify-center mb-4 shadow-lg">
          <i class='bx bx-wallet text-white text-4xl'></i>
        </div>
        <h1 class="text-4xl font-bold text-gray-900 mb-3">Nạp tiền vào ví</h1>
        <p class="text-gray-600 text-lg">Nạp tiền nhanh chóng qua VNPay</p>
      </div>

      <c:if test="${not empty error}">
        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-8 rounded-r-xl">
          <div class="flex items-center">
            <i class='bx bx-error-circle text-red-500 text-2xl mr-3'></i>
            <p class="text-red-700 font-medium">${error}</p>
          </div>
        </div>
      </c:if>

      <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
        <!-- Current Balance -->
        <div class="bg-gradient-to-r from-green-500 to-emerald-600 px-8 py-6 text-white">
          <p class="text-green-100 text-sm mb-1">Số dư hiện tại</p>
          <p class="text-4xl font-bold"><fmt:formatNumber value="${sessionScope.user.walletBalance}" type="number"/>₫</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/deposit" method="post" class="p-8">
          <c:if test="${not empty returnTo}">
            <input type="hidden" name="returnTo" value="${returnTo}">
          </c:if>
          
          <div class="mb-6">
            <label class="block text-gray-700 font-bold mb-3">Số tiền muốn nạp</label>
            <div class="relative">
              <input type="text" name="amount" id="amountInput"
                     value="${suggestedAmount != null ? suggestedAmount : ''}"
                     placeholder="Nhập số tiền"
                     class="w-full px-5 py-4 text-2xl font-bold text-gray-900 border-2 border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                     oninput="formatAmount(this)"
                     required>
              <span class="absolute right-5 top-1/2 -translate-y-1/2 text-gray-500 font-bold text-xl">₫</span>
            </div>
            <p class="text-sm text-gray-500 mt-2">Tối thiểu: 10,000₫ - Tối đa: 100,000,000₫</p>
          </div>
          
          <div class="mb-8">
            <p class="text-gray-700 font-medium mb-3">Chọn nhanh:</p>
            <div class="grid grid-cols-3 gap-3">
              <button type="button" onclick="setAmount(50000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                50,000₫
              </button>
              <button type="button" onclick="setAmount(100000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                100,000₫
              </button>
              <button type="button" onclick="setAmount(200000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                200,000₫
              </button>
              <button type="button" onclick="setAmount(500000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                500,000₫
              </button>
              <button type="button" onclick="setAmount(1000000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                1,000,000₫
              </button>
              <button type="button" onclick="setAmount(2000000)" 
                      class="quick-amount py-3 px-4 bg-gray-100 hover:bg-green-100 hover:text-green-700 rounded-xl font-bold text-gray-700 transition">
                2,000,000₫
              </button>
            </div>
          </div>
          
          <div class="bg-gray-50 rounded-xl p-5 mb-8">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 bg-white rounded-xl flex items-center justify-center shadow-sm">
                <img src="https://sandbox.vnpayment.vn/paymentv2/images/icons/mics/32/vnpay.svg" alt="VNPay" class="h-8">
              </div>
              <div>
                <p class="font-bold text-gray-900">Thanh toán qua VNPay</p>
                <p class="text-sm text-gray-500">ATM nội địa, Visa, MasterCard, QR Code</p>
              </div>
            </div>
          </div>
          
          <button type="submit" 
                  class="w-full bg-gradient-to-r from-green-500 to-emerald-600 text-white font-bold text-lg py-4 rounded-xl 
                         hover:from-green-600 hover:to-emerald-700 transition-all duration-300 shadow-lg hover:shadow-xl 
                         transform hover:-translate-y-0.5 flex items-center justify-center gap-2">
            <i class='bx bx-wallet'></i>
            Nạp tiền ngay
          </button>
        </form>
      </div>

      <div class="mt-6 text-center">
        <a href="${pageContext.request.contextPath}/profile" 
           class="inline-flex items-center text-gray-600 hover:text-green-600 font-medium transition">
          <i class='bx bx-chevron-left mr-1'></i> Quay lại trang cá nhân
        </a>
      </div>
    </div>
  </div>
</section>

<script>
function formatAmount(input) {
  let value = input.value.replace(/[^\d]/g, '');
  if (value) {
    value = parseInt(value).toLocaleString('vi-VN');
  }
  input.value = value;
}

function setAmount(amount) {
  document.getElementById('amountInput').value = amount.toLocaleString('vi-VN');
  
  document.querySelectorAll('.quick-amount').forEach(btn => {
    btn.classList.remove('bg-green-100', 'text-green-700', 'ring-2', 'ring-green-500');
  });
  event.target.classList.add('bg-green-100', 'text-green-700', 'ring-2', 'ring-green-500');
}

document.addEventListener('DOMContentLoaded', function() {
  const input = document.getElementById('amountInput');
  if (input.value) {
    let value = input.value.replace(/[^\d]/g, '');
    if (value) {
      input.value = parseInt(value).toLocaleString('vi-VN');
    }
  }
});
</script>

<jsp:include page="./components/footer.jsp" />

